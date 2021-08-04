//
//  TwoColumnTableViewCell.m
//  GenericEO
//
//  Created by Lynette Sesodia on 3/21/20.
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
//

#import "TwoColumnTableViewCell.h"
#import "UIFont+Targets.h"

@implementation TwoColumnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.leftLabel.font = [UIFont boldTextFont];
    self.rightLabel.font = [UIFont textFont];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
