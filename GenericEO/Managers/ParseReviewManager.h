////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ParseReviewManager.h
/// @author     Lynette Sesodia
/// @date       01/13/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "ParseReview.h"

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

@interface ParseReviewManager : NSObject

#pragma mark - Create

/**
 Creates a new post with the given text and uuid for the parent object.
 @param reviewText The text for the review.
 @param rating The star rating for the review.
 @param uuid The unique identifier for the review.
 @param authorID The unique identifier for the author of the review.
 @param authorUsername The public username for the author of the review.
 @param parentID The unique identifier for the parent object the review is for.
 Completion block returns bool indicating success or failure with an optional error.
 */
- (void)postReviewWithText:(NSString *)reviewText
                starRating:(NSNumber *)rating
                      uuid:(NSString *)uuid
                  authorID:(NSString *)authorID
            authorUsername:(NSString *)authorUsername
            parentObjectID:(NSString *)parentID
            withCompletion:(void (^)(BOOL, NSError * _Nonnull))completion;

#pragma mark - Read

- (void)getReviewsWithCompletion:(void(^)(NSArray<ParseReview *> * _Nullable reviews, NSError * _Nullable error))completion;

- (void)getReviewsForKey:(NSString *)key
               withValue:(NSString *)value
          withCompletion:(void(^)(NSArray<ParseReview *> * _Nullable reviews, NSError * _Nullable error))completion;

#pragma mark - Update

/**
 Updates an existing review with new text.
 @param review The existing ParseReview object.
 @param newText The new text for the existing review object.
 Completion block returns bool indicating success or failure with an optional error.
 */
- (void)updateReview:(ParseReview *)review
         withNewText:(NSString *)newText
          starRating:(NSNumber *)rating
      withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

/**
 Upvotes the given review. Completion block returns error if unsuccessful.
 @param review The ParseReview object to upvote.
 */
- (void)upVoteReview:(ParseReview *)review;

/**
 Removes a previous upvote for a given review.
 @param review The ParseReview object to remove the upvote.
 */
- (void)removeUpVoteForReview:(ParseReview *)review;

/**
 Downvotes the given review.
 @param review The ParseReview object to downvote.
 */
- (void)downVoteReview:(ParseReview *)review;

/**
 Removes a previous downvote for a given review.
 @param review The ParseReview object to remove the downvote.
*/
- (void)removeDownVoteForReview:(ParseReview *)review;

/**
 Flags the given reivew as inappropriate.
 @param review The ParseReview object to flag.
 */
- (void)flagReview:(ParseReview *)review;

#pragma mark - Delete

/**
 Deletes an existing review.
 @param review The ParseReview object to delete.
 Completion block returns boolean indicating success or failure and optional error.
*/
- (void)deleteReview:(ParseReview *)review
      withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
