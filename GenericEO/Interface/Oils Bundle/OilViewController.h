////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       OilViewController.h
/// @author     Lynette Sesodia
/// @date       3/11/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "CoreDataManager.h"
#import "NetworkManager.h"
#import "ReviewManager.h"
#import "UserManager.h"

#import "OilViewControllerInitProtocol.h"
#import "OilViewControllerDelegate.h"

#import "OilModel.h"
#import "PFOil.h"
#import "PFDoterraOil.h"
#import "PFYoungLivingOil.h"
#import "Review.h"
#import "MyOils+CoreDataProperties.h"
#import "MyNotes+CoreDataProperties.h"
#import "Favorites+CoreDataProperties.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface OilViewController : UIViewController <OilViewControllerInitProtocol>

#pragma mark - Delegate
@property (nonatomic, weak) id<OilViewControllerDelegate> oilVCDelegate;

#pragma mark - Instance Variables

/// The single oil object for the view controller.
@property (nonatomic, strong) PFObject<OilModel> *object;

/// The brand/pricing source object for the oil. Only used for non-brand specific targets.
@property (nonatomic, strong) PFObject *sourceObject;

/// Array of blends with oil objects for the oil.
@property (nonatomic, strong) NSArray<PFOil *> *blendsWithOils;

/// Array of single oil objects included for the oil blend.
@property (nonatomic, strong) NSArray<PFOil *> *singleOilsIncluded;

/// Array of companion oil objects included for the oil blend.
@property (nonatomic, strong) NSArray<PFOil *> *companionOils;

/// Saved core data myOil object. If nonnull, indicates that the current oil is saved to myOils.
@property (nonatomic, strong) MyOils * _Nullable myOil;

/// Saved core data note object. If nonnull, indicates that the current oil has a saved note.
@property (nonatomic, strong) MyNotes * _Nullable note;

/// Saved core data favorite object. If nonnull, indicates that the current is a favorite.
@property (nonatomic, strong) Favorites * _Nullable favorite;

/// Array of PFOil objects that the current oil object blendsWith.
@property (nonatomic, strong) NSArray<PFObject<OilModel> *> *blendsWith;

/// Array of review objects for the current oil object.
@property (nonatomic, strong) NSArray<Review *> *reviews;

/// The users' review of the current oil object.
@property (nonatomic, strong) Review *userReview;

#pragma mark - Interface Elements

/// Back button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// Table view displaying the controller's data.
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/// Label displaying the name of the oil.
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

/// Button to add oil to my oils.
@property (nonatomic, strong) IBOutlet UIButton *addMyOilsButton;

/// Button to add oil to favorites.
@property (nonatomic, strong) IBOutlet UIButton *favoriteButton;

/// ImageView displaying icon for the oil.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

#pragma mark - Convenience Methods

/**
 Verifies the given string is nonnull and contains 1 or more characters.
 @param str The string to evaluate.
 @returns Boolean value indicating if valid or not.
 */
- (BOOL)isValid:(NSString *)str;

/**
 Reloads the user's review in the tableview cell.
 */
- (void)reloadUserReviewCell;

@end

NS_ASSUME_NONNULL_END
