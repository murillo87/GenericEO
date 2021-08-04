////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ImageTextCollectionViewCell.h
/// @author     Lynette Sesodia
/// @date       8/8/18
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

@interface ImageTextCollectionViewCell : UICollectionViewCell

/// Main view for the cell.
@property (nonatomic, strong) IBOutlet UIView *mainView;

/// Image view for the cell.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

/// Title label for the cell.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end
