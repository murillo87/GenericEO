////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PermissionRequestView.h
/// @author     Lynette Sesodia
/// @date       3/5/19
//
//  Copyright © 2019 Essentl LLC. All rights reserved.
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

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

/**
 Delegate used to pass back user actions when the PushNotificationPermission
 view is displayed in a tableview or view controller hierarchy.
 */
@protocol PermissionRequestViewDelegate <NSObject>

@optional

/**
 Informs the delegate that the user opted to sign up for push notifications.
 */
- (void)userDidAgreeToRequestInView:(UIView *)view;

@end

@interface PermissionRequestView : UIView

@property (nonatomic, weak) id<PermissionRequestViewDelegate> delegate;

// Label displaying description text for the view.
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

// Sign up button for the view.
@property (nonatomic, strong) IBOutlet UIButton *signupButton;

/// Status icon for signup button.
@property (nonatomic, strong) IBOutlet UIImageView *statusIconImageView;

- (id)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

- (id)init NS_UNAVAILABLE;
- (id)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;


@end

NS_ASSUME_NONNULL_END
