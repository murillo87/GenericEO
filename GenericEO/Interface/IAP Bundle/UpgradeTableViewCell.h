////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PricingTableViewCell.h
/// @author     Lynette Sesodia
/// @date       9/5/18
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

@interface UpgradeTableViewCell : UITableViewCell

/// Label displaying duration timeframe.
@property (nonatomic, strong) IBOutlet UILabel *durationLabel;

/// Label displaying discount percentage.
@property (nonatomic, strong) IBOutlet UILabel *discountLabel;

/// Label displaying duration price.
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

/// ImageView displaying check mark if cell is selected, or empty circle if it is not.
@property (nonatomic, strong) IBOutlet UIImageView *checkMarkIcon;

/// Background color for the cell when in the selected state.
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

- (void)configureCellForFreeTrial:(BOOL)trial;

@end
