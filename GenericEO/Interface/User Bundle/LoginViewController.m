////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       LoginViewController.m
/// @author     Lynette Sesodia
/// @date       2/4/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "ForgotPasswordViewController.h"

#import "UserManager.h"

#import "MBProgressHUD.h"
#import "GradientMaskImageView.h"
#import "RoundedShadowButton.h"
#import "RoundedTextField.h"

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

@interface LoginViewController () <UITextFieldDelegate>

/// Decorative image at top of view.
@property (nonatomic, strong) IBOutlet GradientMaskImageView *decorativeImageView;

/// Title label for the controller.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Imageview displaying app logo.
@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;

/// Textfield for users to enter their username.
@property (nonatomic, strong) IBOutlet RoundedTextField *usernameTextField;

/// Textfield for users to enter their password.
@property (nonatomic, strong) IBOutlet RoundedTextField *passwordTextField;

/// Login button for the controller.
@property (nonatomic, strong) IBOutlet RoundedShadowButton *loginButton;

/// Forgot password button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *forgotPasswordButton;

/// Label displaying the no account signup text.
@property (nonatomic, strong) IBOutlet UILabel *signupTextLabel;

/// Signup button for the controller.
@property (nonatomic, strong) IBOutlet RoundedShadowButton *signupButton;

/// Back button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// Progress hud displayed
@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor = [UIColor colorWithHexString:@"cd98d8"];
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    
    [self formatTitleText];
    [self formatGradientImage];
    [self formatTextFields];
   
    [self.loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [self.signupButton setTitle:NSLocalizedString(@"Sign Up", nil) forState:UIControlStateNormal];
}

#pragma mark - UI Customization

- (void)formatTitleText {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    NSDictionary *boldAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:40.0],
                                     NSParagraphStyleAttributeName: paragraphStyle};
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"Welcome back\n"
                                                                              attributes:attributes];
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:@"Log In!" attributes:boldAttributes]];
    [self.titleLabel setAttributedText:title];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
}

- (void)formatGradientImage {

    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.9;
    CGFloat height = width/37*30;
    
#ifdef DOTERRA
    NSArray *colors = @[(__bridge id)[UIColor colorWithHexString:@"cd98d8"].CGColor,  // start color
                        (__bridge id)[UIColor accentPurple].CGColor]; // end color
#elif YOUNGLIVING
    NSArray *colors = @[(__bridge id)[UIColor colorWithHexString:@"cd98d8"].CGColor,  // start color
                        (__bridge id)[UIColor targetAccentColor].CGColor]; // end color
#else
    NSArray *colors = @[(__bridge id)[UIColor colorWithHexString:@"cd98d8"].CGColor,  // start color
                        (__bridge id)[UIColor accentPurple].CGColor]; // end color
#endif
    [self.decorativeImageView loadGradientWithMaskFromImageNamed:@"splot-shape-corner"
                                              withGradientColors:colors
                                                       withFrame:CGRectMake(0, 0, width, height)];
}

- (void)formatTextFields {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12, 10, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"icon-show-eye"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon-hide-eye"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(togglePassword:) forControlEvents:UIControlEventTouchUpInside];
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    [btnView addSubview:btn];
    
    self.usernameTextField.delegate = self;
    self.usernameTextField.leftView = [self.usernameTextField viewWithEmbeddedImageNamed:@"icon-user"];
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTextField.delegate = self;
    self.passwordTextField.leftView = [self.passwordTextField viewWithEmbeddedImageNamed:@"icon-password"];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.rightView = btnView;
    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.passwordTextField setSecureTextEntry:YES];
}

- (void)togglePassword:(UIButton *)sender {
    [self hidePassword:sender.selected];
    [sender setSelected:!sender.selected];
}

- (void)hidePassword:(BOOL)shouldHide {
    [self.passwordTextField setSecureTextEntry:shouldHide];
}

#pragma mark - IBActions

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

- (IBAction)login:(id)sender {
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Login user with provided info
    [[[UserManager alloc] init] loginUserWithUsername:self.usernameTextField.text andPassword:self.passwordTextField.text withCompletion:^(User * _Nullable user, NSError * _Nullable error) {
        
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:error.localizedDescription.capitalizedString
                                                                           message:error.localizedRecoverySuggestion
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction defaultOkAction]];
            [self presentViewController:alert animated:YES completion:^{
                [self.progressHUD hideAnimated:YES];
            }];
        } else {
            self.progressHUD.mode = MBProgressHUDModeCustomView;
            self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-check"]];
            self.progressHUD.label.text = @"Login successful";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{
                    //
                }];
            });
        }
    }];
}

- (IBAction)forgotPassword:(id)sender {
    ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc] init];
    [self.navigationController showViewController:vc sender:self];
}

- (IBAction)signup:(id)sender {
    SignUpViewController *vc = [[SignUpViewController alloc] init];
    [self.navigationController showViewController:vc sender:self];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // On return button press, advance to next text field
    if (self.usernameTextField.isFirstResponder) {
        [self.passwordTextField becomeFirstResponder];
        
    } else if (self.passwordTextField.isFirstResponder) {
        [self.passwordTextField resignFirstResponder];
        [self login:textField];
    }
    
    return TRUE;
}

@end
