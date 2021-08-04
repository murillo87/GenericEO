////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PushNotificationPermissionView.m
/// @author     Lynette Sesodia
/// @date       3/5/19
//
//  Copyright © 2019 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "PermissionRequestView.h"
#import "Constants.h"

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

@implementation PermissionRequestView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //Load nib
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"PermissionRequestView" owner:self options:nil] firstObject];
        [self addSubview:view];
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
        
        [self layoutIfNeeded];
    
        // Configure default description label formatting
        self.descriptionLabel.text = NSLocalizedString(@"Don't miss exciting flash sales and exclusive offers in the App!", nil);
        
        // Configure default signup button formatting
        self.signupButton.layer.cornerRadius = self.signupButton.frame.size.height/2;
        self.signupButton.layer.masksToBounds = YES;
        self.signupButton.tintColor = [UIColor whiteColor];
        self.signupButton.backgroundColor = [UIColor colorForType:EODataTypeSingleOil];
        [self.signupButton setTitle:NSLocalizedString(@"Sign Up", nil) forState:UIControlStateNormal];
    }
    return self;
}

- (IBAction)signUp:(UIButton *)sender {
    [self.delegate userDidAgreeToRequestInView:self];
}

@end
