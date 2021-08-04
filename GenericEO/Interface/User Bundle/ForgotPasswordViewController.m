////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ForgotPasswordViewController.m
/// @author     Lynette Sesodia
/// @date       2/4/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ForgotPasswordViewController.h"
#import "Constants.h"

#import "MBProgressHUD.h"
#import "GradientMaskImageView.h"
#import "RoundedShadowButton.h"
#import "RoundedTextField.h"

#import "UserManager.h"

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

@interface ForgotPasswordViewController () <UITextFieldDelegate>

/// Decorative image at top of view.
@property (nonatomic, strong) IBOutlet GradientMaskImageView *decorativeImageView;

/// Back button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// Title label for the controller.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Instructions label for the controller.
@property (nonatomic, strong) IBOutlet UILabel *instructionsLabel;

/// Imageview displaying app logo.
@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;

/// Textfield for users to enter their email.
@property (nonatomic, strong) IBOutlet RoundedTextField *emailTextField;

/// Submit button for the controller.
@property (nonatomic, strong) IBOutlet RoundedShadowButton *submitButton;

/// Progress hud displayed
@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self formatTitleText];
    [self formatTextFields];
    [self formatGradientImage];
    
    self.instructionsLabel.text = NSLocalizedString(@"Enter your email so we can send you a reset password link.", nil);
}

#pragma mark - IBActions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submit:(id)sender {
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Get string from text field
    NSString *email = self.emailTextField.text;
    
    // Validate email
    BOOL valid = [self validEmail:email];
    
    if (valid) {
        // Sent reset request
        [[[UserManager alloc] init] resetPasswordForEmail:email withCompletion:^(NSError * _Nonnull error) {
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
                self.progressHUD.label.text = @"Password reset link sent";
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Invalid Email", nil)
                                                                       message:NSLocalizedString(@"Please enter your email address used when creating your account.", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction defaultOkAction]];
        [self presentViewController:alert animated:YES completion:^{
            [self.progressHUD hideAnimated:YES];
        }];
    }
}

/**
 Returns a boolean indicating if the email provided is valid.
 */
- (BOOL)validEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - UI Customization

- (void)formatTitleText {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    NSDictionary *boldAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:40.0],
                                     NSParagraphStyleAttributeName: paragraphStyle};
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"Forgot your\n"
                                                                              attributes:attributes];
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:@"Password?" attributes:boldAttributes]];
    [self.titleLabel setAttributedText:title];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
}

- (void)formatTextFields {
    self.emailTextField.delegate = self;
    self.emailTextField.leftView = [self.emailTextField viewWithEmbeddedImageNamed:@"icon-email"];
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
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
    
    [self.decorativeImageView loadGradientWithMaskFromImageNamed:@"splot-shape-corner-right"
                                              withGradientColors:colors
                                                       withFrame:CGRectMake(0, 0, width, height)];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // On return button press, advance to next text field
    if (self.emailTextField.isFirstResponder) {
        [self.emailTextField resignFirstResponder];
        [self submit:textField];
    }
    
    return TRUE;
}

@end
