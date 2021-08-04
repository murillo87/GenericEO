////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       InventoryViewController.h
/// @author     Lynette Sesodia
/// @date       5/26/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import "DataTableViewController.h"

#import "NetworkManager.h"
#import "CoreDataManager.h"
#import "MBProgressHUD.h"
#import "OilViewController.h"

#import "UIImageView+AFNetworking.h"
#import "UIScrollView+EmptyDataSet.h"

#import "ShoppingListTableViewCell.h"
#import "InventoryTableViewCell.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kShoppingListCell @"ShoppingListTableViewCell"
#define kInventoryCell @"InventoryTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface InventoryViewController : UIViewController


#pragma mark - Interface Elements

/// Table view displaying all of the user's saved favorites.
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/// Back button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// Label displaying the title label for the controller.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Button to add a new favorite.
@property (nonatomic, strong) IBOutlet UIButton *addButton;


#pragma mark - Instance Variables

/// Array of user saved oils in inventory
@property (nonatomic, strong) NSArray<MyOils *> *inventoryOils;

/// Array of PFObjects<OilModel> that match the oils in inventory.
@property (nonatomic, strong) NSArray<PFObject<OilModel> *> *inventoryOilObjects;

/// Array of user saved oils in shopping list
@property (nonatomic, strong) NSArray<MyOils *> *shoppingListOils;

/// Array of PFObjects<OilModel> that match the shoppingListOils;
@property (nonatomic, strong) NSArray<PFObject<OilModel> *> *shoppingListOilObjects;


#pragma mark - Functions

/**
 Initializes the InventoryVC for the current target.
 */
- (id)initForTarget;

/**
 Queries core data for most up to data data, refreshes table view and data labels.
 */
- (void)refreshData;

/**
 Presents a DataTableViewController with available options for the given data type.
 */
- (void)showAddOptionsForType:(EODataType)type;

/**
 Returns to the previous controller.
 */
- (IBAction)back:(id)sender;

@end

NS_ASSUME_NONNULL_END
