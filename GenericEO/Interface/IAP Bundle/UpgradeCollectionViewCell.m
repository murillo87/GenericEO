//
//  UpgradeCollectionViewCell.m
//  GenericEO
//
//  Created by Lynette Sesodia on 6/26/18.
//  Copyright © 2018 Lynette Sesodia. All rights reserved.
//

#import "UpgradeCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@implementation UpgradeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.colorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    self.colorView.layer.cornerRadius = 22;
    
    self.mostPopularLabel.layer.cornerRadius = 10;
    self.mostPopularLabel.layer.masksToBounds = YES;
    self.mostPopularLabel.backgroundColor = [UIColor accentYellow];

    self.discountLabel.layer.cornerRadius = 5;
    self.discountLabel.layer.masksToBounds = YES;
    self.discountLabel.backgroundColor = [UIColor accentBlue];
    
    self.durationLabel.textColor = [UIColor blackColor];
    self.priceLabel.textColor = [UIColor blackColor];
}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        self.colorView.backgroundColor = [UIColor colorWithColor:[UIColor accentYellow] alpha:0.25];
        self.colorView.layer.borderColor = [UIColor accentYellow].CGColor;
        self.colorView.layer.borderWidth = 2.0;
        
    } else {
        self.colorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
        self.colorView.layer.borderWidth = 0.0;
    }
}

- (void)configureCellForFreeTrial {
    self.durationLabel.text = @"";
    self.weeklyPriceLabel.text = NSLocalizedString(@"Try For Free", nil);
    self.weeklyPriceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0];
}



@end
