////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABOilOfDayTableViewCell.h
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

@interface ABOilOfDayTableViewCell : UITableViewCell

/// Label displaying the name of the oil.
@property (nonatomic, strong) IBOutlet UILabel *oilNameLabel;

/// Label displaying the description of the cell's oil.
@property (nonatomic, strong) IBOutlet UILabel *oilDescriptionLabel;

/// Icon image for the cell's oil.
@property (nonatomic, strong) IBOutlet UIImageView *oilIconImageView;

@end

NS_ASSUME_NONNULL_END
