////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ShoppingListTableViewCell.h
/// @author     Lynette Sesodia
/// @date       8/6/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import "Constants.h"

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

@interface ShoppingListTableViewCell : UITableViewCell

/// The indexPath of the cell in its parent tableview.
@property (nonatomic, strong) NSIndexPath *indexPath;

/// The white background view containing the oil info for the cell.
@property (nonatomic, strong) IBOutlet UIView *whiteBackgroundView;

/// Icon image view for the cell.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

/// Name label displaying a user facing string for the cell.
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@end
