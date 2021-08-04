////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       TwoColumnTableTableViewCell.h
/// @author     Lynette Sesodia
/// @date       3/21/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
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

static CGFloat const TwoColumnTableTableViewCellChildTableViewCellRowHeight = 40.0;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TwoColumnTableTableViewCell : UITableViewCell <UITableViewDataSource>

/// Label displaying title for the cell.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Layout constraint for the title label height.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *titleLabelHeightConstraint;

/// Table view displaying suggested oils options.
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/// Layout constraint for the cell's tableview height. Default height is 88px (enough for 2 cells).
@property (nonnull, strong) IBOutlet NSLayoutConstraint *tableViewHeight;

/// Array of dictionaries, each with "left" and "right" strings for each row in the tableview.
- (void)setStringsForTableView:(NSArray <NSDictionary *> *)strings;

/// Displays title label in bar or as formatted text
- (void)shouldDisplayHeaderInBar:(BOOL)headerBar;

@end

NS_ASSUME_NONNULL_END
