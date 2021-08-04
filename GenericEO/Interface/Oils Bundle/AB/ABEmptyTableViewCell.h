////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABEmptyTableViewCell.h
/// @author     Lynette Sesodia
/// @date       3/23/20
//
//  Copyright © 2020 Lynette Sesodia LLC. All rights reserved.
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

@interface ABEmptyTableViewCell : UITableViewCell

/// Icon image view for the cell.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

/// Title label for the cell.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Subtitle label for the cell.
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;

@end

NS_ASSUME_NONNULL_END
