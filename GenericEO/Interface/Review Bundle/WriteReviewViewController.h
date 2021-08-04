////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       WriteReviewViewController.h
/// @author     Lynette Sesodia
/// @date       7/22/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>

#import "ReviewManager.h"
#import "UserManager.h"
#import "Constants.h"

#import "StarRatingView.h"

#import "LoginViewController.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

static NSString * _Nonnull const DefaultText = @"Write your review here.";
static CGFloat AddReviewTextFieldBottomMargin = 8.0;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface WriteReviewViewController : UIViewController

/// Back button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// Star rating view.
@property (nonatomic, strong) IBOutlet StarRatingView *starRatingView;

/// Textview where the user composes their note.
@property (nonatomic, strong) IBOutlet UITextView *reviewTextView;

/// Bottom space constraint for the text view.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bottomSpace;

/// Save button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *saveButton;

/**
 The parent object for which the review is being created for.
 @note Only used when creating a new review.
 */
@property (nonatomic, strong) PFObject *parent;

/**
 The Review being edited.
 @note Only used when editing existing reviews.
 */
@property (nonatomic, strong) Review *savedReview;

/// The review text being edited.
@property (nonatomic, strong) NSString *reviewText;

/// The star value for the review.
@property (nonatomic) double starValue;

/**
 Initializes a view controller for the user to write a review for the given parent object.
 @param parent The parent PFObject that the review is for. This can be nil if editing an existing review.
 @param review Nullable review object. If nil, a new review will be created. If nonnull the existing review will be edited.
 */
- (id)initForParentObject:(PFObject * _Nullable)parent withExistingReview:(Review * _Nullable)review;

/**
 Saves the current review text as the review for the parent object.
 */
- (void)saveReview;

/**
 Returns to the previous view controller.
 */
- (IBAction)back:(id)sender;

@end

NS_ASSUME_NONNULL_END
