////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ReviewManager.h
/// @author     Lynette Sesodia
/// @date       1/7/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
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

@interface ReviewManager : NSObject

#pragma mark - Create

/**
 Creates a new post with the given text and uuid for the parent object.
 */
- (void)postReviewWithText:(NSString *)reviewText
                starRating:(int)rating
         forParentObjectID:(NSString *)parentID
            withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

#pragma mark - Read

/**
 Get reviews.
 */
- (void)getReviewsWithCompletion:(void(^)(NSArray<Review *> *reviews, NSError *error))completion;

/**
 Get reviews for a given parent object.
 @param uuid The unique identifier for the parent object to grab reviews for.
 */
- (void)getReviewsForParentObjectID:(NSString *)uuid
                     withCompletion:(void(^)(NSArray<Review *> * _Nullable reviews, NSError * _Nullable error))completion;

/**
 Get all reviews for a given user.
 @param user The user object to grab reviews for.
 */
- (void)getReviewsForUser:(User *)user
           withCompletion:(void(^)(NSArray<Review *> * _Nullable reviews, NSError * _Nullable error))completion;

#pragma mark - Update

/**
 Updates the review text for a user created review.
 @param review The review object to be updated.
 @param newText The new text for the review.
 @param rating The star rating for the review.
 Completion block returns boolean indicating success or failure and optional error.
 */
- (void)editReview:(Review *)review
           newText:(NSString *)newText
        starRating:(int)rating
    withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

/**
 Upvotes the given review. Completion block returns error if unsuccessful.
 @param review The review to upvote.
 Completion block returns boolean indicating success or failure and optional error.
 */
- (void)upVoteReview:(Review *)review
      withCompletion:(void (^)(BOOL success, NSError * _Nullable error))completion;

/**
 Downvotes the given review.
 @param review The review to downvote.
 Completion block returns boolean indicating success or failure and optional error.
 */
- (void)downVoteReview:(Review *)review
        withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

/**
 Flags the given review as inappropriate.
 @param review The review to flag.
 Completion block returns boolean indicating success or failure and optional error.
 */
- (void)flagReview:(Review *)review
    withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

#pragma mark - Delete

/**
 Deletes an existing review.
 @param review The review to delete.
 Completion block returns boolean indicating success or failure and optional error.
 */
- (void)deleteReview:(Review *)review
      withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
