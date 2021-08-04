////////////////////////////////////////////////////////////////////////////////
//  Essential Oils
/// @file       ESTLRecipeViewController.h
/// @author     Lynette Sesodia
/// @date       7/16/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "PFRecipe.h"

#import "OilViewController.h"
#import "AddNoteViewController.h"
#import "WriteReviewViewController.h"

#import "CoreDataManager.h"
#import "NetworkManager.h"
#import "ReviewManager.h"
#import "UserManager.h"
#import "UIImageView+AFNetworking.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

static NSInteger const OilsUsedTableViewTag = 100;

static NSString * const DescriptionKey = @"summaryDescription";
static NSString * const OilsUsedKey = @"oilsUsed";
static NSString * const IngredientsKey = @"ingredients";
static NSString * const StepsKey = @"steps";
static NSString * const AmountKey = @"amount";

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface RecipeViewController : UIViewController

#pragma mark IBOutlets

/// Label displaying the user facing name of the recipe.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Main table view for the controller.
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/// Button to favorite the recipe.
@property (nonatomic, strong) IBOutlet UIButton *favoriteButton;

/// Button to add a note to the recipe.
@property (nonatomic, strong) IBOutlet UIButton *addNoteButton;

/// Back button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

#pragma mark Instance Variables

/// The recipe object for the controller.
@property (nonatomic, strong) PFRecipe *recipe;

/// Array of keys to be displayed in the tableview.
@property (nonatomic, strong) NSMutableArray *tableViewKeys;

/// Array of PFOil objects for the oils used in the recipe.
@property (nonatomic, strong) NSArray<id<OilModel>> *oilsUsed;

/// Saved core data note object. If nonnull, indicates that the current recipe has a saved note.
@property (nonatomic, strong) MyNotes *note;

/// Saved core data note object. If nonnull, indicates that the current recipe is a favorite.
@property (nonatomic, strong) Favorites * _Nullable favorite;

/// Array of review objects for the current oil object.
@property (nonatomic, strong) NSArray<Review *> * _Nullable reviews;

/// The users' review of the current oil object.
@property (nonatomic, strong) Review * _Nullable userReview;

#pragma mark Functions

- (instancetype)initWithRecipe:(PFRecipe *)recipe;

- (IBAction)back:(id)sender;

- (void)markFavoriteWithCompletion:(void(^)(void))completion;

- (IBAction)addNote:(id)sender;

- (void)reviewProcessingDidFinishWithRatingAverage:(double)average;

/**
 Reloads the user's review in the tableview cell.
 */
- (void)reloadUserReviewCell;

@end

NS_ASSUME_NONNULL_END
