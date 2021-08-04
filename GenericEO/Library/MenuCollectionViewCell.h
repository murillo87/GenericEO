////////////////////////////////////////////////////////////////////////////////
//  SleepSoundsPro
/// @file       MenuCollectionViewCell.h
/// @author     Lynette Sesodia
/// @date       3/26/20
//
//  Copyright © 2020 Cloforce LLC. All rights reserved.
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

@interface MenuCollectionViewCell : UICollectionViewCell

/// The title label for the cell.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Sets the tint color for the cell. This redraws the cell.
@property (nonatomic, strong) UIColor *tintColor;

@end

NS_ASSUME_NONNULL_END
