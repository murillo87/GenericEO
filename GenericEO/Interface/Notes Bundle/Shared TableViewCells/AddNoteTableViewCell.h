////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       AddNoteTableViewCell.h
/// @author     Lynette Sesodia
/// @date       6/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
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

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface AddNoteTableViewCell : UITableViewCell

/// Imageview displaying icon for the cell.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

/// Label displaying title text for the cell.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Label displaying description text for the cell.
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;

@end
