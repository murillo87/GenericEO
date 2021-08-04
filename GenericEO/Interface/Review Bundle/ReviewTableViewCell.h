////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ReviewTableViewCell.h
/// @author     Lynette Sesodia
/// @date       2/19/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import "Review.h"
#import "User.h"

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

@protocol ReviewTableViewCellDelegate;

@interface ReviewTableViewCell : UITableViewCell

#pragma mark Interface Outlets

/// The imageview displaying the review authors image icon.
@property (nonatomic, strong) IBOutlet UIImageView *authorIconImageView;

/// The label displaying the review author's username.
@property (nonatomic, strong) IBOutlet UILabel *authorUsernameLabel;

/// The imageview displaying the review's star rating.
@property (nonatomic, strong) IBOutlet UIImageView *starRatingImageView;

/// The label displaying the review text.
@property (nonatomic, strong) IBOutlet UILabel *reviewTextLabel;

/// Button to upvote review.
@property (nonatomic, strong) IBOutlet UIButton *upvoteButton;

/// Button to downvote review.
@property (nonatomic, strong) IBOutlet UIButton *downvoteButton;

/// Label displaying the review's vote count.
@property (nonatomic, strong) IBOutlet UILabel *voteCountLabel;

#pragma mark Instance Variables

/// The review for the cell.
@property (nonatomic, strong) Review *review;

/// The delegate for the cell.
@property (nonatomic, weak) id<ReviewTableViewCellDelegate> delegate;

/// The indexPath for the cell in it's parent tableview.
@property (nonatomic, strong) NSIndexPath *indexPath;

#pragma mark Methods

/**
 Configures the cell's UI to display a review for a reviewable object.
 @param review The review to display.
 */
- (void)configureCellForReview:(Review *)review;

/**
 Configures the cell's UI to display a review the current user has previously posted.
 @param user The current user to display the review for.
 @param review The review to display.
 */
- (void)configureCellForUser:(User *)user review:(Review *)review;

@end


@protocol ReviewTableViewCellDelegate <NSObject>

/**
 Informs the delegate that the cell upvoted the given review.
 */
- (void)shouldUpvoteReviewForCell:(ReviewTableViewCell *)cell;

/**
 Informs the delegate that the cell downvoted the given review.
 */
- (void)shouldDownvoteReviewForCell:(ReviewTableViewCell *)cell;

@end

NS_ASSUME_NONNULL_END
