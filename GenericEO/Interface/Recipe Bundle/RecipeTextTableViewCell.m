////////////////////////////////////////////////////////////////////////////////
//  Essential Oils
/// @file       RecipeTextTableViewCell.m
/// @author     Lynette Sesodia
/// @date       3/16/18
//
//  Copyright © 2018 Cloforce LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "RecipeTextTableViewCell.h"
#import "UIFont+Targets.h"

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


@implementation RecipeTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.font = [UIFont font:[UIFont boldTextFont] ofSize:17.0];
    self.secondaryLabel.font = [UIFont textFont];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
