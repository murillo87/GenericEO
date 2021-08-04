////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       OnboardingViewController.m
/// @author     Greg Young
/// @date       3/1/19
//
//  Copyright © 2019 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "OnboardingViewController.h"
#import "PermissionRequestView.h"
#import "TextFieldRequestView.h"

#import <OneSignal/OneSignal.h>
#import "ParseUserManager.h"
#import "Constants.h"

#import "AppDelegate.h"
#import "TabBarViewController.h"

@import Firebase;

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

static NSInteger const PushNotificationViewTag = 100;
static NSInteger const EmailViewTag            = 101;
static NSInteger TableViewCellHeight = 160;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface OnboardingViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, PermissionRequestViewDelegate>

#pragma mark - Interface Elements

/// Background image for the view.
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

/// Main view with white background above the background image.
@property (nonatomic, strong) IBOutlet UIView *mainView;

/// Header label for the controller.
@property (nonatomic, strong) IBOutlet UILabel *headerLabel;

/// Tableview for the controller.
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/// Tableview height constraint.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

/// Next button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *nextButton;

/// Skip button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *skipButton;

#pragma mark - Instance Variables

/// Request view for push notifications.
@property (nonatomic, strong) PermissionRequestView *pushNotificationRequestView;

/// Request view for user email.
@property (nonatomic, strong) TextFieldRequestView *textFieldRequestView;

// Boolean value indicating if the user accepted Push Notifications.
@property (nonatomic) BOOL userDidAcceptPushNotifications;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation OnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mainView.layer.cornerRadius = 29.0;
    self.mainView.layer.masksToBounds = YES;
    
    [self configureTableView];
    [self configureButtons];
#ifdef AB
    self.headerLabel.text = NSLocalizedString(@"Welcome to Aromabyte!", nil);
    self.headerLabel.font = [UIFont fontWithName:@"bromello" size:30.0];
    self.nextButton.alpha = 0.0;
    //self.backgroundImageView.image = [UIImage imageNamed:@""];
#else
    self.headerLabel.text = NSLocalizedString(@"Welcome to MyEO!", nil);
    self.headerLabel.font = [UIFont fontWithName:@"bromello" size:35.0];
    self.nextButton.alpha = 1.0;
#endif
    
    
    // By default set to no
    self.userDidAcceptPushNotifications = NO;
}

- (void)configureButtons {
    [self.nextButton setTitle:NSLocalizedString(@"Continue", nil) forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = self.nextButton.frame.size.height/2;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.tintColor = [UIColor whiteColor];
    self.nextButton.backgroundColor = [UIColor colorForType:EODataTypeSingleOil];
}

- (void)configureTableView {
    self.tableViewHeightConstraint.constant = TableViewCellHeight * [self tableView:self.tableView numberOfRowsInSection:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = TableViewCellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

#pragma mark - IBActions

- (IBAction)next:(UIButton *)sender {
    if (self.textFieldRequestView.textField.text != nil) {
        if ([self validateEmail:self.textFieldRequestView.textField.text]) {
            [[[ParseUserManager alloc] init] updateParseUserEmail:self.textFieldRequestView.textField.text];
            [self presentTabBarController];
            
            [self logAnalyticsForOnboardingWithEmail:YES andSkip:NO];
            
        } else {
            [self displayEmailAlert];
        }
    } else {
        [self displayEmailAlert];
    }
}

- (void)displayEmailAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Invalid Email", nil)
                                                                   message:NSLocalizedString(@"Please enter a valid email if you would like to recieve special offers and news from us. If not, please select skip to continue.", nil)
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil)
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {}]];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (IBAction)skip:(UIButton *)sender {
    // If the user has entered email info and it is valid, save regardless
    if ([self validateEmail:self.textFieldRequestView.textField.text]) {
        [[[ParseUserManager alloc] init] updateParseUserEmail:self.textFieldRequestView.textField.text];
        
        [self logAnalyticsForOnboardingWithEmail:YES andSkip:YES];
    } else {
        [self logAnalyticsForOnboardingWithEmail:NO andSkip:YES];
    }
    
    [self presentTabBarController];
}

- (void)presentTabBarController {
    AppDelegate *appDel = (AppDelegate *)UIApplication.sharedApplication.delegate;
    
    TabBarViewController *vc = [[TabBarViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.hidden = YES;
    
    appDel.window.rootViewController = nav;
    [appDel.window makeKeyAndVisible];
    
//    [self presentViewController:nav animated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserHasCompletedOnboardingKey];
//    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#ifdef AB
    if (self.userDidAcceptPushNotifications == NO) {
        UIView *v = [[UIView alloc] init];
        v.tag = PushNotificationViewTag;
        [self userDidAgreeToRequestInView:v];
    }
#endif
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#ifdef AB
    return 1;
#else
    return 2;
#endif
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 180)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0: {
            self.pushNotificationRequestView = [[PermissionRequestView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 180)];
            self.pushNotificationRequestView.tag = PushNotificationViewTag;
            self.pushNotificationRequestView.delegate = self;
            self.pushNotificationRequestView.descriptionLabel.text = NSLocalizedString(@"Allow push notifications for exiting flash sales and exclusive in app offers!", nil);
            [self.pushNotificationRequestView.signupButton setTitle:NSLocalizedString(@"Allow", nil) forState:UIControlStateNormal];
            
            [cell addSubview:self.pushNotificationRequestView];
        } break;
            
        case 1: {
            self.textFieldRequestView = [[TextFieldRequestView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 180)];
            self.textFieldRequestView.tag = EmailViewTag;
#ifdef AB
            self.textFieldRequestView.descriptionLabel.text = NSLocalizedString(@"Get exclusive offers and reminders for new content from Aromabyte via email!", nil);
#else
            self.textFieldRequestView.descriptionLabel.text = NSLocalizedString(@"Get exclusive offers and reminders for new content from MyEO via email!", nil);
#endif
            self.textFieldRequestView.textField.delegate = self;
            self.textFieldRequestView.textField.placeholder = NSLocalizedString(@"youremail@sample.com", nil);
            [self.textFieldRequestView.textField addTarget:self action:@selector(textFieldValueDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            [cell addSubview:self.textFieldRequestView];
        } break;
            
        default:
            break;
    }
    
    
    return cell;
}

#pragma mark - PermissionRequestViewDelegate

- (void)userDidAgreeToRequestInView:(UIView *)view {
    switch (view.tag) {
        case PushNotificationViewTag: { // Push Notifications
            // Prompt for push after informing the user about how your app will use them.
            [OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
                NSLog(@"User accepted notifications: %d", accepted);
                self.userDidAcceptPushNotifications = accepted;
                
                [self.pushNotificationRequestView.signupButton setBackgroundColor:[UIColor lightGrayColor]];
                [self.pushNotificationRequestView.signupButton setTintColor:[UIColor darkGrayColor]];
                
                [self animateStatusImageInView:self.pushNotificationRequestView.statusIconImageView withStatus:accepted];
                
#ifdef AB
                [self.skipButton setTitle:NSLocalizedString(@"Continue", nil) forState:UIControlStateNormal];
                self.skipButton.layer.cornerRadius = self.skipButton.frame.size.height/2;
                self.skipButton.layer.masksToBounds = YES;
                [self.skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.skipButton.backgroundColor = [UIColor colorForType:EODataTypeSingleOil];
#endif
            }];
        } break;
            
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldValueDidChange:(UITextField *)textField {
    NSLog(@"textField.text = %@", textField.text);
    
    // Update icon next to email if valid email
    [self animateStatusImageInView:self.textFieldRequestView.statusIconImageView withStatus:[self validateEmail:textField.text]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resignFirstResponder];
    return YES;
}

#pragma mark - Email Validation

- (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - Animations

- (void)animateStatusImageInView:(UIImageView *)view withStatus:(BOOL)valid {
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.5;
    [view.layer addAnimation:animation forKey:@"kCATransitionFade"];
    
    // This will fade:
    NSString *imgStr = (valid) ? @"status-valid" : @"status-invalid";
    view.image = [UIImage imageNamed:imgStr];
}

#pragma mark - Analytics

- (void)logAnalyticsForOnboardingWithEmail:(BOOL)didEnterEmail andSkip:(BOOL)didSkip {
#ifdef AB
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemName:@"Onboarding-Notification",
                                     @"push" : @(self.userDidAcceptPushNotifications)
                                     }];
#else
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemName:@"Onboarding-Notification",
                                     @"email" : @(didEnterEmail),
                                     @"push" : @(self.userDidAcceptPushNotifications),
                                     @"skip" : @(didSkip)
                                     }];
#endif
}

@end
