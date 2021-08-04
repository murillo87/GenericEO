////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ESTLGuideViewController.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ESTLGuideViewController.h"

#import "GuideTableViewCell.h"
#import "SuggestedOilsTableCell.h"
#import "NoteCell.h"
#import "AddNoteTableViewCell.h"

#import "LUNSegmentedControl.h"

#import "OilViewController.h"
#import "RecipeViewController.h"
#import "AddNoteViewController.h"
#import "UpgradeViewController.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kGuideCell @"GuideTableViewCell"
#define kSuggestedOilsCell @"SuggestedOilsTableCell"
#define kNoteCell @"NoteCell"
#define kAddNoteCell @"AddNoteTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

static NSInteger oilsTableViewTag = 100;
static NSInteger recipesTableViewTag = 200;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ESTLGuideViewController () <UITableViewDelegate, UITableViewDataSource, LUNSegmentedControlDataSource, LUNSegmentedControlDelegate>

#pragma mark - Interface Elements

/// Top color view.
@property (nonatomic, strong) IBOutlet UIView *topColorView;

/// View containing the tableview and segmented control.
@property (nonatomic, strong) IBOutlet UIView *mainView;

/// Button to add note for the object
@property (nonatomic, strong) IBOutlet UIButton *addNoteButton;

/// Segmented control to change what information is displayed by the tableview
@property (nonatomic, strong) IBOutlet LUNSegmentedControl *segmentedControl;

/// ImageView displaying background image for the object
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ESTLGuideViewController

#pragma mark - Lifecycle

- (id)initWithObject:(PFObject *)object {
    self = [super init];
    if (self) {
        self.object = object;
        
        self.tableViewDictionary = [[NSMutableDictionary alloc] init];
        
        [self.tableViewDictionary setValue:[object valueForKey:GuideParseKeyDescription] forKey:@"Description"];
        [self.tableViewDictionary setValue:[object valueForKey:GuideParseKeyOils] forKey:@"Oils"];
        [self.tableViewDictionary setValue:[object valueForKey:GuideParseKeyUsage] forKey:@"Usage"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = [self.object valueForKey:GuideParseKeyName];
    
    // Configure the views
    self.topColorView.backgroundColor = [UIColor colorForType:EODataTypeApplicationCharts];
    self.mainView.layer.cornerRadius = 22.;
    self.mainView.layer.masksToBounds = YES;
    
    // Format button
    self.addNoteButton.layer.cornerRadius = 8;
    self.addNoteButton.layer.borderWidth = 1;
    self.addNoteButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.addNoteButton.backgroundColor = [UIColor whiteColor];
    
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
    [self.tableView registerNib:[UINib nibWithNibName:kSuggestedOilsCell bundle:nil] forCellReuseIdentifier:kSuggestedOilsCell];
    [self.tableView registerNib:[UINib nibWithNibName:kNoteCell bundle:nil] forCellReuseIdentifier:kNoteCell];
    [self.tableView registerNib:[UINib nibWithNibName:kAddNoteCell bundle:nil] forCellReuseIdentifier:kAddNoteCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.segmentedControl.currentState == 1) {
        [self displayPaywallIfNeeded];
    }
    [self.tableView reloadData];
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

#pragma mark - UI

- (void)updateNoteButtonIfNoteExists:(BOOL)hasNote {
    NSString *title = (hasNote) ? NSLocalizedString(@"Edit Note", nil) : NSLocalizedString(@"Add Note", nil);
    [self.addNoteButton setTitle:title forState:UIControlStateNormal];
    
    [self updateButton:self.addNoteButton isSelected:hasNote];
}

- (void)updateButton:(UIButton *)button isSelected:(BOOL)selected {
    UIColor *tint = (selected) ? [UIColor whiteColor] : [UIColor blackColor];
    UIColor *background = (selected) ? [UIColor purpleColor] : [UIColor whiteColor];
    CGColorRef border = (selected) ? [UIColor purpleColor].CGColor : [UIColor blackColor].CGColor;
    
    button.tintColor = tint;
    button.backgroundColor = background;
    button.layer.borderColor = border;
}

#pragma mark - IBActions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (BOOL)doesHaveActiveIAP:(NSArray<IAPProduct *> *)products {
//    for (IAPProduct *product in products) {
//        if (product.status == IAPProductStatusSubscriptionActive) {
//            return YES;
//        }
//    }
//    return NO;
//}

#pragma mark - LUNSegmentedControlDelegate

- (void)segmentedControl:(LUNSegmentedControl *)segmentedControl didChangeStateFromStateAtIndex:(NSInteger)fromIndex toStateAtIndex:(NSInteger)toIndex {
    // Display paywall if applicable for Oils & Recipes sections
    
    if (self.segmentedControl.currentState == 1) {
        [self displayPaywallIfNeeded];
    } else {
        [self hidePaywall];
    }
    [self.tableView reloadData];
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
            
        default:
            return @[[UIColor colorWithRed:178/255.0 green:0/255.0 blue:235/255.0 alpha:1.0],
                     [UIColor colorWithRed:233/255.0 green:0/255.0 blue:147/255.0 alpha:1.0]];
            break;
    }
    return nil;
}

- (NSInteger)numberOfStatesInSegmentedControl:(LUNSegmentedControl *)segmentedControl {
    return 3;
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForStateAtIndex:(NSInteger)index {
    NSArray *titles = @[NSLocalizedString(@"About", nil),
                        NSLocalizedString(@"Recipes", nil),
                        NSLocalizedString(@"MyNotes", nil)];
    return [[NSAttributedString alloc] initWithString:titles[index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]}];
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForSelectedStateAtIndex:(NSInteger)index {
    NSArray *titles = @[NSLocalizedString(@"About", nil),
                        NSLocalizedString(@"Recipes", nil),
                        NSLocalizedString(@"MyNotes", nil)];
    return [[NSAttributedString alloc] initWithString:titles[index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]}];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.segmentedControl.currentState) {
//        case 1: { // Oils Section
//            PFObject *object = [self.tableViewDictionary valueForKey:@"Oils"][indexPath.row];
//            [object fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
//                if (!error) {
//                    OilViewController *vc = [[OilViewController alloc] initWithOil:(PFOil *)object andSources:nil];
//                    [self showViewController:vc sender:self];
//                }
//            }];
//        } break;
            
        case 1: { // Recipes Section
            PFRecipe *recipe = (PFRecipe *)[self.tableViewDictionary valueForKey:@"Recipes"][indexPath.row];
            RecipeViewController *vc = [[RecipeViewController alloc] initWithRecipe:recipe];
            [self.navigationController showViewController:vc sender:self];
        } break;
            
        case 2: { // MyNotes
            AddNoteViewController *vc = [[AddNoteViewController alloc] initForEntity:self.object withNote:nil];
            [self.navigationController showViewController:vc sender:self];
        } break;
            
        default:
            // No actions for about tab
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.segmentedControl.currentState) {
        case 0: // About
        case 1: // Recipes
        case 2: // My Notes
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGuideCell];
    cell.name.font = [UIFont titleFont];
    cell.name.textColor = [UIColor purpleColor];
    
    switch (self.segmentedControl.currentState) {
        case 0: { // About
            switch (indexPath.row) {
                case 0: { // Description
                    cell.name.text = NSLocalizedString(@"Description", nil);
                    cell.subtitle.text = [self.tableViewDictionary valueForKey:@"Description"];
                } break;
                    
                default:
                    break;
            }
        } break;
            
//        case 1: { // Oils
//            NSArray *oils = [self.tableViewDictionary valueForKey:@"Oils"];
//            SuggestedOilsTableCell *suggestionCell = [tableView dequeueReusableCellWithIdentifier:kSuggestedOilsCell];
//            suggestionCell.titleLabel.text = NSLocalizedString(@"Oils", nil);
//            [suggestionCell shouldDisplayHeaderInBar:NO];
//            suggestionCell.titleLabel.textColor = [UIColor accentPurple];
//            suggestionCell.tableView.tag = oilsTableViewTag;
//            suggestionCell.tableView.delegate = self;
//            suggestionCell.tableViewHeight.constant = (oils.count * SuggestedOilsCellChildTableViewCellRowHeight);
//            [suggestionCell setObjectsForTableView:oils shouldFetchData:YES];
//            return suggestionCell;
//        } break;
            
        case 1: { // Recipes
            NSArray *recipes = [self.tableViewDictionary valueForKey:@"Recipes"];
            SuggestedOilsTableCell *suggestionCell = [tableView dequeueReusableCellWithIdentifier:kSuggestedOilsCell];
            suggestionCell.titleLabel.text = NSLocalizedString(@"Recipes", nil);
            suggestionCell.titleLabel.textColor = [UIColor targetAccentColor];
            [suggestionCell shouldDisplayHeaderInBar:NO];
            suggestionCell.cellIconWidth = 0.0;
            suggestionCell.tableView.tag = recipesTableViewTag;
            suggestionCell.tableView.delegate = self;
            suggestionCell.tableViewHeight.constant = (recipes.count * SuggestedOilsCellChildTableViewCellRowHeight);
            [suggestionCell setObjectsForTableView:recipes shouldFetchData:YES];
            return suggestionCell;
        } break;
            
        case 2: { // MyNotes
            MyNotes *note = [[CoreDataManager sharedManager] getNoteForID:self.object[@"uuid"]];
            
            if (note != nil) {
                // Display note cell if a note exists
                NoteCell *noteCell = [tableView dequeueReusableCellWithIdentifier:kNoteCell];
                noteCell.noteNameLabel.text = NSLocalizedString(@"Added Note", nil);
                noteCell.noteTextLabel.text = note.text;
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
            
        default:
            break;
    }
    
    return cell;
}

@end

