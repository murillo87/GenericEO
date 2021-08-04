////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABOilViewController.m
/// @author     Lynette Sesodia
/// @date       3/11/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ABOilViewController.h"

#import "AddNoteViewController.h"
#import "WriteReviewViewController.h"

#import "NoteCell.h"
#import "GuideTableViewCell.h"
#import "ABEmptyTableViewCell.h"
#import "SuggestedOilsTableCell.h"
#import "SingleColumnTableTableViewCell.h"
#import "TwoColumnTableTableViewCell.h"
#import "ReviewTableViewCell.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kGuideCell @"GuideTableViewCell"
#define kNoteCell @"NoteCell"
#define kEmptyCell @"ABEmptyTableViewCell"
#define kSuggestedOilsCell @"SuggestedOilsTableCell"
#define kSingleColumnTableTableViewCell @"SingleColumnTableTableViewCell"
#define kTwoColumnTableTableViewCell @"TwoColumnTableTableViewCell"
#define kReviewCell @"ReviewTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

static NSInteger const BlendsWithTableViewTag = 100;
static NSInteger const SingleOilsIncludedTableViewTag = 101;
static NSInteger const CompanionOilsTableViewTag = 102;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ABOilViewController () <UITableViewDelegate, UITableViewDataSource, ReviewTableViewCellDelegate>

/// Button displaying the oil's current star rating.
@property (nonatomic, strong) IBOutlet UIButton *starRatingButton;

/// Label displaying the number of reviews the oil has.
@property (nonatomic, strong) IBOutlet UILabel *numberOfReviewsLabel;

/// Segmented control to change what information is displayed by the tableview.
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

/// Array all overview keys available for the object
@property (nonatomic, strong) NSMutableArray *tabOneKeys;

/// Array of all uses keys available for the object
@property (nonatomic, strong) NSMutableArray *tabTwoKeys;

/// Array of dictionaries for company product information.
@property (nonatomic, strong) NSMutableArray *coProductInfoArray;

/// Array of dictionaries for quick facts information.
@property (nonatomic, strong) NSMutableArray *quickFactsArray;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ABOilViewController

- (id)init {
    self = [super init];
    if (self) {
        self.oilVCDelegate = self;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nameLabel.text = self.object.name;
    self.nameLabel.font = [UIFont titleFont];
    self.numberOfReviewsLabel.text = [NSString stringWithFormat:@"%lu reviews", self.reviews.count];
    
    self.favoriteButton.tintColor = [UIColor systemRedColor];
    
    self.backButton.tintColor = [UIColor targetAccentColor];
    self.addMyOilsButton.tintColor = [UIColor targetAccentColor];
    
    [self configureOilImage];
    [self configureSegmentedControl];
    [self configureTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.tableView.alpha = 1.0;
    }];
}

- (void)configureOilImage {
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.height/2;
    self.iconImageView.layer.masksToBounds = YES;
    
#ifdef DOTERRA
    if ([self.object[@"type"] containsString:@"Oil"]) {
        self.iconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
    } else if ([self.object[@"type"] containsString:@"RollOn"]) {
        self.iconImageView.image = [UIImage imageNamed:@"bottle-doterra-touch"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
    }
#elif YOUNGLIVING
    if ([self.object[@"type"] isEqualToString:@"Oil-Light"]) {
        self.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-light"];
    } else if ([self.object[@"type"] isEqualToString:@"Roll-On"]) {
        self.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-rollon"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving"];
    }
#endif
    self.iconImageView.backgroundColor = [UIColor colorWithHexString:self.object[@"color"]];
    
}

- (void)configureSegmentedControl {
    self.segmentedControl.backgroundColor = [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1.0];
    self.segmentedControl.selectedSegmentTintColor = [UIColor targetAccentColor];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}
                                         forState:UIControlStateSelected];
    [self.segmentedControl setTitle:NSLocalizedString(@"Overview", nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"Reviews", nil) forSegmentAtIndex:1];
    [self.segmentedControl setTitle:NSLocalizedString(@"Uses", nil) forSegmentAtIndex:2];
#ifdef DOTERRA
    [self.segmentedControl setTitle:NSLocalizedString(@"doTERRA", nil) forSegmentAtIndex:3];
#elif YOUNGLIVING
    [self.segmentedControl setTitle:NSLocalizedString(@"YoungLiving", nil) forSegmentAtIndex:3];
#endif
    [self.segmentedControl addTarget:self action:@selector(segmentedControlSelectedSegmentDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)configureTableView {
    // Tableview setup
    self.tableView.alpha = 0.0;
    [self.tableView registerNib:[UINib nibWithNibName:kGuideCell bundle:nil] forCellReuseIdentifier:kGuideCell];
    [self.tableView registerNib:[UINib nibWithNibName:kNoteCell bundle:nil] forCellReuseIdentifier:kNoteCell];
    [self.tableView registerNib:[UINib nibWithNibName:kEmptyCell bundle:nil] forCellReuseIdentifier:kEmptyCell];
    [self.tableView registerNib:[UINib nibWithNibName:kSuggestedOilsCell bundle:nil] forCellReuseIdentifier:kSuggestedOilsCell];
    [self.tableView registerNib:[UINib nibWithNibName:kSingleColumnTableTableViewCell bundle:nil] forCellReuseIdentifier:kSingleColumnTableTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:kTwoColumnTableTableViewCell bundle:nil] forCellReuseIdentifier:kTwoColumnTableTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:kReviewCell bundle:nil] forCellReuseIdentifier:kReviewCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
}

#pragma mark - Actions

- (IBAction)showReviews:(id)sender {
    // Move segmented control to first index to display review tab and reload table view
    [self.segmentedControl setSelectedSegmentIndex:1];
    [self segmentedControlSelectedSegmentDidChange:self.segmentedControl];
}

#pragma mark - Segmented Control

- (void)segmentedControlSelectedSegmentDidChange:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 1) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    } else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    [self.tableView reloadData];
}

#pragma mark - OilViewControllerProtocol

- (void)separateKeysForOil:(PFOil *)oil {
    // TODO: Before generic AB release
}

- (void)separateKeysForDoterraOil:(PFDoterraOil *)oil {
    self.tabOneKeys = [[NSMutableArray alloc] init];
    self.quickFactsArray = [[NSMutableArray alloc] init];
    self.reviews = [[NSArray alloc] init];
    
    // Handle single oils and blend keys differently
    if (![oil.category isEqualToString:@"Proprietary-blends"]) {
        if ([self isValid:oil.scientificName]) [self.quickFactsArray addObject:[self twoColumnCellDictionaryForKey:@"scientificName"]];
        if ([self isValid:oil.otherNames]) [self.tabOneKeys addObject:@"otherNames"];
    }
    
    // The keys below are handled identically for all doterra oils
    [self.tabOneKeys addObject:@"Quick Facts"];
    if ([self isValid:oil.summaryDescription]) [self.tabOneKeys addObject:@"summaryDescription"];
    if ([self isValid:oil.scent]) [self.quickFactsArray addObject:[self twoColumnCellDictionaryForKey:@"scent"]];
    if ([self isValid:oil.plantPart])[self.quickFactsArray addObject:[self twoColumnCellDictionaryForKey:@"plantPart"]];
    if ([self isValid:oil.collectionMethod]) [self.quickFactsArray addObject:[self twoColumnCellDictionaryForKey:@"collectionMethod"]];
    if ([self isValid:oil.mainConstituents]) [self.quickFactsArray addObject:[self twoColumnCellDictionaryForKey:@"mainConstituents"]];
    if (oil.benefits != nil) [self.tabOneKeys addObject:@"benefits"];
    if ([self isValid:oil.longDescription]) [self.tabOneKeys addObject:@"longDescription"];
    
    self.tabTwoKeys = [[NSMutableArray alloc] init];
    if (oil.applicationMethods != nil) [self.tabTwoKeys addObject:@"applicationMethods"];
    if (oil.blendsWith.count > 0) [self.tabTwoKeys addObject:@"blendsWith"];
    if ([self isValid:oil.useDiffusion]) [self.tabTwoKeys addObject:@"useDiffusion"];
    if ([self isValid:oil.useInternal]) [self.tabTwoKeys addObject:@"useInternal"];
    if ([self isValid:oil.useTopical]) [self.tabTwoKeys addObject:@"useTopical"];
    if ([self isValid:oil.precautionsText]) [self.tabTwoKeys addObject:@"precautionsText"];
    [self.tabTwoKeys addObject:@"FDA Disclaimer"];
    
    self.coProductInfoArray = [[NSMutableArray alloc] init];
    if (oil.doterraPartNumber != nil) [self.coProductInfoArray addObject:[self twoColumnCellDictionaryForKey:@"doterraPartNumber"]];
    if (oil.doterraVolume != nil) [self.coProductInfoArray addObject:[self twoColumnCellDictionaryForKey:@"doterraVolume"]];
    if (oil.doterraPriceRetail != nil) [self.coProductInfoArray addObject:[self twoColumnCellDictionaryForKey:@"doterraPriceRetail"]];
    if (oil.doterraPriceWholesale != nil) [self.coProductInfoArray addObject:[self twoColumnCellDictionaryForKey:@"doterraPriceWholesale"]];
    if (oil.doterraPV != nil) [self.coProductInfoArray addObject:[self twoColumnCellDictionaryForKey:@"doterraPV"]];
    [self.coProductInfoArray addObject:[self twoColumnCellDictionaryForKey:@"available"]];
    [self.coProductInfoArray addObject:[self twoColumnCellDictionaryForKey:@"limitedEdition"]];
}

- (NSDictionary *)twoColumnCellDictionaryForKey:(NSString *)key {
    
    // Create left and right strings for each row in table.
    NSString *left = [self cellTitleForKey:key];
    
    id value = [self.object valueForKey:key];
    NSString *right = [self stringForKey:key andValue:value];
    
    NSDictionary *dictionary = @{@"left":left,
                                 @"right":right};
    
    return dictionary;
}

- (void)separateKeysForYoungLivingOil:(PFYoungLivingOil *)oil {
    
    self.tabTwoKeys = [[NSMutableArray alloc] init];
    
    self.reviews = [[NSArray alloc] init];
    
    // Create the quick facts
    self.quickFactsArray = [[NSMutableArray alloc] init];
    if (![oil.category isEqualToString:@"Blends"]) {
        if ([self isValid:oil.scientificName]) [self.quickFactsArray addObject:[self twoColumnCellDictionaryForKey:@"scientificName"]];
    }
    if ([self isValid:oil.scent]) [self.quickFactsArray addObject:[self twoColumnCellDictionaryForKey:@"scent"]];
    if ([self isValid:oil.botanicalFamily]) [self.quickFactsArray addObject:[self twoColumnCellDictionaryForKey:@"botanicalFamily"]];
    if ([self isValid:oil.plantPart]) [self.quickFactsArray addObject:[self twoColumnCellDictionaryForKey:@"plantPart"]];
    if ([self isValid:oil.collectionMethod]) [self.quickFactsArray addObject:[self twoColumnCellDictionaryForKey:@"collectionMethod"]];
    if ([self isValid:oil.region]) [self.quickFactsArray addObject:[self twoColumnCellDictionaryForKey:@"region"]];
    
    
    // Create the overview tab (tab 1)
    self.tabOneKeys = [[NSMutableArray alloc] init];
    if (self.quickFactsArray.count > 0) [self.tabOneKeys addObject:@"Quick Facts"];
    if ([self isValid:oil.summaryDescription]) [self.tabOneKeys addObject:@"summaryDescription"];
    if (oil.benefits != nil && oil.benefits.count > 0) [self.tabOneKeys addObject:@"benefits"];
    if ([oil.category isEqualToString:@"Blends"]) {
        if (oil.singleOilsIncluded && oil.singleOilsIncluded.count > 0) [self.tabOneKeys addObject:@"singleOilsIncluded"];
        if ([self isValid:oil.singleOilsIncludedDescription]) [self.tabOneKeys addObject:@"singleOilsIncludedDescription"];
    }
    if (oil.companionOils != nil && oil.companionOils.count > 0) [self.tabOneKeys addObject:@"companionOils"];
    if ([self isValid:oil.companionOilsDescription]) [self.tabOneKeys addObject:@"companionOilsDescription"];
    
    // Create the uses tab (tab 2)
    if (oil.applicationMethods != nil && oil.applicationMethods.count > 0) [self.tabTwoKeys addObject:@"applicationMethods"];
    if ([self isValid:oil.useDiffusion]) [self.tabTwoKeys addObject:@"useDiffusion"];
    if ([self isValid:oil.useTopical]) [self.tabTwoKeys addObject:@"useTopical"];
    if ([self isValid:oil.useInternal]) [self.tabTwoKeys addObject:@"useInternal"];
    if ([self isValid:oil.usesCommon]) [self.tabTwoKeys addObject:@"usesCommon"];
    if ([self isValid:oil.useHistorical]) [self.tabTwoKeys addObject:@"useHistorical"];
    if ([self isValid:oil.usesMedicinalFrench]) [self.tabTwoKeys addObject:@"usesMedicinalFrench"];
    if ([self isValid:oil.usesOther]) [self.tabTwoKeys addObject:@"usesOther"];
    if ([self isValid:oil.folklore]) [self.tabTwoKeys addObject:@"folklore"];
    if ([self isValid:oil.bodySystemsAffected]) [self.tabTwoKeys addObject:@"bodySystemsAffected"];
    if ([self isValid:oil.precautionsText]) [self.tabTwoKeys addObject:@"precautionsText"];
    if ([self isValid:oil.note]) [self.tabTwoKeys addObject:@"note"];
    [self. tabTwoKeys addObject:@"FDA Disclaimer"];
    
    self.coProductInfoArray = [[NSMutableArray alloc] init];
    if (oil.youngLivingItemNumber != nil) [self.coProductInfoArray addObject:[self twoColumnCellDictionaryForKey:@"youngLivingItemNumber"]];
    if (oil.youngLivingVolume != nil) [self.coProductInfoArray addObject:[self twoColumnCellDictionaryForKey:@"youngLivingVolume"]];
    if (oil.youngLivingPriceRetail != nil) [self.coProductInfoArray addObject:[self twoColumnCellDictionaryForKey:@"youngLivingPriceRetail"]];
    if (oil.youngLivingPriceWholesale != nil) [self.coProductInfoArray addObject:[self twoColumnCellDictionaryForKey:@"youngLivingPriceWholesale"]];
    [self.coProductInfoArray addObject:[self twoColumnCellDictionaryForKey:@"available"]];
}

- (void)reviewProcessingDidFinishWithRatingAverage:(double)average {
    NSInteger numReviews = (self.userReview != nil) ? self.reviews.count + 1 : self.reviews.count;
    self.numberOfReviewsLabel.text = [NSString stringWithFormat:@"%lu reviews", numReviews];
    
    // Round average to nearest 0.5 incrememnt
    // Double the number, round to nearest who number, divide by 2.0
    double avg = round(average * 2);
    avg = avg/2;
    
    NSString *starImgStr = [NSString stringWithFormat:@"%.1f-stars", avg];
    NSLog(@"starImgStr = '%@'", starImgStr);
    [self.starRatingButton setImage:[UIImage imageNamed:starImgStr] forState:UIControlStateNormal];
    
    // If the segmented control is displaying the reviews tableview... reload the first cell in the tableview
    // this will occur during a viewWillAppear call when returning to the screen from a new review being left.
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UI

- (void)setFavoriteButtonSelected:(BOOL)selected {
    UIImage *img = [UIImage systemImageNamed:@"heart"];
    UIImage *sImg = [UIImage systemImageNamed:@"heart.fill"];
    [self.favoriteButton setImage:(selected) ? sImg : img forState:UIControlStateNormal];
//    [self updateButton:self.favoriteButton withSelectedColor:[UIColor accentRed] isSelected:selected];
}

- (void)setMyOilButtonSelected:(BOOL)selected {
    UIImage *img = [UIImage systemImageNamed:@"plus.circle"];
    UIImage *sImg = [UIImage systemImageNamed:@"plus.circle.fill"];
    [self.addMyOilsButton setImage:(selected) ? sImg : img forState:UIControlStateNormal];
//    [self updateButton:self.addMyOilsButton withSelectedColor:[UIColor targetAccentColor] isSelected:selected];
}

//- (void)updateButton:(UIButton *)button withSelectedColor:(UIColor *)sColor isSelected:(BOOL)selected {
//    UIColor *tint = (selected) ? [UIColor whiteColor] : [UIColor blackColor];
//    UIColor *background = (selected) ? sColor : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
//    CGColorRef border = (selected) ? sColor.CGColor : [UIColor blackColor].CGColor;
//
//    button.tintColor = tint;
//    button.backgroundColor = background;
//    button.layer.borderColor = border;
//}

#pragma mark - ReviewTableViewCellDelegate

- (void)shouldUpvoteReviewForCell:(ReviewTableViewCell *)cell {
    [[[ReviewManager alloc] init] upVoteReview:cell.review withCompletion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}

- (void)shouldDownvoteReviewForCell:(ReviewTableViewCell *)cell {
    [[[ReviewManager alloc] init] downVoteReview:cell.review withCompletion:^(BOOL success, NSError * _Nullable error) {
       if (success) {
           [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
       }
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
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 1: { // Reviews + MyNotes
            switch (indexPath.section) {
                case 0: {
                    switch (indexPath.row) {
                        case 0: {
                            // Only the first row in the first section will be MyNotes, all others will be reviews
                            AddNoteViewController *vc = [[AddNoteViewController alloc] initForEntity:self.object withNote:nil];
                            [self.navigationController showViewController:vc sender:self];
                        } break;
                            
                        default:
                            break;
                    }
                } break;
                    
                case 1: {
                    switch (indexPath.row) {
                        case 0: {
                            // Only the first row in the second section will be for adding a review (if no review has previously
                            // been left.
                            WriteReviewViewController *vc = [[WriteReviewViewController alloc] initForParentObject:self.object withExistingReview:self.userReview];
                            [self.navigationController showViewController:vc sender:self];
                        } break;
                            
                        default: {
                            // All other cells in this section will be other user's reviews.
                            // Give the user the option to flag reviews as inappropriate.
                            NSString *message = NSLocalizedString(@"If you find something in this review offensive or inappropriate, please flag it and a member of our team will review and remove if necessary.", nil);
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Report Review", nil)
                                                                                           message:message
                                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
                            
                            [alert addAction:[UIAlertAction actionWithTitle:@"Report as Inappropriate"
                                                                      style:UIAlertActionStyleDestructive
                                                                    handler:^(UIAlertAction * _Nonnull action) {
                                
                                [[[ReviewManager alloc] init] flagReview:self.reviews[indexPath.row-1]
                                                          withCompletion:^(BOOL success, NSError * _Nullable error) {
                                    if (success) {
                                        NSString *title = NSLocalizedString(@"Review Flagged", nil);
                                        NSString *message = NSLocalizedString(@"Thank you for reporting this review. A member of our team will review and remove if necessary.", nil);
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                                                       message:message
                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                        [alert addAction:[UIAlertAction defaultOkAction]];
                                        [alert show];
                                    } else {
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:error.localizedDescription
                                                                                                       message:error.localizedFailureReason
                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                        [alert addAction:[UIAlertAction defaultOkAction]];
                                        [alert show];
                                    }
                                }];
                            }]];
                             
                            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * _Nonnull action) {}]];
                            
                            // For iPad
                            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
                                CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[tableView superview]];
                                
                                alert.popoverPresentationController.sourceRect = rectInSuperview;
                                alert.popoverPresentationController.sourceView = self.view;
                                
                                [self presentViewController:alert animated:YES completion:^{
                            
                                }];
                            } else {
                                [alert show];
                            }
                            
                        }
                            break;
                    }
                }
                    
                default:
                    break;
            }
        } break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Reviews tab has two sections, all other tabs have one.
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 1: // Reviews + MyNotes
            return 2;
            break;
            
        default:
            return 1;
            break;
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 1: // Reviews + MyNotes
            return 33.0;
            break;
            
        default:
            // By default do not display headers
            return 0;
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 1: { // Reviews + MyNotes
            
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 33.0)];
            headerView.backgroundColor = [UIColor systemGroupedBackgroundColor];
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, tableView.frame.size.width-30, 25)];
            headerLabel.font = [UIFont textFont];
            [headerView addSubview:headerLabel];
            
            switch (section) {
                case 0: // MyNotes
                    headerLabel.text = NSLocalizedString(@"Notes", nil);
                    break;
                    
                case 1: //
                    headerLabel.text = NSLocalizedString(@"Reviews", nil);
                    break;
                    
                default:
                    break;
            }
            return headerView;
        } break;
            
        default:
            // By default do not display headers
            return [[UIView alloc] init];
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            return self.tabOneKeys.count;
            break;
            
        case 1: { // Reviews + MyNotes
            
            switch (section) {
                case 1: {
                    // Review cells should always be the number of reviews + 1. The first cell will always
                    // either contain the user's review or a empty cell prompting to leave a review.
                    return self.reviews.count+1;
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
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGuideCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.textColor = [UIColor targetAccentColor];
    cell.subtitle.textColor = [UIColor darkGrayColor];
    
    NSString *key = @"";
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: {
            key = self.tabOneKeys[indexPath.row];
            
            // Display table cell for quick facts
            if ([key isEqualToString:@"Quick Facts"]) {
                TwoColumnTableTableViewCell *twoColumnTableCell = [tableView dequeueReusableCellWithIdentifier:kTwoColumnTableTableViewCell];
                twoColumnTableCell.titleLabel.font = [UIFont titleFont];
                twoColumnTableCell.titleLabel.text = key;
                [twoColumnTableCell setStringsForTableView:self.quickFactsArray];
                [twoColumnTableCell shouldDisplayHeaderInBar:NO];
                return twoColumnTableCell;
            }
            
        } break;
            
        case 1: { // Reviews + MyNotes
            switch (indexPath.section) {
                case 0: { // MyNotes
                    MyNotes *note = [[CoreDataManager sharedManager] getNoteForID:self.object.uuid];
                    if (note != nil) {
                        // Display note cell if a note exists
                        NoteCell *noteCell = [tableView dequeueReusableCellWithIdentifier:kNoteCell];
                        noteCell.noteNameLabel.text = NSLocalizedString(@"My Note", nil);
                        noteCell.noteTextLabel.text = note.text;
                        noteCell.noteTextLabel.numberOfLines = 5;
                        noteCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        noteCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return noteCell;
                    } else {
                        ABEmptyTableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:kEmptyCell];
                        emptyCell.iconImageView.image = [UIImage imageNamed:@"empty.icon.note"];
                        emptyCell.titleLabel.text = NSLocalizedString(@"No note", nil);
                        emptyCell.subtitleLabel.text = NSLocalizedString(@"Tap to add a new note", nil);
                        emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return emptyCell;
                    }
                } break;
                    
                default: { // Reviews
                    ReviewTableViewCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:kReviewCell];
                    reviewCell.delegate = self;
                    reviewCell.indexPath = indexPath;
                    
                    if (indexPath.row == 0) {
                        if (self.userReview) {
                            [reviewCell configureCellForReview:self.userReview];
                            return reviewCell;
                        } else {
                            ABEmptyTableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:kEmptyCell];
                            emptyCell.iconImageView.image = [UIImage imageNamed:@"empty.icon.star"];
                            emptyCell.titleLabel.text = NSLocalizedString(@"Add Review", nil);
                            emptyCell.subtitleLabel.text = NSLocalizedString(@"You haven't reviewed this oil yet. Tap to review.", nil);
                            emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
                            return emptyCell;
                        }
                    } else {
                        // We always must reduce the index count by 1, because of the first cell always being used to display
                        // either the user's review or a blank review cell. This prevents an array out of bounds exception
                        // since the last index in the tableview will be always be greater than the size of the reviews array.
                        [reviewCell configureCellForReview:self.reviews[indexPath.row-1]];
                         return reviewCell;
                    }
                } break;
            }
        } break;
            
        case 2: {
            key = self.tabTwoKeys[indexPath.row];
            
            if ([key isEqualToString:@"FDA Disclaimer"]) {
                cell.name.text = key;
                cell.subtitle.text = NSLocalizedString(@"These statements have not been evaluated by the Food and Drug Administration. This product is not intended to diagnose, treat, cure, or prevent any disease.", nil);
                return cell;
            }
            
        } break;
            
        case 3: {
            
            NSString *title = @"";
#ifdef DOTERRA
            title = NSLocalizedString(@"doTERRA Information", nil);
#elif YOUNGLIVING
            title = NSLocalizedString(@"YoungLiving Information", nil);
#endif

            TwoColumnTableTableViewCell *twoColumnTableCell = [tableView dequeueReusableCellWithIdentifier:kTwoColumnTableTableViewCell];
            twoColumnTableCell.titleLabel.text = title;
            [twoColumnTableCell setStringsForTableView:self.coProductInfoArray];
            [twoColumnTableCell shouldDisplayHeaderInBar:NO];
            return twoColumnTableCell;

        } break;
    }
    
    id value = [self.object valueForKey:key];
    NSString *title = [self cellTitleForKey:key];
    cell.name.text = title;
    
    NSString *subtitleString = [self stringForKey:key andValue:value];
    if (subtitleString) {
        cell.subtitle.text = subtitleString;
    } else {
        // Nil because the type is not NSString or NSNumber -- handle NSArrays here.
        if ([value isKindOfClass:[NSArray class]]) {
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
                                                 NSFontAttributeName: [UIFont systemFontOfSize:4.0],
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
        }
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
#elif YOUNGLIVING
    
    if ([key containsString:@"youngliving"]) {
        key = [key stringByReplacingOccurrencesOfString:@"youngliving" withString:@""];
    }
#endif
    
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
    
    // Keys below are completely renamed.
    if ([key isEqualToString:@"PV"])
        return NSLocalizedString(@"Loyalty Rewards PV", nil);
    
    else if ([key isEqualToString:@"precautionsText"])
        return NSLocalizedString(@"Precautions", nil);
    
    else if ([key isEqualToString:@"summaryDescription"])
        return NSLocalizedString(@"Summary", nil);
    
    else if ([key isEqualToString:@"longDescription"])
        return NSLocalizedString(@"Description", nil);
    
    else if ([key isEqualToString:@"singleOilsIncluded"])
        return NSLocalizedString(@"Oils Included in Blend", nil);
    
    else if ([key isEqualToString:@"singleOilsIncludedDescription"])
        return NSLocalizedString(@"About the Included Oils", nil);

    return [NSString addSpacesBeforeCapitalLettersInString:key].capitalizedString;
}

/**
 Creates strings from string and number values.
 Returns Usable string or nil if value is not a string or number type.
 */
- (NSString *)stringForKey:(NSString *)key andValue:(id)value {
 
    if ([value isKindOfClass:[NSString class]]) {
        NSString *text = (NSString *)value;
        return text;
        
    } else if ([value isKindOfClass:[NSNumber class]]) {
        
        NSNumber *num = (NSNumber *)value;
            
            // Distinguish between prices, booleans and other numbers
            if (num == (void*)kCFBooleanFalse || num == (void*)kCFBooleanTrue) {
                
                // Boolean values
                BOOL val = [value boolValue];
                NSString *text = (val == TRUE) ? NSLocalizedString(@"Yes", nil) : NSLocalizedString(@"No", nil);
                return text;
                
                
            } else if ([key.lowercaseString containsString:@"price"]) {
                // Prices
                return [NSString stringWithFormat:@"$%.2f", [num doubleValue]];
            } else {
                // Misc numbers
                return [NSString stringWithFormat:@"%@", num];
            }
    } else {
        return nil;
    }
}

@end
