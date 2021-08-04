////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       SignUpViewController.m
/// @author     Lynette Sesodia
/// @date       2/4/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "SignUpViewController.h"
#import "Constants.h"

#import "UserManager.h"

#import "MBProgressHUD.h"
#import "GradientMaskImageView.h"
#import "RoundedTextField.h"
#import "RoundedShadowButton.h"
#import "UIAlertController+Window.h"

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

@interface SignUpViewController () <UITextFieldDelegate>

/// Scroll view in which all view UI is contained.
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

/// Decorative image at top of view.
@property (nonatomic, strong) IBOutlet GradientMaskImageView *decorativeImageView;

/// Back button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// Title label for the controller.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Instructions label for the controller.
@property (nonatomic, strong) IBOutlet UILabel *instructionsLabel;

/// Textfield for users to enter their desired username.
@property (nonatomic, strong) IBOutlet RoundedTextField *usernameTextField;

/// Textfield for users to enter their email.
@property (nonatomic, strong) IBOutlet RoundedTextField *emailTextField;

/// Textfield for users to enter their password.
@property (nonatomic, strong) IBOutlet RoundedTextField *passwordTextField;

/// Textfield for users to enter their confirm password.
@property (nonatomic, strong) IBOutlet RoundedTextField *confirmPasswordTextField;

/// Submit button for the controller.
@property (nonatomic, strong) IBOutlet RoundedShadowButton *submitButton;

/// Progress indicator for the controller.
@property (nonatomic, strong) IBOutlet MBProgressHUD *progressHUD;

/// Reference to password textfield show/hide button.
@property (nonatomic, strong) UIButton *passwordTFHideButton;

/// Reference to confirm password textfield show/hide button.
@property (nonatomic, strong) UIButton *confirmPasswordTFHideButton;

/// Reference ot the currently active text field.
@property (nonatomic, strong) UITextField *activeTextField;

/// Reference to the alert window for displaying UIAlertControllers when modally presented.
@property (nonatomic, strong) UIWindow *alertWindow;


@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    
    [self formatTitleText];
    [self formatGradientImage];
    [self formatTextFields];

    self.instructionsLabel.text = NSLocalizedString(@"Enter your info to create an account.", nil);
    
    [self.submitButton setTitle:NSLocalizedString(@"Create Account", nil) forState:UIControlStateNormal];
    
    // Listen for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - UI Customization

- (void)formatTitleText {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    NSDictionary *boldAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:40.0],
                                     NSParagraphStyleAttributeName: paragraphStyle};
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"Hello!\n"
                                                                              attributes:attributes];
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:@"Sign Up!" attributes:boldAttributes]];
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
    [self.decorativeImageView loadGradientWithMaskFromImageNamed:@"splot-shape-corner-right"
                                              withGradientColors:colors
                                                       withFrame:CGRectMake(0, 0, width, height)];
}

- (void)formatTextFields {
    
    self.usernameTextField.delegate = self;
    self.usernameTextField.leftView = [self.usernameTextField viewWithEmbeddedImageNamed:@"icon-user"];
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.emailTextField.delegate = self;
    self.emailTextField.leftView = [self.emailTextField viewWithEmbeddedImageNamed:@"icon-email"];
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTFHideButton = [self showHideButtonForTextField];
    UIView *btnViewPW = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    [btnViewPW addSubview:self.passwordTFHideButton];
    self.passwordTextField.delegate = self;
    self.passwordTextField.leftView = [self.passwordTextField viewWithEmbeddedImageNamed:@"icon-password"];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.rightView = btnViewPW;
    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.passwordTextField setSecureTextEntry:YES];
    
    self.confirmPasswordTFHideButton = [self showHideButtonForTextField];
    UIView *btnViewCPW = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    [btnViewCPW addSubview:self.confirmPasswordTFHideButton];
    self.confirmPasswordTextField.delegate = self;
    self.confirmPasswordTextField.leftView = [self.confirmPasswordTextField viewWithEmbeddedImageNamed:@"icon-password"];
    self.confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.confirmPasswordTextField.rightView = btnViewCPW;
    self.confirmPasswordTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.confirmPasswordTextField setSecureTextEntry:YES];
}

- (UIButton *)showHideButtonForTextField {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12, 10, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"icon-show-eye"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon-hide-eye"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(togglePassword:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)togglePassword:(UIButton *)sender {
    BOOL selected = sender.selected;
    [self hidePassword:selected];
    [self.passwordTFHideButton setSelected:!selected];
    [self.confirmPasswordTFHideButton setSelected:!selected];
}

- (void)hidePassword:(BOOL)shouldHide {
    [self.passwordTextField setSecureTextEntry:shouldHide];
    [self.confirmPasswordTextField setSecureTextEntry:shouldHide];
}

#pragma mark - IBActions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signup:(id)sender {
    // Verify that the passwords match.
    if ([self passwordsMatch]) {
        self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.progressHUD.mode = MBProgressHUDModeIndeterminate;
        
        // Begin user signup
        UserManager *userManager = [[UserManager alloc] init];
        [userManager createUserWithEmail:self.emailTextField.text
                                    name:self.usernameTextField.text
                                      pw:self.passwordTextField.text
                          withCompletion:^(User * _Nullable user, NSError * _Nullable error) {
            
            [self.progressHUD hideAnimated:TRUE];
            
            if (error) {
                // Display error in popup
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Signup Failed", nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction defaultOkAction]];
                [alertController show];
                
            } else {
                // TODO: Dismiss controller
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Signup Successful", nil) message:NSLocalizedString(@"Welcome to the Aromabyte family! We look forward to having you as part of our growing community of essential oils users!", nil) preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:^{}];
                }]];
                [alertController show];
            }
        }];
        
    } else {
        // Display mismatched passwords error.
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Passwords Do Not Match", nil) message:NSLocalizedString(@"Please verify that the password and confirm password fields match, then try again.", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction defaultOkAction]];
        [alertController show];
    }
}

- (BOOL)passwordsMatch {
    if ([self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        return TRUE;
    } else {
        return FALSE;
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    // On return button press, advance to next text field
    if (self.usernameTextField.isFirstResponder) {
        [self.emailTextField becomeFirstResponder];
        
    } else if (self.emailTextField.isFirstResponder) {
        [self.passwordTextField becomeFirstResponder];
        
    } else if (self.passwordTextField.isFirstResponder) {
        [self.confirmPasswordTextField becomeFirstResponder];
  
    } else if (self.confirmPasswordTextField.isFirstResponder) {
        [self.confirmPasswordTextField resignFirstResponder];
        [self signup:textField];
        self.activeTextField = nil;
    }
    
    return TRUE;
}

#pragma mark - Keyboard

- (void)keyboardDidShow:(NSNotification *)notification {
    
    // Adjust content insets
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll so its visible.
    CGRect rect = self.view.frame;
    rect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(rect, self.activeTextField.frame.origin)) {
        CGPoint scrollPoint = CGPointMake(0, self.activeTextField.frame.origin.y - keyboardSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:TRUE];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
    // Reset the content insets to full screen
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}


@end
