////////////////////////////////////////////////////////////////////////////////
//  SleepSoundsPro
/// @file       MenuCollectionViewCell.m
/// @author     Lynette Sesodia
/// @date       3/26/20
//
//  Copyright © 2020 Cloforce LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "MenuCollectionViewCell.h"
#import "Constants.h"

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
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation MenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont boldTextFont];
    self.tintColor = [UIColor whiteColor]; // Default tint color
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.titleLabel.textColor = (selected) ? [UIColor whiteColor] : self.tintColor;
    self.backgroundColor = (selected) ? self.tintColor : [UIColor clearColor];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    
    self.titleLabel.textColor = tintColor;
    
    self.layer.borderColor = [UIColor targetAccentColor].CGColor;
    self.layer.borderWidth = 1.5;
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
}


@end
