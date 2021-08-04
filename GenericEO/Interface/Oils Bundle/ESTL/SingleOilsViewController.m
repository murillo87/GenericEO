////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       SingleOilsViewController.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "SingleOilsViewController.h"

#import "NoteCell.h"
#import "GuideTableViewCell.h"
#import "AddNoteTableViewCell.h"
#import "SuggestedOilsTableCell.h"
#import "SingleColumnTableTableViewCell.h"
#import "ReviewTableViewCell.h"

#import "AddNoteViewController.h"
#import "WriteReviewViewController.h"

#import "PricesPopupView.h"

#import "Constants.h"
#import "NetworkManager.h"
#import "CoreDataManager.h"
#import "ReviewManager.h"
#import "UserManager.h"

#import "UIImageView+AFNetworking.h"
#import "LUNSegmentedControl.h"
#import "MBProgressHUD.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kGuideCell @"GuideTableViewCell"
#define kNoteCell @"NoteCell"
#define kAddNoteCell @"AddNoteTableViewCell"
#define kSuggestedOilsCell @"SuggestedOilsTableCell"
#define kSingleColumnTableTableViewCell @"SingleColumnTableTableViewCell"
#define kReviewCell @"ReviewTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

static NSString * const ParseKeyName = @"name";
static NSString * const ParseKeyImage = @"imageStr";

static NSInteger const BlendsWithTableViewTag = 100;
static NSInteger const SingleOilsIncludedTableViewTag = 101;
static NSInteger const CompanionOilsTableViewTag = 102;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface SingleOilsViewController () <UITableViewDelegate, UITableViewDataSource, PricesPopupViewDelegate,
                                        LUNSegmentedControlDataSource, LUNSegmentedControlDelegate, ReviewTableViewCellDelegate>

#pragma mark - Interface Elements

/// Top color view.
@property (nonatomic, strong) IBOutlet UIView *topColorView;

/// View containing the tableview and segmented control.
@property (nonatomic, strong) IBOutlet UIView *mainView;

/// Button displaying the oil's current star rating.
@property (nonatomic, strong) IBOutlet UIButton *starRatingButton;

/// Button to see prices for the object.
@property (nonatomic, strong) IBOutlet UIButton *pricesButton;

/// ImageView displaying background image for the oil.
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

/// Segmented control to change what information is displayed by the tableview.
@property (nonatomic, strong) IBOutlet LUNSegmentedControl *segmentedControl;

/// Progress indicator for the view.
@property (nonatomic, strong) MBProgressHUD *progressHUD;

#pragma mark - Instance Variables

/// Array all overview keys available for the object
@property (nonatomic, strong) NSMutableArray *tabOneKeys;

/// Array of all uses keys available for the object
@property (nonatomic, strong) NSMutableArray *tabTwoKeys;

/// Array of all safety keys available for the object
@property (nonatomic, strong) NSMutableArray *tabThreeKeys;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation SingleOilsViewController

- (id)init {
    self = [super init];
    if (self) {
        self.oilVCDelegate = self;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    self.oilVCDelegate = self; // Set this before [super] call
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nameLabel.text = self.object.name;
#ifdef GENERIC
    NSString *imgStr = [NSString stringWithFormat:@"%@.png", self.object.uuid];
    self.iconImageView.image = [UIImage imageNamed:imgStr];
    
#elif DOTERRA
    // Hide the prices button
    self.pricesButton.hidden = YES;
    
    if ([self.object[@"type"] containsString:@"Oil"]) {
        self.iconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
    } else if ([self.object[@"type"] containsString:@"RollOn"]) {
        self.iconImageView.image = [UIImage imageNamed:@"bottle-doterra-touch"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
    }
    self.iconImageView.backgroundColor = [UIColor colorWithHexString:self.object[@"color"]];
      
#elif YOUNGLIVING
    self.pricesButton.hidden = YES;
    if ([self.object[@"type"] isEqualToString:@"Oil-Light"]) {
        self.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-light"];
    } else if ([self.object[@"type"] isEqualToString:@"Roll-On"]) {
        self.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-rollon"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving"];
    }
    self.iconImageView.backgroundColor = [UIColor colorWithHexString:self.object[@"color"]];
#endif
    
    // Configure the views
    self.topColorView.backgroundColor = [UIColor colorForType:EODataTypeSingleOil];
    self.mainView.layer.cornerRadius = 22.;
    self.mainView.layer.masksToBounds = YES;
    
    // Format buttons
    self.pricesButton.layer.cornerRadius = 22.0;
    self.addMyOilsButton.layer.cornerRadius = 22.0;
    self.favoriteButton.layer.cornerRadius = 22.0;
    
    // Segmented Control setup
    self.segmentedControl.selectorViewColor = [UIColor clearColor];
    self.segmentedControl.shadowsEnabled = NO;
    self.segmentedControl.applyCornerRadiusToSelectorView = YES;
    self.segmentedControl.cornerRadius = 22;
    self.segmentedControl.delegate = self;
    self.segmentedControl.dataSource = self;
    
    // Tableview setup
    self.tableView.alpha = 0.0;
    [self.tableView registerNib:[UINib nibWithNibName:kGuideCell bundle:nil] forCellReuseIdentifier:kGuideCell];
    [self.tableView registerNib:[UINib nibWithNibName:kNoteCell bundle:nil] forCellReuseIdentifier:kNoteCell];
    [self.tableView registerNib:[UINib nibWithNibName:kAddNoteCell bundle:nil] forCellReuseIdentifier:kAddNoteCell];
    [self.tableView registerNib:[UINib nibWithNibName:kSuggestedOilsCell bundle:nil] forCellReuseIdentifier:kSuggestedOilsCell];
    [self.tableView registerNib:[UINib nibWithNibName:kSingleColumnTableTableViewCell bundle:nil] forCellReuseIdentifier:kSingleColumnTableTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:kReviewCell bundle:nil] forCellReuseIdentifier:kReviewCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width/2;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [UIView animateWithDuration:0.1 animations:^{
        self.tableView.alpha = 1.0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)seeReviews:(id)sender {
    [self.segmentedControl setCurrentState:1];
    [self.segmentedControl.delegate segmentedControl:self.segmentedControl didChangeStateFromStateAtIndex:self.segmentedControl.currentState toStateAtIndex:1];
}

- (IBAction)seePrices:(UIButton *)sender {
    PricesPopupView *view = [[PricesPopupView alloc] initWithFrame:[UIScreen mainScreen].bounds andPricingSources:self.sourceObject];
    view.delegate = self;
    view.alpha = 0.0;
    [self.view addSubview:view];
    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = 1.0;
    }];
    
    IPAAnalyticsEvent *event = [IPAAnalyticsEvent eventWithName:AnalyticsViewedOilPrices];
    [event setValue:[NSString stringWithFormat:@"%@", self.object.name]
       forAttribute:AnalyticsNameAttribute];
    [[IPAAnalyticsManager sharedInstance] reportEvent:event];
}


#pragma mark - OilViewControllerDelegate

- (void)separateKeysForOil:(PFOil *)oil {
    
    self.tabOneKeys = [[NSMutableArray alloc] init];
    if ([self isValid:oil.scientificName]) [self.tabOneKeys addObject:@"scientificName"];
    if ([self isValid:oil.summaryDescription]) [self.tabOneKeys addObject:@"summaryDescription"];
    if ([self isValid:oil.otherNames]) [self.tabOneKeys addObject:@"otherNames"];
    if ([self isValid:oil.scent]) [self.tabOneKeys addObject:@"scent"];

    self.tabTwoKeys = [[NSMutableArray alloc] init];
    if (oil.applicationMethods != nil) [self.tabTwoKeys addObject:@"applicationMethods"];
    if (oil.medicialUses != nil) [self.tabTwoKeys addObject:@"medicialUses"];
    if (oil.blendsWith != nil) [self.tabTwoKeys addObject:@"blendsWith"];
    
    self.tabThreeKeys = [[NSMutableArray alloc] init];
    if ([self isValid:oil.precautionsText]) [self.tabThreeKeys addObject:@"precautionsText"];
    if (oil.precautionsList != nil) [self.tabThreeKeys addObject:@"precautionsList"];
    
}

- (void)separateKeysForDoterraOil:(PFDoterraOil *)oil {
    self.tabOneKeys = [[NSMutableArray alloc] init];
    self.tabTwoKeys = [[NSMutableArray alloc] init];
    self.tabThreeKeys = [[NSMutableArray alloc] init];
    self.reviews = [[NSArray alloc] init];
    
    // Handle single oils and blend keys differently
    if ([oil.category isEqualToString:@"Proprietary-blends"]) {
        
    } else {
        if ([self isValid:oil.scientificName]) [self.tabOneKeys addObject:@"scientificName"];
        if ([self isValid:oil.otherNames]) [self.tabOneKeys addObject:@"otherNames"];
    }
    
    // The keys below are handled identically for all doterra oils
    if ([self isValid:oil.summaryDescription]) [self.tabOneKeys addObject:@"summaryDescription"];
    if ([self isValid:oil.scent]) [self.tabOneKeys addObject:@"scent"];
    if ([self isValid:oil.plantPart]) [self.tabOneKeys addObject:@"plantPart"];
    if ([self isValid:oil.collectionMethod]) [self.tabOneKeys addObject:@"collectionMethod"];
    if ([self isValid:oil.mainConstituents]) [self.tabOneKeys addObject:@"mainConstituents"];
    if (oil.benefits != nil) [self.tabOneKeys addObject:@"benefits"];
    if ([self isValid:oil.longDescription]) [self.tabOneKeys addObject:@"longDescription"];
    
    if (oil.applicationMethods != nil) [self.tabTwoKeys addObject:@"applicationMethods"];
    if (oil.blendsWith.count > 0) [self.tabTwoKeys addObject:@"blendsWith"];
    if ([self isValid:oil.useDiffusion]) [self.tabTwoKeys addObject:@"useDiffusion"];
    if ([self isValid:oil.useInternal]) [self.tabTwoKeys addObject:@"useInternal"];
    if ([self isValid:oil.useTopical]) [self.tabTwoKeys addObject:@"useTopical"];
    if ([self isValid:oil.precautionsText]) [self.tabTwoKeys addObject:@"precautionsText"];
    
    if (oil.doterraPartNumber != nil) [self.tabThreeKeys addObject:@"doterraPartNumber"];
    if (oil.doterraVolume != nil) [self.tabThreeKeys addObject:@"doterraVolume"];
    if (oil.doterraPriceRetail != nil) [self.tabThreeKeys addObject:@"doterraPriceRetail"];
    if (oil.doterraPriceWholesale != nil) [self.tabThreeKeys addObject:@"doterraPriceWholesale"];
    if (oil.doterraPV != nil) [self.tabThreeKeys addObject:@"doterraPV"];
    [self.tabThreeKeys addObject:@"available"];
    [self.tabThreeKeys addObject:@"limitedEdition"];
}

- (void)separateKeysForYoungLivingOil:(PFYoungLivingOil *)oil {
    
    self.tabOneKeys = [[NSMutableArray alloc] init];
    if ([self isValid:oil.summaryDescription]) [self.tabOneKeys addObject:@"summaryDescription"];
    if ([self isValid:oil.scientificName]) [self.tabOneKeys addObject:@"scientificName"];
    if ([self isValid:oil.scent]) [self.tabOneKeys addObject:@"scent"];
    if ([self isValid:oil.botanicalFamily]) [self.tabOneKeys addObject:@"botanicalFamily"];
    if ([self isValid:oil.plantPart]) [self.tabOneKeys addObject:@"plantPart"];
    if ([self isValid:oil.collectionMethod]) [self.tabOneKeys addObject:@"collectionMethod"];
    if ([self isValid:oil.region]) [self.tabOneKeys addObject:@"region"];
    if (oil.benefits != nil && oil.benefits.count > 0) [self.tabOneKeys addObject:@"benefits"];
    if (oil.blendsWith != nil && oil.blendsWith.count > 0) [self.tabOneKeys addObject:@"blendsWith"];
    if (oil.singleOilsIncluded && oil.singleOilsIncluded.count > 0) [self.tabOneKeys addObject:@"singleOilsIncluded"];
    if ([self isValid:oil.singleOilsIncludedDescription]) [self.tabOneKeys addObject:@"singleOilsIncludedDescription"];
    if (oil.companionOils != nil && oil.companionOils.count > 0) [self.tabOneKeys addObject:@"companionOils"];
    if ([self isValid:oil.companionOilsDescription]) [self.tabOneKeys addObject:@"companionOilsDescription"];
        
    self.tabTwoKeys = [[NSMutableArray alloc] init];
    if (oil.applicationMethods != nil && oil.applicationMethods.count > 0) [self.tabTwoKeys addObject:@"applicationMethods"];
    if (oil.uses != nil && oil.uses.count > 0) [self.tabTwoKeys addObject:@"uses"];
    if ([self isValid:oil.useTopical]) [self.tabTwoKeys addObject:@"useTopical"];
    if ([self isValid:oil.useDiffusion]) [self.tabTwoKeys addObject:@"useDiffusion"];
    if ([self isValid:oil.useInternal]) [self.tabTwoKeys addObject:@"useInternal"];
    if ([self isValid:oil.usesCommon]) [self.tabTwoKeys addObject:@"usesCommon"];
    if ([self isValid:oil.useHistorical]) [self.tabTwoKeys addObject:@"useHistorical"];
    if ([self isValid:oil.usesMedicinalFrench]) [self.tabTwoKeys addObject:@"usesMedicinalFrench"];
    if ([self isValid:oil.usesOther]) [self.tabTwoKeys addObject:@"usesOther"];
    if ([self isValid:oil.folklore]) [self.tabTwoKeys addObject:@"folklore"];
    if ([self isValid:oil.bodySystemsAffected]) [self.tabTwoKeys addObject:@"bodySystemsAffected"];
    if ([self isValid:oil.precautionsText]) [self.tabTwoKeys addObject:@"precautionsText"];
    if ([self isValid:oil.note]) [self.tabTwoKeys addObject:@"note"];
    
    self.tabThreeKeys = [[NSMutableArray alloc] init];
    if (oil.youngLivingItemNumber != nil) [self.tabThreeKeys addObject:@"youngLivingItemNumber"];
    if (oil.youngLivingVolume != nil) [self.tabThreeKeys addObject:@"youngLivingVolume"];
    if (oil.youngLivingPriceRetail != nil) [self.tabThreeKeys addObject:@"youngLivingPriceRetail"];
    if (oil.youngLivingPriceWholesale != nil) [self.tabThreeKeys addObject:@"youngLivingPriceWholesale"];
    [self.tabThreeKeys addObject:@"available"];
}

- (void)setFavoriteButtonSelected:(BOOL)selected {
    UIImage *img = [UIImage imageNamed:@"heart-outline"];
    UIImage *sImg = [UIImage imageNamed:@"heart-fill"];
    [self.favoriteButton setImage:(selected) ? sImg : img forState:UIControlStateNormal];
    [self updateButton:self.favoriteButton withSelectedColor:[UIColor accentRed] isSelected:selected];
}

- (void)setMyOilButtonSelected:(BOOL)selected {
    UIImage *img = [UIImage imageNamed:@"oil-outline"];
    UIImage *sImg = [UIImage imageNamed:@"oil-fill-white"];
    [self.addMyOilsButton setImage:(selected) ? sImg : img forState:UIControlStateNormal];
    [self updateButton:self.addMyOilsButton withSelectedColor:[UIColor targetAccentColor] isSelected:selected];
}

- (void)updateButton:(UIButton *)button withSelectedColor:(UIColor *)sColor isSelected:(BOOL)selected {
    UIColor *tint = (selected) ? [UIColor whiteColor] : [UIColor blackColor];
    UIColor *background = (selected) ? sColor : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    CGColorRef border = (selected) ? sColor.CGColor : [UIColor blackColor].CGColor;
    
    button.tintColor = tint;
    button.backgroundColor = background;
    button.layer.borderColor = border;
}

#pragma mark - PricesPopupViewDelegate

- (void)shouldClosePricesPopupView:(UIView *)view {
    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

#pragma mark - LUNSegmentedControlDelegate

- (void)segmentedControl:(LUNSegmentedControl *)segmentedControl didChangeStateFromStateAtIndex:(NSInteger)fromIndex toStateAtIndex:(NSInteger)toIndex {
    
    // Display HUD
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    [self.progressHUD showAnimated:YES];
    
    [self.tableView reloadData];
    
    
    [self.progressHUD hideAnimated:YES];
}

#pragma mark - LUNSegmentedControlDatasource

- (NSArray<UIColor *> *)segmentedControl:(LUNSegmentedControl *)segmentedControl gradientColorsForStateAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @[[UIColor colorWithRed:160/255.0 green:223/255.0 blue:56/255.0 alpha:1.0],
                     [UIColor colorWithRed:177/255.0 green:255/255.0 blue:0/255.0 alpha:1.0]];
            break;
            
        case 1:
            return @[[UIColor colorWithRed:78/255.0 green:252/255.0 blue:208/255.0 alpha:1.0],
                     [UIColor colorWithRed:51/255.0 green:199/255.0 blue:244/255.0 alpha:1.0]];
            break;
            
        case 2:
            return @[[UIColor colorWithRed:178/255.0 green:0/255.0 blue:235/255.0 alpha:1.0],
                     [UIColor colorWithRed:233/255.0 green:0/255.0 blue:147/255.0 alpha:1.0]];
            break;
            
        default:
            return @[[UIColor colorWithRed:78/255.0 green:252/255.0 blue:208/255.0 alpha:1.0],
                     [UIColor colorWithRed:51/255.0 green:199/255.0 blue:244/255.0 alpha:1.0]];
            break;
    }
    return nil;
}

- (NSInteger)numberOfStatesInSegmentedControl:(LUNSegmentedControl *)segmentedControl {
    return 4;
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForStateAtIndex:(NSInteger)index {
#if defined(DOTERRA) || defined (AB_DOTERRA)
    NSArray *titles = @[NSLocalizedString(@"Overview", nil),
                        NSLocalizedString(@"Reviews", nil),
                        NSLocalizedString(@"Uses", nil),
                        NSLocalizedString(@"doTERRA", nil)];
#elif YOUNGLIVING
    NSArray *titles = @[NSLocalizedString(@"Overview", nil),
                        NSLocalizedString(@"Uses", nil),
                        NSLocalizedString(@"YL", nil),
                        NSLocalizedString(@"Notes", nil)];
#else
    NSArray *titles = @[NSLocalizedString(@"Overview", nil),
                        NSLocalizedString(@"Uses", nil),
                        NSLocalizedString(@"Safety", nil),
                        NSLocalizedString(@"Notes", nil)];
#endif
    return [[NSAttributedString alloc] initWithString:titles[index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]}];
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForSelectedStateAtIndex:(NSInteger)index {
#if defined(DOTERRA) || defined (AB_DOTERRA)
    NSArray *titles = @[NSLocalizedString(@"Overview", nil),
                        NSLocalizedString(@"Reviews", nil),
                        NSLocalizedString(@"Uses", nil),
                        NSLocalizedString(@"doTERRA", nil)];
#elif YOUNGLIVING
    NSArray *titles = @[NSLocalizedString(@"Overview", nil),
                        NSLocalizedString(@"Uses", nil),
                        NSLocalizedString(@"YL", nil),
                        NSLocalizedString(@"Notes", nil)];
#else
    NSArray *titles = @[NSLocalizedString(@"Overview", nil),
                        NSLocalizedString(@"Uses", nil),
                        NSLocalizedString(@"Safety", nil),
                        NSLocalizedString(@"Notes", nil)];
#endif
    return [[NSAttributedString alloc] initWithString:titles[index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]}];
}

#pragma mark - ReviewTableViewCellDelegate

- (void)shouldUpvoteReviewForCell:(ReviewTableViewCell *)cell {
    [[[ReviewManager alloc] init] upVoteReview:cell.review withCompletion:^(BOOL success, NSError * _Nullable error) {
       
    }];
}

- (void)shouldDownvoteReviewForCell:(ReviewTableViewCell *)cell {
    [[[ReviewManager alloc] init] downVoteReview:cell.review withCompletion:^(BOOL success, NSError * _Nullable error) {
       
    }];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *selectedOil;
    if (tableView.tag == BlendsWithTableViewTag) {
        selectedOil = self.blendsWith[indexPath.row];
    } else if (tableView.tag == CompanionOilsTableViewTag) {
        selectedOil = self.companionOils[indexPath.row];
    } else if (tableView.tag == SingleOilsIncludedTableViewTag) {
        selectedOil = self.singleOilsIncluded[indexPath.row];
    }
    
    // Handle blendsWith tableViewCell touches
    if (selectedOil != nil) {
#ifdef GENERIC
        OilViewController *vc = [[OilViewController alloc] initWithOil:selectedOil andSources:nil];
#elif DOTERRA
        OilViewController *vc = [[OilViewController alloc] initWithDoterraOil:selectedOil];
#elif YOUNGLIVING
        OilViewController *vc = [[OilViewController alloc] initWithYoungLivingOil:selectedOil];
#endif
        [self.navigationController showViewController:vc sender:self];
        return;
    }
    
    switch (self.segmentedControl.currentState) {
        case 1: { // Reviews + MyNotes
            if (indexPath.section == 0 && indexPath.row == 0) {
                // Only the first row in the first section will be MyNotes, all others will be reviews (and not selectable)
//                AddNoteViewController *vc = [[AddNoteViewController alloc] initForEntity:self.object withNote:nil];
                WriteReviewViewController *vc = [[WriteReviewViewController alloc] initForParentObject:self.object withExistingReview:nil];
                [self.navigationController showViewController:vc sender:self];
            }
        } break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Reviews tab has two sections, all other tabs have one.
    
    switch (self.segmentedControl.currentState) {
        case 1: // Reviews + MyNotes
            return 2;
            break;
            
        default:
            return 1;
            break;
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.segmentedControl.currentState) {
        case 0:
            return self.tabOneKeys.count;
            break;
            
        case 1: { // Reviews + MyNotes
            
            switch (section) {
                case 1: {
                    // Determine if the reviews contains one by the current user
                    if (self.userReview) {
                        return self.reviews.count;
                    } else {
                        return self.reviews.count+1;
                    }
                } break;
                    
                default:
                    // MyNotes only displays one cell ever.
                    return 1;
                    break;
            }
        }   break;
                
        case 2:
            return self.tabTwoKeys.count;
            break;
            
        case 3:
            return self.tabThreeKeys.count;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGuideCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *key = @"";
    
    switch (self.segmentedControl.currentState) {
        case 0: key = self.tabOneKeys[indexPath.row];
            break;
            
        case 1: { // Reviews + MyNotes
            switch (indexPath.section) {
                case 0: { // MyNotes
                    MyNotes *note = [[CoreDataManager sharedManager] getNoteForID:self.object.uuid];
                    if (note != nil) {
                        // Display note cell if a note exists
                        NoteCell *noteCell = [tableView dequeueReusableCellWithIdentifier:kNoteCell];
                        noteCell.noteNameLabel.text = NSLocalizedString(@"Added Note", nil);
                        noteCell.noteNameLabel.textColor = [UIColor targetAccentColor];
                        noteCell.noteTextLabel.text = note.text;
                        noteCell.noteTextLabel.numberOfLines = 0;
                        noteCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        noteCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return noteCell;
                    } else {
                        AddNoteTableViewCell *addNoteCell = [tableView dequeueReusableCellWithIdentifier:kAddNoteCell];
                        addNoteCell.iconImageView.image = [UIImage imageNamed:@"pencil-case"];
                        addNoteCell.titleLabel.text = NSLocalizedString(@"No note", nil);
                        addNoteCell.subtitleLabel.text = NSLocalizedString(@"Tap to add a new note", nil);
                        addNoteCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return addNoteCell;
                    }
                } break;
                    
                default: { // Reviews
                    ReviewTableViewCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:kReviewCell];
                    
                    if (indexPath.row == 0) {
                        if (self.userReview) {
                            [reviewCell configureCellForReview:self.userReview];
                            return reviewCell;
                        } else {
                            AddNoteTableViewCell *addNoteCell = [tableView dequeueReusableCellWithIdentifier:kAddNoteCell];
                            addNoteCell.iconImageView.image = [UIImage imageNamed:@""];
                            addNoteCell.titleLabel.text = NSLocalizedString(@"Add Review", nil);
                            addNoteCell.subtitleLabel.text = NSLocalizedString(@"You haven't reviewed this oil yet. Tap to review.", nil);
                            addNoteCell.selectionStyle = UITableViewCellSelectionStyleNone;
                            return addNoteCell;
                        }
                    } else {
                        // If the user has not written a review, reduce the index count by 1. This prevents an array
                        // out of bounds exception since the last index in the tableview will be greater than the size
                        // of the reviews array due to the leave a review cell at the top of the section.
                        NSInteger index = indexPath.row;
                        
                        if (!self.userReview) {
                            index--;
                        }
                        
                        [reviewCell configureCellForReview:self.reviews[index]];
                         return reviewCell;
                    }
                } break;
            }
        } break;
            
        case 2: key = self.tabTwoKeys[indexPath.row];
            break;
        case 3: key = self.tabThreeKeys[indexPath.row];
            break;
            
        
    }
    
    id value = [self.object valueForKey:key];
    NSString *title = [self cellTitleForKey:key];
    cell.name.text = title;
    cell.name.font = [UIFont titleFont];
    cell.name.textColor = [UIColor targetAccentColor];
    cell.subtitle.textColor = [UIColor darkGrayColor];
    
    if ([value isKindOfClass:[NSString class]]) {
        NSString *text = (NSString *)value;
        cell.subtitle.text = text;
        
    // Handle cells that display arrays instead of strings
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)value;
        
        // Determine the key and use correct table view cell
        if ([key isEqualToString:@"blendsWith"]) {
            return [self oilsCellForTableView:tableView withArray:self.blendsWith title:title tag:BlendsWithTableViewTag];
        } else if ([key isEqualToString:@"companionOils"]) {
            return [self oilsCellForTableView:tableView withArray:self.companionOils title:title tag:CompanionOilsTableViewTag];
        } else if ([key isEqualToString:@"singleOilsIncluded"]) {
            return [self oilsCellForTableView:tableView withArray:self.singleOilsIncluded title:title tag:SingleOilsIncludedTableViewTag];
        } else {
            // Create bulleted attributed string for other arrays
            NSMutableAttributedString *ingredientsString = [[NSMutableAttributedString alloc] init];
            
            NSDictionary *normalAttributes = @{
                                               NSFontAttributeName: [UIFont textFont],
                                               NSForegroundColorAttributeName : [UIColor darkGrayColor]
                                               };
            
            NSDictionary *lineAttributes = @{
                                             NSFontAttributeName: [UIFont systemFontOfSize:10.0],
                                             };
            
            for (int i=0; i<array.count; i++) {
                NSString *text = [NSString stringWithFormat:@"\u2022 %@", array[i]];
                
                NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:text attributes:normalAttributes];
                NSAttributedString *br = [[NSAttributedString alloc] initWithString:@"\n" attributes:lineAttributes];
                
                [ingredientsString appendAttributedString:br];
                [ingredientsString appendAttributedString:str1];
                [ingredientsString appendAttributedString:br];
            }
            
            cell.subtitle.attributedText = ingredientsString;
        }
        
    // Handle numbers
    } else if ([value isKindOfClass:[NSNumber class]]) {
        
        NSNumber *num = (NSNumber *)value;
        
        // Distinguish between prices, booleans and other numbers
        if (num == (void*)kCFBooleanFalse || num == (void*)kCFBooleanTrue) {
            
            // Boolean values
            BOOL val = [value boolValue];
            NSString *text = (val == TRUE) ? NSLocalizedString(@"Yes", nil) : NSLocalizedString(@"No", nil);
            cell.subtitle.text = text;
            
            
        } else if ([key.lowercaseString containsString:@"price"]) {
            // Prices
            cell.subtitle.text = [NSString stringWithFormat:@"$%.2f", [num doubleValue]];
        } else {
            // Misc numbers
            cell.subtitle.text = [NSString stringWithFormat:@"%@", num];
        }
        
        cell.subtitle.textColor = [UIColor darkGrayColor];
    }
    
    
    return cell;
}

- (SuggestedOilsTableCell *)oilsCellForTableView:(UITableView *)tableView
                                       withArray:(NSArray *)array
                                           title:(NSString *)title
                                             tag:(NSInteger)tag {
    SuggestedOilsTableCell *tableCell = [tableView dequeueReusableCellWithIdentifier:kSuggestedOilsCell];
    tableCell.titleLabel.text = title;
    tableCell.tableView.tag = tag;
    tableCell.tableView.delegate = self;
    [tableCell shouldDisplayHeaderInBar:NO];
    [tableCell setObjectsForTableView:array shouldFetchData:YES];
    return tableCell;
}

- (NSString *)cellTitleForKey:(NSString *)key {

#ifdef DOTERRA
    // Remove doterra from title
    if ([key containsString:@"doterra"]) {
        key = [key stringByReplacingOccurrencesOfString:@"doterra" withString:@""];
    }
    
    // Move price to end of title
    if ([key containsString:@"Price"]) {
        key = [key stringByReplacingOccurrencesOfString:@"Price" withString:@""];
        key = [key stringByAppendingString:@"Price"];
    }
    
    // Move use key to end of title
    if ([key containsString:@"use"]) {
        key = [key stringByReplacingOccurrencesOfString:@"use" withString:@""];
        key = [key stringByAppendingString:@"Use"];
    }
    
    /**
     Keys below are completely renamed.
     */
    if      ([key isEqualToString:@"PV"])                   return NSLocalizedString(@"Loyalty Rewards PV", nil);
    else if ([key isEqualToString:@"precautionsText"])      return NSLocalizedString(@"Precautions", nil);
    else if ([key isEqualToString:@"summaryDescription"])   return NSLocalizedString(@"Summary", nil);
    else if ([key isEqualToString:@"longDescription"])      return NSLocalizedString(@"Description", nil);
    else if ([key isEqualToString:@"singleOilsIncluded"])   return NSLocalizedString(@"Oils Included in Blend", nil);
    else if ([key isEqualToString:@"singleOilsIncludedDescription"]) return NSLocalizedString(@"About the Included Oils", nil);
#endif
    return [NSString addSpacesBeforeCapitalLettersInString:key].capitalizedString;
}


@end
