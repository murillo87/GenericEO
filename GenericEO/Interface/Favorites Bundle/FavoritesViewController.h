////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       FavoritesViewController.h
/// @author     Lynette Sesodia
/// @date       7/29/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import "DataTableViewController.h"

#import "NetworkManager.h"
#import "CoreDataManager.h"
#import "MBProgressHUD.h"

#import "UIImageView+AFNetworking.h"
#import "UIScrollView+EmptyDataSet.h"

#import "GuideTableViewCell.h"
#import "TitleTableViewCell.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kCell @"GuideTableViewCell"
#define kTitleCell @"TitleTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface FavoritesViewController : UIViewController <DataTableViewControllerSearchDelegate>

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

/// Array of user saved favorite oil objects.
@property (nonatomic, strong) NSArray<Favorites *> *favoriteOils;

/// Array of user saved favorite usage guide objects.
@property (nonatomic, strong) NSArray<Favorites *> *favoriteGuides;

/// Array of user saved favorite recipe objects.
@property (nonatomic, strong) NSArray<Favorites *> *favoriteRecipes;

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
