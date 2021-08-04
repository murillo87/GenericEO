////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ShoppingListTableViewCell.m
/// @author     Lynette Sesodia
/// @date       8/6/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ShoppingListTableViewCell.h"

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

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ShoppingListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.whiteBackgroundView.layer.cornerRadius = 10.0;
    self.whiteBackgroundView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.height/2;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
