////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       TitleSubtitleImageTableViewCell.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "TitleSubtitleImageTableViewCell.h"

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation TitleSubtitleImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width/2;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
