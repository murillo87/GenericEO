//
//  ESTLPaywallView.h
//  GenericEO
//
//  Created by Lynette Sesodia on 5/5/20.
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaywallView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESTLPaywallView : PaywallView

/// ImageView displaying icon for the PaywallView.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

/// Label displaying title text for the PaywallView.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Label displaying description text for the PaywallView.
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

/// Upgrade button for the view.
@property (nonatomic, strong) IBOutlet UIButton *upgradeButton;

@end

NS_ASSUME_NONNULL_END
