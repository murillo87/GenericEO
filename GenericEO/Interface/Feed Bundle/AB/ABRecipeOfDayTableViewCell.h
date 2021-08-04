////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABRecipeOfDayTableViewCell.h
/// @author     Lynette Sesodia
/// @date       5/27/20
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

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface ABRecipeOfDayTableViewCell : UITableViewCell

/// The large, centered, imageview on the cell.
@property (nonatomic, strong) IBOutlet UIImageView *largeImage;

/// The description label below the cell's imageview.
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

@end

NS_ASSUME_NONNULL_END
