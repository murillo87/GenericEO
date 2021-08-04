////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       WriteReviewViewController.m
/// @author     Lynette Sesodia
/// @date       7/22/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "WriteReviewViewController.h"
#import "ABWriteReviewViewController.h"
#import "ESTLWriteReviewViewController.h"
#import "UserProfileViewController.h"
#import "OilViewController.h"
#import "RecipeViewController.h"

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

@interface WriteReviewViewController () <UITextViewDelegate>

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation WriteReviewViewController

- (id)initForParentObject:(PFObject *)parent withExistingReview:(Review *)review {
#ifdef AB
    self = [[ABWriteReviewViewController alloc] init];
#else
    self = [[ESTLWriteReviewViewController alloc] init];
#endif

    self.parent = parent;
    self.savedReview = review;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.reviewTextView.delegate = self;
    
    // Display saved note, if available
    if (self.savedReview) {
        [self.starRatingView setRating:[self.savedReview.starValue intValue]];
        self.reviewTextView.text = self.savedReview.text;
        self.reviewTextView.textColor = [UIColor darkGrayColor];
    }
    
    // Listen for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDid:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDid:) name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - Public Actions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveReview {
    // Save the review
    if (self.savedReview) {
        [[[ReviewManager alloc] init] editReview:self.savedReview
                                         newText:self.reviewTextView.text
                                      starRating:self.starRatingView.currentRating
                                  withCompletion:^(BOOL success, NSError * _Nullable error) {
            
            // Reload reviews on parent if the saved review happens.
            NSInteger index = [self.navigationController.viewControllers indexOfObject:self]-1;
            if (index >= 0) {
                UIViewController *previous = [self.navigationController.viewControllers objectAtIndex:index];
                if ([previous isKindOfClass:[UserProfileViewController class]]) {
                    UserProfileViewController *parent = (UserProfileViewController *)previous;
                    [parent reloadReviews];
                } else if ([previous isKindOfClass:[OilViewController class]]) {
                    //OilViewController *parent = (OilViewController *)previous;
                    //[parent reloadUserReviewCell];
                } else if ([previous isKindOfClass:[RecipeViewController class]]) {
                    //RecipeViewController *parent = (RecipeViewController *)previous;
                    //[parent reloadUserReviewCell];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } else {
        [[[ReviewManager alloc] init] postReviewWithText:self.reviewTextView.text
                                              starRating:self.starRatingView.currentRating
                                       forParentObjectID:self.parent[@"uuid"]
                                          withCompletion:^(BOOL success, NSError * _Nullable error) {
            
            if (success == NO) {
                // Check for no logged in user error
                NSError *loginError = [NSError noLoggedInUserError];
                if ([error.domain isEqualToString:loginError.domain] && error.code == loginError.code) {
                    // Display login page for user.
                    
                    LoginViewController *vc = [[LoginViewController alloc] init];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                    nav.navigationBar.hidden = YES;
                    [self presentViewController:nav animated:YES completion:^{
                        //
                    }];
                }
                
                else {
                    // Display error alert view
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:error.localizedDescription
                                                                                   message:error.localizedRecoverySuggestion
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction defaultOkAction]];
                    [self presentViewController:alert animated:YES completion:^{
                        //
                    }];
                }
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            IPAAnalyticsEvent *event = [IPAAnalyticsEvent eventWithName:AnalyticsAddedReview];
            [event setValue:[NSString stringWithFormat:@"%@", self.parent[@"name"]]
               forAttribute:AnalyticsNameAttribute];
            [[IPAAnalyticsManager sharedInstance] reportEvent:event];
        }];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:DefaultText]) {
        [textView setText:@""];
        textView.textColor = [UIColor darkGrayColor];
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView.text isEqualToString:DefaultText]) {
        [textView setText:@""];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        [textView setText:DefaultText];
        textView.textColor = [UIColor lightGrayColor];
    } else {
        textView.textColor = [UIColor darkGrayColor];
    }
}

#pragma mark - Keyboard

- (void)keyboardDid:(NSNotification *)notification {
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self setTextViewBottomConstraint:height];
}

- (void)setTextViewBottomConstraint:(CGFloat)space {
    [self.view layoutIfNeeded];
    
    self.bottomSpace.constant = space + AddReviewTextFieldBottomMargin;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
