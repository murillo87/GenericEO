////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       SingleColumnTableTableViewCell.h
/// @author     Lynette Sesodia
/// @date       7/24/18
//
//  Copyright © 2019 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

static CGFloat const SingleColumnTableTableViewCellChildTableViewCellRowHeight = 40.0;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface SingleColumnTableTableViewCell : UITableViewCell <UITableViewDataSource>

/// Label displaying title for the cell.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Layout constraint for the title label height.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *titleLabelHeightConstraint;

/// Table view displaying suggested oils options.
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/// Layout constraint for the cell's tableview height. Default height is 88px (enough for 2 cells).
@property (nonnull, strong) IBOutlet NSLayoutConstraint *tableViewHeight;

/// Sets the oils for the cell's table view.
- (void)setStringsForTableView:(NSArray<NSString *> *)strings;

/// Displays title label in bar or as formatted text
- (void)shouldDisplayHeaderInBar:(BOOL)headerBar;

@end

NS_ASSUME_NONNULL_END
