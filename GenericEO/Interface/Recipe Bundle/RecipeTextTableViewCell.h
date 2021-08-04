////////////////////////////////////////////////////////////////////////////////
//  Essential Oils
/// @file       RecipeTextTableViewCell.h
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

@interface RecipeTextTableViewCell : UITableViewCell

/// Title label for the cell.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Title label height constrain, by default is set to zero.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *titleLabelHeightConstraint;

/// Text label for the cell.
@property (nonatomic, strong) IBOutlet UILabel *secondaryLabel;

@end
