////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       FeedTableViewCell.h
/// @author     Lynette Sesodia
/// @date       6/18/18
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

@interface FeedTableViewCell : UITableViewCell

/// Background image view for the cell.
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

/// Title label for the cell.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Subtitle label for the cell.
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;

@end
