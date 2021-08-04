////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       GeneralOilTableViewCell.h
/// @author     Lynette Sesodia
/// @date       7/24/18
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

@interface GeneralOilTableViewCell : UITableViewCell

/// Tag for the table view cell.
@property (nonatomic, strong) NSIndexPath *indexPath;

/// Image view displaying icon for cell.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

/// Bold label displaying cell's title.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Right-most imageview displaying a brand icon.
@property (nonatomic, strong) IBOutlet UIImageView *brandImageView1;

/// Middle imageview displaying a brand icon.
@property (nonatomic, strong) IBOutlet UIImageView *brandImageView2;

/// Left-most imageview displaying a brand icon.
@property (nonatomic, strong) IBOutlet UIImageView *brandImageView3;

@end
