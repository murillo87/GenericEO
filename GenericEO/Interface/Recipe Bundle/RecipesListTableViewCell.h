////////////////////////////////////////////////////////////////////////////////
//  Essential Oils
/// @file       RecipeListTableViewCell.h
/// @author     Lynette Sesodia
/// @date       5/22/18
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

@interface RecipesListTableViewCell : UITableViewCell

/// Image view for the cell.
@property (nonatomic, strong) IBOutlet UIImageView *mainImageView;

/// Name label for the cell.
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@end
