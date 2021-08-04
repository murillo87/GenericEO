//
//  ESTLPaywallView.m
//  GenericEO
//
//  Created by Lynette Sesodia on 5/5/20.
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
//

#import "ESTLPaywallView.h"
#import "Constants.h"

@implementation ESTLPaywallView

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
    self.titleLabel.text = NSLocalizedString(@"Upgrade", nil);
    self.descriptionLabel.text = NSLocalizedString(@"Upgrade to access this premium content", nil);
    
    // Format default upgrade button
    [self.upgradeButton setTitle:NSLocalizedString(@"Upgrade", nil) forState:UIControlStateNormal];
    self.upgradeButton.layer.cornerRadius = 22.0;
    self.upgradeButton.layer.masksToBounds = NO;
    self.upgradeButton.backgroundColor = [UIColor accentBlue];
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
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ESTLPaywallView" owner:self options:nil] firstObject];
    [self addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
    [self layoutIfNeeded];
}

@end
