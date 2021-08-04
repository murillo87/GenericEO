////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABUpgradeFeatureTableViewCell.m
/// @author     Lynette Sesodia
/// @date       5/19/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ABUpgradeFeatureTableViewCell.h"

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

@implementation ABUpgradeFeatureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
