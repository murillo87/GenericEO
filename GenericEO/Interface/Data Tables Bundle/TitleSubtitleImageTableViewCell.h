////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       TitleSubtitleImageTableViewCell.h
/// @author     Lynette Sesodia
/// @date       6/16/18
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

@interface TitleSubtitleImageTableViewCell : UITableViewCell

/// Image view displaying icon for cell.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

/// Bold label displaying cell's title.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Label displaying cell's subtitle.
@property (nonatomic, strong) IBOutlet UILabel *subTitleLabel;

@end
