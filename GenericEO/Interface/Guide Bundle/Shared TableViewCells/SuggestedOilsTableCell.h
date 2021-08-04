////////////////////////////////////////////////////////////////////////////////
//  Essential Oils
/// @file       CLFSuggestedOilsCell.h
/// @author     Lynette Sesodia
/// @date       4/11/16
//
//  Copyright © 2016 Cloforce LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

static CGFloat const SuggestedOilsCellChildTableViewCellRowHeight = 50.0;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface SuggestedOilsTableCell : UITableViewCell <UITableViewDataSource>

/// Label displaying title for the cell.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Layout constraint for the title label height.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *titleLabelHeightConstraint;

/// Table view displaying suggested oils options.
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/// Layout constraint for the cell's tableview height. Default height is 88px (enough for 2 cells).
@property (nonnull, strong) IBOutlet NSLayoutConstraint *tableViewHeight;

/// The with of the icon image view on the tableview's cells.
@property (nonatomic) CGFloat cellIconWidth;

/**
 Sets the oils for the cell's table view.
 @param objects Array of objects to be displayed in the tableview.
 @param shouldFetch Boolean value indicating if the object is a PFObject AND if it should have data fetched automatically.
 */
- (void)setObjectsForTableView:(NSArray *)objects shouldFetchData:(BOOL)shouldFetch;

/// Displays title label in bar or as formatted text
- (void)shouldDisplayHeaderInBar:(BOOL)headerBar;


@end

NS_ASSUME_NONNULL_END
