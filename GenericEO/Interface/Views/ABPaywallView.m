//
//  ABPaywallView.m
//  GenericEO
//
//  Created by Lynette Sesodia on 5/5/20.
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
//

#import "ABPaywallView.h"
#import "Constants.h"

@implementation ABPaywallView

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self loadNib];
    
    // Load default labels and images
    self.titleLabel.text = NSLocalizedString(@"Unlock Premium", nil);
    self.titleLabel.font = [UIFont titleFont];
    self.descriptionLabel.text = NSLocalizedString(@"Go premium to access hundreds of recipes, the complete usage guide & more!", nil);
    self.descriptionLabel.font = [UIFont textFont];

    // Format default upgrade button
    [self.upgradeButton setTitle:NSLocalizedString(@"Upgrade", nil) forState:UIControlStateNormal];
    [self.upgradeButton.titleLabel setFont:[UIFont boldTextFont]];
    self.upgradeButton.layer.cornerRadius = 20.0;
    self.upgradeButton.layer.masksToBounds = NO;
    self.upgradeButton.backgroundColor = [UIColor targetAccentColor];
}

- (void)loadNib {
    // Create visual effect view background
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [self addSubview:visualEffectView];
    
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [visualEffectView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [visualEffectView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [visualEffectView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [visualEffectView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    //Get nib from file
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ABPaywallView" owner:self options:nil] firstObject];
    [self addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
    [self layoutIfNeeded];
}

- (void)animate {
    // Animate icon on loop
    CGPoint center = self.iconImageView.center;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.075];
    [animation setRepeatCount:2];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:CGPointMake(center.x - 10.0f, center.y)]];
    [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(center.x + 10.0f, center.y)]];
    [self.iconImageView.layer addAnimation:animation forKey:@"position"];
}

@end
