////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NotesViewController.h
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import "DataTableViewController.h"
#import "AddNoteViewController.h"
#import "NoteCell.h"
#import "CoreDataManager.h"

#import "UIScrollView+EmptyDataSet.h"
#import "MBProgressHUD.h"

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

@interface NotesViewController : UIViewController

#pragma mark IBOutlets

/// Title label for the controller.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Back button.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// Add button.
@property (nonatomic, strong) IBOutlet UIButton *addButton;

/// Table view displaying all of the user's saved notes
@property (nonatomic, strong) IBOutlet UITableView *tableView;

#pragma mark Instance Variables

/// Array of user saved notes for oil objects.
@property (nonatomic, strong) NSArray<MyNotes *> *savedOilNotes;

/// Array of user saved notes for usage guide objects.
@property (nonatomic, strong) NSArray<MyNotes *> *savedGuideNotes;

/// Array of user saved notes for recipe objects.
@property (nonatomic, strong) NSArray<MyNotes *> *savedRecipeNotes;

#pragma mark Functions

/**
 Initializes the NotesVC for the current target.
*/
- (id)initForTarget;

/**
 Returns to the previous view controller in the navigation controller.
 */
- (IBAction)back:(id)sender;

/**
 Displays a DataTableViewController with a tableview containing all options for the given data type.
 */
- (void)showAddOptionsForType:(EODataType)type;

/**
 Fetches fresh data for all saved notes in CoreData.
 */
- (void)refreshData;


@end
