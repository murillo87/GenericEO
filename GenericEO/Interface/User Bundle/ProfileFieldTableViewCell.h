////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ProfileFieldTableViewCell.h
/// @author     Lynette Sesodia
/// @date       8/31/20
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

@interface ProfileFieldTableViewCell : UITableViewCell

/// Label displaying the title of the cell's field (i.e. Name or Email).
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Label displaying the value of the cell's field (i.e. essentl or email@essentl.com).
@property (nonatomic, strong) IBOutlet UILabel *valueLabel;

@end

NS_ASSUME_NONNULL_END
