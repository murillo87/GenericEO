//
//  ABOilTableViewCell.m
//  GenericEO
//
//  Created by Lynette Sesodia on 4/30/20.
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
//

#import "ABOilTableViewCell.h"
#import "Constants.h"

@implementation ABOilTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.font = [UIFont cellFont];
    
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.height/2;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.iconImageView.layer.borderWidth = 1.0;
    self.iconImageView.layer.borderColor = [UIColor systemGroupedBackgroundColor].CGColor;
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
