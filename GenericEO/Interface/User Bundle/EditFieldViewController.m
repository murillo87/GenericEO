////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       EditFieldViewController.m
/// @author     Lynette Sesodia
/// @date       8/31/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "EditFieldViewController.h"
#import "Constants.h"
#import "RoundedTextField.h"
#import "RoundedShadowButton.h"

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

@interface EditFieldViewController () <UITextFieldDelegate>

/// Back button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// Main input text field for the cell.
@property (nonatomic, strong) IBOutlet RoundedTextField *primaryTextField;

/// Label displaying the user facing type for the primaryTextField.
@property (nonatomic, strong) IBOutlet UILabel *primaryLabel;

/// Secondary input text field for the cell.
@property (nonatomic, strong) IBOutlet RoundedTextField *secondaryTextField;

/// Label displaying the user facing type for the secondaryTextField.
@property (nonatomic, strong) IBOutlet UILabel *secondaryLabel;

/// Save button for the controller.
@property (nonatomic, strong) IBOutlet RoundedShadowButton *saveButton;

/// Bottom space constraint for the saveButton.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *saveButtonBottomSpaceConstraint;

/// The data type of the controller.
@property (nonatomic) TextFieldDataType dataType;

/// The passed in value for the controller.
@property (nonatomic, strong) NSString *receivedValue;

/// The currently active text field.
@property (nonatomic, strong) UITextField * _Nullable activeTextField;

/// Reference to primary textfield show/hide button.
@property (nonatomic, strong) UIButton * _Nullable primaryTFHideButton;

/// Reference to secondary textfield show/hide button.
@property (nonatomic, strong) UIButton * _Nullable secondaryTFHideButton;

/// The user manager.
@property (nonatomic, strong) UserManager *userManager;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation EditFieldViewController

- (id)initForType:(TextFieldDataType)type {
    self = [super init];
    if (self) {
        self.dataType = type;
    }
    
    return self;
}

- (id)initForType:(TextFieldDataType)type withValue:(NSString *)value {
    self = [super init];
    if (self) {
        self.dataType = type;
        self.receivedValue = value;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userManager = [[UserManager alloc] init];
    
    self.backButton.tintColor = [UIColor targetAccentColor];
    
    // Configure textfield visibility and label text based on the dataType of the controller.
    self.primaryTextField.delegate = self;
    self.secondaryTextField.delegate = self;
    self.primaryTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.secondaryTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    switch (self.dataType) {
        case DataTypeUsername:
            self.primaryLabel.text = NSLocalizedString(@"Username", nil);
            self.primaryTextField.text = self.receivedValue;
            self.secondaryLabel.hidden = YES;
            self.secondaryTextField.hidden = YES;
            break;
            
        case DataTypeEmail:
            self.primaryLabel.text = NSLocalizedString(@"Email", nil);
            self.primaryTextField.text = self.receivedValue;
            self.secondaryLabel.hidden = YES;
            self.secondaryTextField.hidden = YES;
            break;
            
        case DataTypePassword:
            self.primaryLabel.text = NSLocalizedString(@"New Password", nil);
            self.secondaryLabel.text = NSLocalizedString(@"Confirm New Password", nil);
            [self formatTextFieldsForPassword];
            break;
            
        default:
            self.primaryLabel.text = @"New Value";
            self.primaryTextField.text = self.receivedValue;
            self.secondaryLabel.hidden = YES;
            self.secondaryTextField.hidden = YES;
            break;
    }
    
    // Listen for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

/**
 Formats the textfields to contain show/hide images and toggle secure text visibility on button press.
 */
- (void)formatTextFieldsForPassword {
    self.primaryTFHideButton = [self showHideButtonForTextField];
    UIView *btnViewPW = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    [btnViewPW addSubview:self.primaryTFHideButton];
    self.primaryTextField.rightView = btnViewPW;
    self.primaryTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.primaryTextField setSecureTextEntry:YES];
    
    self.secondaryTFHideButton = [self showHideButtonForTextField];
    UIView *btnViewCPW = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    [btnViewCPW addSubview:self.secondaryTFHideButton];
    self.secondaryTextField.rightView = btnViewCPW;
    self.secondaryTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.secondaryTextField setSecureTextEntry:YES];
}

- (UIButton *)showHideButtonForTextField {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12, 10, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"icon-show-eye"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon-hide-eye"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(togglePassword:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // On return button press, advance to next text field
    if (self.primaryTextField.isFirstResponder) {
        if (self.dataType == DataTypePassword) {
            [self.secondaryTextField becomeFirstResponder];
        } else {
            [self.primaryTextField resignFirstResponder];
            self.activeTextField = nil;
        }
        
    } else if (self.secondaryTextField.isFirstResponder) {
        [self.secondaryTextField resignFirstResponder];
        self.activeTextField = nil;
    }
    
    return TRUE;
}

- (void)togglePassword:(UIButton *)sender {
    BOOL selected = sender.selected;
    [self hidePassword:selected];
    [self.primaryTFHideButton setSelected:!selected];
    [self.secondaryTFHideButton setSelected:!selected];
}

- (void)hidePassword:(BOOL)shouldHide {
    [self.primaryTextField setSecureTextEntry:shouldHide];
    [self.secondaryTextField setSecureTextEntry:shouldHide];
}

#pragma mark Actions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    switch (self.dataType) {
        case DataTypeEmail: {
            // Verify that the email entered is valid.
            if (![self validEmail:self.primaryTextField.text]) {
                // Display invalid email error message
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Invalid Email", nil) message:NSLocalizedString(@"Please verify that your email address was entered correctly.", nil) preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction defaultOkAction]];
                [alertController show];
                return;
            }
            
            // Change email for the user.
            else {
                [self.userManager updateEmail:self.primaryTextField.text withCompletion:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [self showFailedUpdateAlertWithError:error];
                    }
                }];
            }
        } break;
            
        case DataTypePassword: {
            // Verify password and confirm password fields match.
            if (![self passwordsMatch]) {
                // Display mismatched passwords error.
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Passwords Do Not Match", nil) message:NSLocalizedString(@"Please verify that the password and confirm password fields match, then try again.", nil) preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction defaultOkAction]];
                [alertController show];
                return;
            }
            
            // Change password for the user.
            else {
                [self.userManager updatePassword:self.primaryTextField.text withCompletion:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [self showFailedUpdateAlertWithError:error];
                    }
                }];
            }
        } break;
            
        case DataTypeUsername: {
            [self.userManager updateUsername:self.primaryTextField.text withCompletion:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [self showFailedUpdateAlertWithError:error];
                }
            }];
        } break;
            
        default:
            break;
    }
}

- (void)showFailedUpdateAlertWithError:(NSError *)error {
    NSString *typeStr = @"";
    
    switch (self.dataType) {
        case DataTypeUsername:  typeStr = NSLocalizedString(@"Username", nil);  break;
        case DataTypePassword:  typeStr = NSLocalizedString(@"Password", nil);  break;
        case DataTypeEmail:     typeStr = NSLocalizedString(@"Email", nil);     break;
        default: break;
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Unable to Update", nil), typeStr];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction defaultOkAction]];
    [alert show];
}

#pragma mark Data Validation

/**
 Returns a boolean indicating if the email provided is valid.
 */
- (BOOL)validEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)passwordsMatch {
    if ([self.primaryTextField.text isEqualToString:self.secondaryTextField.text]) {
        return TRUE;
    } else {
        return FALSE;
    }
}

#pragma mark Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    [self.view layoutIfNeeded];
    
    // Adjust bottom space constraint on save button to move with keyboard
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.saveButtonBottomSpaceConstraint.constant = keyboardSize.height + 50;
        [self.view layoutIfNeeded]; // Called on parent view
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // Reset the bottom space constraint on the save button
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        self.saveButtonBottomSpaceConstraint.constant = 50.0;
        [self.view layoutIfNeeded]; // Called on parent view
    }];
}

@end
