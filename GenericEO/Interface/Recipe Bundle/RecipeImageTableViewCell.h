////////////////////////////////////////////////////////////////////////////////
//  Essential Oils
/// @file       RecipeImageTableViewCell.h
/// @author     Lynette Sesodia
/// @date       3/16/18
//
//  Copyright © 2018 Cloforce LLC. All rights reserved.
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

@interface RecipeImageTableViewCell : UITableViewCell

/// Image view for the cell.
@property (nonatomic, strong) IBOutlet UIImageView *mainImageView;

/// Description label for the cell.
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

@end
