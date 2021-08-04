////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PriceTableViewCell.h
/// @author     Lynette Sesodia
/// @date       8/7/18
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

@interface PriceTableViewCell : UITableViewCell

/// Imageview displaying the brand logo for the cell.
@property (nonatomic, strong) IBOutlet UIImageView *brandLogoImageView;

/// Label displaying brand name for the cell.
@property (nonatomic, strong) IBOutlet UILabel *brandNameLabel;

/// Label displaying the volume for the cell.
@property (nonatomic, strong) IBOutlet UILabel *volumeLabel;

/// Label displaying the retail price for the cell.
@property (nonatomic, strong) IBOutlet UILabel *retailPriceLabel;

/// Label displaying the wholesale price for the cell.
@property (nonatomic, strong) IBOutlet UILabel *wholesalePriceLabel;

@end
