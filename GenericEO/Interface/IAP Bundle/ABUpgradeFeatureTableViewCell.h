////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABUpgradeFeatureTableViewCell.h
/// @author     Lynette Sesodia
/// @date       5/19/20
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

@interface ABUpgradeFeatureTableViewCell : UITableViewCell

/// Icon image view for the cell. This defaults to a check mark.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

/// Attributed label for the cell.
@property (nonatomic, strong) IBOutlet UILabel *attributedLabel;

@end

NS_ASSUME_NONNULL_END
