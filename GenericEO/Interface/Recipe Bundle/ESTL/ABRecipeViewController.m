////////////////////////////////////////////////////////////////////////////////
//  Essential Oils
/// @file       ABRecipeViewController.m
/// @author     Lynette Sesodia
/// @date       7/16/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ABRecipeViewController.h"

#import "RecipeImageTableViewCell.h"
#import "RecipeTextTableViewCell.h"
#import "SuggestedOilsTableCell.h"
#import "ReviewTableViewCell.h"
#import "NoteCell.h"
#import "ABEmptyTableViewCell.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kRecipeImageCell @"RecipeImageTableViewCell"
#define kRecipeTextCell @"RecipeTextTableViewCell"
#define kSuggestedOilsCell @"SuggestedOilsTableCell"
#define kReviewCell @"ReviewTableViewCell"
#define kNoteCell @"NoteCell"
#define kEmptyCell @"ABEmptyTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ABRecipeViewController () <UITableViewDelegate, UITableViewDataSource, ReviewTableViewCellDelegate>

/// Icon image for the controller.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

/// Segmented control to change what is displayed in the tableview.
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

/// Button displaying review star rating.
@property (nonatomic, strong) IBOutlet UIButton *starRatingButton;

/// Label displaying the number of reviews the oil has.
@property (nonatomic, strong) IBOutlet UILabel *numberOfReviewsLabel;

/// Array of keys for the first tab in the tableview.
@property (nonatomic, strong) NSMutableArray *tabOneKeys;

/// Array of keys for the second tab in the tableview.
@property (nonatomic, strong) NSMutableArray *tabTwoKeys;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ABRecipeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.titleLabel.text = self.recipe.name.capitalizedString;
    self.favoriteButton.layer.cornerRadius = 20.0;
    self.addNoteButton.layer.cornerRadius = 20.0;
    
    self.favoriteButton.tintColor = [UIColor systemRedColor];
    self.backButton.tintColor = [UIColor targetAccentColor];
    
    // TODO: Update this to be a valid image
    self.iconImageView.image = [UIImage imageNamed:@"line.icon.recipe"];
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.height/2;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.backgroundColor = [UIColor whiteColor];

    // Verify all data points are valid before displaying to prevent empty table view cells
    self.tabOneKeys = [[NSMutableArray alloc] init];
    if (self.recipe.summaryDescription.length > 0) [self.tabOneKeys addObject:DescriptionKey];
    if (self.recipe.oilsUsed.count > 0) [self.tabOneKeys addObject:OilsUsedKey];
    if (self.recipe.ingredients.count > 0) [self.tabOneKeys addObject:IngredientsKey];
    if (self.recipe.steps.count > 0) [self.tabOneKeys addObject:StepsKey];
    if (self.recipe.amount.length > 0) [self.tabOneKeys addObject:AmountKey];
    
    [self configureSegmentedControl];
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateReviewsAndRatings];
    [self updateFavoriteButton:(self.favorite != nil) ? YES : NO];
    [self.tableView reloadData];
}

#pragma mark - UI

- (void)configureSegmentedControl {
    self.segmentedControl.backgroundColor = [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1.0];
    self.segmentedControl.selectedSegmentTintColor = [UIColor targetAccentColor];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}
                                         forState:UIControlStateSelected];
    [self.segmentedControl setTitle:NSLocalizedString(@"Info", nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"Reviews", nil) forSegmentAtIndex:1];
    
    [self.segmentedControl addTarget:self action:@selector(segmentedControlSelectedSegmentDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)configureTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kRecipeImageCell bundle:nil] forCellReuseIdentifier:kRecipeImageCell];
    [self.tableView registerNib:[UINib nibWithNibName:kRecipeTextCell bundle:nil] forCellReuseIdentifier:kRecipeTextCell];
    [self.tableView registerNib:[UINib nibWithNibName:kSuggestedOilsCell bundle:nil] forCellReuseIdentifier:kSuggestedOilsCell];
    [self.tableView registerNib:[UINib nibWithNibName:kNoteCell bundle:nil] forCellReuseIdentifier:kNoteCell];
    [self.tableView registerNib:[UINib nibWithNibName:kReviewCell bundle:nil] forCellReuseIdentifier:kReviewCell];
    [self.tableView registerNib:[UINib nibWithNibName:kEmptyCell bundle:nil] forCellReuseIdentifier:kEmptyCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)updateReviewsAndRatings {
    [self.starRatingButton setImage:[UIImage imageNamed:@"0.0-stars"] forState:UIControlStateNormal];
    self.numberOfReviewsLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)self.reviews.count, NSLocalizedString(@"reviews", nil)];
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

- (void)updateFavoriteButton:(BOOL)isFav {
    UIImage *img = [UIImage systemImageNamed:@"heart"];
    UIImage *sImg = [UIImage systemImageNamed:@"heart.fill"];
    [self.favoriteButton setImage:(isFav) ? sImg : img forState:UIControlStateNormal];
    [self.favoriteButton setTintColor:(isFav) ? [UIColor accentRed] : [UIColor systemBlueColor]];
}

#pragma mark - Actions

- (IBAction)showReviews:(id)sender {
    // Move segmented control to first index to display review tab and reload table view
    [self.segmentedControl setSelectedSegmentIndex:1];
    [self segmentedControlSelectedSegmentDidChange:self.segmentedControl];
}

- (IBAction)favorite:(id)sender {
    [super markFavoriteWithCompletion:^{
        [self updateFavoriteButton:(self.favorite != nil) ? YES : NO];
    }];
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
    // No action unless suggestion oil tableview
    if (tableView.tag == OilsUsedTableViewTag) {
#ifdef GENERIC
        PFOil *oil = (PFOil *)self.oilsUsed[indexPath.row];
        OilViewController *vc = [[OilViewController alloc] initWithOil:oil andSources:nil];
#elif DOTERRA
        PFDoterraOil *oil = (PFDoterraOil *)self.oilsUsed[indexPath.row];
        OilViewController *vc = [[OilViewController alloc] initWithDoterraOil:oil];
#elif YOUNGLIVING
        PFYoungLivingOil *oil = (PFYoungLivingOil *)self.oilsUsed[indexPath.row];
        OilViewController *vc = [[OilViewController alloc] initWithYoungLivingOil:oil];
#endif
        [self showViewController:vc sender:self];
    }
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 1: { // Reviews + MyNotes
            switch (indexPath.section) {
                case 0: {
                    switch (indexPath.row) {
                        case 0: {
                            // Only the first row in the first section will be MyNotes, all others will be reviews
                            AddNoteViewController *vc = [[AddNoteViewController alloc] initForEntity:self.recipe withNote:nil];
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
                            WriteReviewViewController *vc = [[WriteReviewViewController alloc] initForParentObject:self.recipe withExistingReview:self.userReview];
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
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 1: // Reviews + MyNotes
            return 2;
            break;
            
        default:
            return 1;
            break;
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // Tab one
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
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == OilsUsedTableViewTag) {
        return 0.0;
    }
    
    switch (self.segmentedControl.selectedSegmentIndex) {
            
        case 0: { // Overview
            switch (section) {
                case 1:
                case 2:
                case 3:
                case 4:
                    return 33.0;
                    break;
                    
                default:
                    return 0.0;
                    break;
            }
        } break;
            
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
    if (tableView.tag == OilsUsedTableViewTag) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 33.0)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, tableView.frame.size.width-30, 25)];
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: {
            headerView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0];
            NSString *str = self.tabOneKeys[section];
            if ([str isEqualToString:DescriptionKey]) {
                str = @"Description";
            }
            titleLabel.text = NSLocalizedString([NSString addSpacesBeforeCapitalLettersInString:str].capitalizedString, nil);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont titleFont];
        } break;
            
       case 1: { // Reviews + MyNotes
         headerView.backgroundColor = [UIColor systemGroupedBackgroundColor];
         titleLabel.font = [UIFont textFont];
         
         switch (section) {
             case 0: // MyNotes
                 titleLabel.text = NSLocalizedString(@"Notes", nil);
                 break;
                 
             case 1: //
                 titleLabel.text = NSLocalizedString(@"Reviews", nil);
                 break;
                 
             default:
                 break;
         }
       } break;
            
        default:
            break;
    }
    
    [headerView addSubview:titleLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == OilsUsedTableViewTag) {
        return UITableViewAutomaticDimension;
    }
    
    NSString *str = self.tableViewKeys[indexPath.row];
    if ([str isEqualToString:OilsUsedKey]) {
        return 33 + (SuggestedOilsCellChildTableViewCellRowHeight * self.oilsUsed.count);
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: { // Overview
            RecipeTextTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:kRecipeTextCell];
            textCell.selectionStyle = UITableViewCellSelectionStyleNone;
            textCell.titleLabel.textColor = [UIColor targetAccentColor];
            
            NSString *key = self.tabOneKeys[indexPath.row];
            
            // Display Description
            if ([key isEqualToString:DescriptionKey]) {
                textCell.titleLabel.text = NSLocalizedString(@"Description", nil);
                textCell.secondaryLabel.text = self.recipe.summaryDescription;
                textCell.secondaryLabel.textColor = [UIColor darkGrayColor];
            }
            
            // Display Oils Used
            // Tableview within cell with pointers to single oil objects and pushes to their pages
            if ([key isEqualToString:OilsUsedKey]) {
                SuggestedOilsTableCell *tableCell = [tableView dequeueReusableCellWithIdentifier:kSuggestedOilsCell];
                [tableCell shouldDisplayHeaderInBar:NO];
                tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
                tableCell.titleLabel.text = NSLocalizedString(@"Oils Used", nil);
                tableCell.titleLabel.font = [UIFont font:[UIFont boldTextFont] ofSize:17.0];
                tableCell.tableView.tag = OilsUsedTableViewTag;
                tableCell.tableView.delegate = self;
                [tableCell setObjectsForTableView:self.oilsUsed shouldFetchData:YES];
                return tableCell;
            }
            
            // Display servings amount
            if ([key isEqualToString:AmountKey]) {
                textCell.titleLabel.text = NSLocalizedString(@"Servings", nil);
                textCell.secondaryLabel.text = self.recipe.amount.capitalizedString;
                textCell.secondaryLabel.textColor = [UIColor darkGrayColor];
            }
            
            // Attributes used in both ingredients and steps cells
            NSDictionary *lineAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:10.0] };
            NSDictionary *boldAttributes = @{ NSFontAttributeName: [UIFont boldTextFont],
                                              NSForegroundColorAttributeName : [UIColor darkGrayColor] };
            NSDictionary *normalAttributes = @{ NSFontAttributeName: [UIFont textFont],
                                                NSForegroundColorAttributeName : [UIColor darkGrayColor] };
            
            //Display Ingredients
            if ([key isEqualToString:IngredientsKey]) {
                textCell.titleLabel.text = NSLocalizedString(@"Ingredients", nil);
                
                NSMutableAttributedString *ingredientsString = [[NSMutableAttributedString alloc] init];
               
                for (int i=0; i<self.recipe.ingredients.count; i++) {
                    NSString *text = [NSString stringWithFormat:@"\u2022 %@", self.recipe.ingredients[i]];
                    
                    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:text attributes:normalAttributes];
                    NSAttributedString *br = [[NSAttributedString alloc] initWithString:@"\n" attributes:lineAttributes];
                    
                    [ingredientsString appendAttributedString:br];
                    [ingredientsString appendAttributedString:str1];
                    [ingredientsString appendAttributedString:br];
                }
                
                textCell.secondaryLabel.attributedText = ingredientsString;
            }
            
            // Display Steps
            if ([key isEqualToString:StepsKey]) {
                textCell.titleLabel.text = NSLocalizedString(@"Steps", nil);
                
                NSMutableAttributedString *stepsString = [[NSMutableAttributedString alloc] init];
                
                for (int i=0; i<self.recipe.steps.count; i++) {
                    NSString *num = [NSString stringWithFormat:@"Step %d: ", i+1];
                    NSString *text = [NSString stringWithFormat:@"%@", self.recipe.steps[i]];
                    
                    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:num attributes:boldAttributes];
                    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:text attributes:normalAttributes];
                    NSAttributedString *br = [[NSAttributedString alloc] initWithString:@"\n" attributes:lineAttributes];
                    
                    [stepsString appendAttributedString:br];
                    [stepsString appendAttributedString:str1];
                    [stepsString appendAttributedString:str2];
                    [stepsString appendAttributedString:br];
                }
                
                textCell.secondaryLabel.attributedText = stepsString;
            }
            
            return textCell;
        } break;
            
        case 1: { // Reviews + MyNotes
            switch (indexPath.section) {
                case 0: { // MyNotes
                    MyNotes *note = [[CoreDataManager sharedManager] getNoteForID:self.recipe.uuid];
                    if (note != nil) {
                        // Display note cell if a note exists
                        NoteCell *noteCell = [tableView dequeueReusableCellWithIdentifier:kNoteCell];
                        noteCell.noteNameLabel.text = NSLocalizedString(@"My Note", nil);
                        noteCell.noteTextLabel.text = note.text;
                        noteCell.noteTextLabel.numberOfLines = 0;
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
                            emptyCell.subtitleLabel.text = NSLocalizedString(@"You haven't reviewed this recipe yet. Tap to review.", nil);
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
            
        default:
            return nil;
            break;
    }
}

@end
