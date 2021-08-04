////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       DataTableViewController.h
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>

#import "DataTableViewControllerDelegate.h"

#import <Impera/StoreKit.h>
#import "IAPProducts.h"
#import "PaywallView.h"
#import "UpgradeViewController.h"

#import "ESTLGuideViewController.h"
#import "ChartsViewController.h"
#import "OilViewController.h"
#import "RecipeViewController.h"

#import <MBProgressHUD/MBProgressHUD.h>
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

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface DataTableViewController : UIViewController <UISearchBarDelegate>

#pragma mark - Delegate

/// Delegate used to handle search functionality for other controllers.
@property (nonatomic, weak) id<DataTableViewControllerSearchDelegate> searchDelegate;


#pragma mark - Instance Variables

/// The product manager used by the application.
@property (nonatomic, strong) IAPServerSubscriptionManager *productManager;

/// Filter options view height constraint.
@property (nonatomic, strong) NSLayoutConstraint *filterOptionsViewHeightConstraint;

/// EODataType indicating the data type for the controller
@property (nonatomic) EODataType type;

/// Parse class name for objects displayed in table view
@property (nonatomic, strong) NSString *className;

/// Array of all objects queried from parse
@property (nonatomic, strong) NSArray *allObjects;

/// Objects displayed in table view
@property (nonatomic, strong) NSDictionary *objectsDict;

/// Array of all source objects queried from parse. Only used with single oil types.
@property (nonatomic, strong) NSArray *oilSourceObjects;

/// Objects displayed in table view during search
@property (nonatomic, strong) NSArray *searchObjects;

/// Boolean value indicating if a search is active
@property (nonatomic) BOOL isActiveSearch;

/// IAPProducts for the guide paywall.
@property (nonatomic, strong) NSArray<id> *IAPs;

#pragma mark - IBOutlets

/// Back button.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// Title label for the controller.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Tableview displaying data queried from parse
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/// Search bar used to search through table view data.
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

#pragma mark - Functions

/**
 Initializes the data table controller with the given type.
 @param type The data type to be displayed in the controller's table.
 */
- (instancetype)initWithType:(EODataType)type;

/**
 Converts a string to a user facing camel string.
 @example "THIS IS A STRING" -> "This Is A String"
 */
- (NSString *)camelCaseStringFromString:(NSString *)string;

@end
