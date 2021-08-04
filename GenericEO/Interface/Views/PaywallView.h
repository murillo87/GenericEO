////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PaywallView.h
/// @author     Lynette Sesodia
/// @date       6/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

static CGFloat const PaywallViewMinimumHeight = 200.0;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

// Delegate handing paywall view actions
@protocol PaywallViewDelegate <NSObject>

/**
 Informs the delegate that the upgrade button was tapped.
 @param view The PaywallView that recieved the button event.
 */
- (void)iapUpgradeSelectedFromPaywallView:(UIView *)view;

@end


@interface PaywallView : UIView

@property (nonatomic, weak) id<PaywallViewDelegate> delegate;

- (instancetype)initForTarget;

- (IBAction)upgrade:(UIButton *)sender;

- (void)animate;

@end


