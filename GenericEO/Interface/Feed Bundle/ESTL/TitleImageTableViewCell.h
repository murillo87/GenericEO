////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       TitleImageTableViewCell.h
/// @author     Lynette Sesodia
/// @date       7/26/18
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

@interface TitleImageTableViewCell : UITableViewCell

/// Image view displaying icon for cell.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

/// Bold label displaying cell's title.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end
