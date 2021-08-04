////////////////////////////////////////////////////////////////////////////////
/// Generic EO
/// @file       ReviewManager.m
/// @author     Lynette Sesodia
/// @date       1/7/20
///
/// Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#import "ReviewManager.h"
#import "ParseReviewManager.h"
#import "UserManager.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ReviewManager()
    
@property (nonatomic, strong) UserManager *userManager;

@property (nonatomic, strong) ParseReviewManager *parseReviewManager;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ReviewManager

- (id)init {
    self = [super init];
    if (self) {
        self.userManager = [[UserManager alloc] init];
        self.parseReviewManager = [[ParseReviewManager alloc] init];
    }
    return self;
}

#pragma mark - Create

- (void)postReviewWithText:(NSString *)reviewText
                starRating:(int)rating
         forParentObjectID:(NSString *)parentID
            withCompletion:(nonnull void (^)(BOOL, NSError * _Nonnull))completion {
    
    // Determine author (user). If none return error.
    [self.userManager getCurrentUserWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {
        if (error != nil) {
            completion(NO, [NSError noLoggedInUserError]);
        } else {
        
            // Get authorID from current user object
            NSString *authorID = user.uuid;
            
            // Get authorUsername from current user object
            NSString *authorUsername = user.username;
            
            // Create review uuid
            NSString *uuid = [self reviewUUIDWithParent:parentID author:authorID time:[NSDate date]];
        
            // Call database manager to post review.
            [self.parseReviewManager postReviewWithText:reviewText
                                             starRating:[NSNumber numberWithInt:rating]
                                                   uuid:uuid
                                               authorID:authorID
                                         authorUsername:authorUsername
                                         parentObjectID:parentID
                                         withCompletion:^(BOOL success, NSError * _Nonnull error) {
                completion(success, error);
            }];
        }
    }];
}

/**
 Creates a unique identifier for the review with the given information.
 @note UUID Format: (authorID)_(parentID)_(time)
 @param parentID The uuid for the parent object of the review.
 @param authorID The uuid for the author of the review.
 @param dateWritten The date object with the timestamp of when the review was written.
 @returns A unique identifier (uuid).
 */
- (NSString *)reviewUUIDWithParent:(NSString *)parentID author:(NSString *)authorID time:(NSDate *)dateWritten {
    NSString *timestamp = [self stringFromDate:dateWritten];
    return [NSString stringWithFormat:@"%@_%@_%@", authorID, parentID, timestamp];
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-yy-dd+hh:mm:ss"];
    return [formatter stringFromDate:date];
}

#pragma mark - Read

- (void)getReviewsWithCompletion:(void (^)(NSArray<Review *> * _Nullable reviews, NSError * _Nullable error))completion {
    
    [self.parseReviewManager getReviewsWithCompletion:^(NSArray<ParseReview *> * _Nullable parseReviews, NSError * _Nonnull error) {
        if (!error) {
            NSArray *reviews = [self reviewsFromParseReviews:parseReviews];
            completion(reviews, error);
        } else {
            completion(nil, error);
        }
    }];
}

- (void)getReviewsForParentObjectID:(NSString *)uuid
                     withCompletion:(void (^)(NSArray<Review *> * _Nullable, NSError * _Nullable))completion {
    
    [self.parseReviewManager getReviewsForKey:@"parentID"
                                    withValue:uuid
                               withCompletion:^(NSArray<ParseReview *> * _Nullable parseReviews, NSError * _Nullable error) {
        if (parseReviews != nil) {
            NSArray *reviews = [self reviewsFromParseReviews:parseReviews];
            completion(reviews, error);
        } else {
            completion(nil, error);
        }
    }];
}

- (void)getReviewsForUser:(User *)user withCompletion:(void (^)(NSArray<Review *> * _Nullable, NSError * _Nullable))completion {
    // Catch nil users
    if (user == nil) {
        completion(nil, [NSError noLoggedInUserError]);
        return;
    }
    
    [self.parseReviewManager getReviewsForKey:@"authorID"
                                    withValue:user.uuid
                               withCompletion:^(NSArray<ParseReview *> * _Nullable parseReviews, NSError * _Nullable error) {
        if (parseReviews != nil) {
            NSArray *reviews = [self reviewsFromParseReviews:parseReviews];
            completion(reviews, error);
        } else {
            completion(nil, error);
        }
    }];
}

- (NSArray<Review *> *)reviewsFromParseReviews:(NSArray<ParseReview *> *)parseReviews {
    NSMutableArray *reviews = [[NSMutableArray alloc] init];
    for (ParseReview *pReview in parseReviews) {
        // Create review
        Review *review = [[Review alloc] initWithParseReview:pReview];
        [reviews addObject:review];
    }
    return reviews;
}

#pragma mark - Update

- (void)editReview:(Review *)review
           newText:(NSString *)newText
        starRating:(int)rating
    withCompletion:(void (^)(BOOL success, NSError * _Nullable error))completion {
    
    // Determine author (user). If the current user does not match the review author return error.
    [self.userManager getCurrentUserWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {
        if (error != nil) {
            completion(NO, [NSError noLoggedInUserError]);
        } else {
            
            // Get authorID from current user object
            NSString *authorID = user.uuid;
            
            // Verify authorIDs match
            if ([review.authorID isEqualToString:authorID]) {
                
                //TODO: Verify this is acceptable since parseReview is a readonly property on the Review object.
                // Call database manager to update review.
                [self.parseReviewManager updateReview:review.parseReview
                                          withNewText:newText
                                           starRating:[NSNumber numberWithInt:rating]
                                       withCompletion:^(BOOL success, NSError * _Nullable error) {
                    completion(success, error);
                }];
                
            } else {
                completion(NO, [NSError cannotEditOtherAuthorReviewsError]);
            }
        }
    }];
}

- (void)upVoteReview:(Review *)review withCompletion:(void (^)(BOOL success, NSError * _Nullable error))completion {
    
    // Get the user. If no current user return error.
    [self.userManager getCurrentUserWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {
        if (error != nil) {
            completion(NO, [NSError noLoggedInUserError]);
        } else {
        
            // Check user voted array
            NSNumber *num = [user.votingRecord valueForKey:review.uuid];
            
            // No key exists so any vote is valid.
            if (num == nil) {
                // UpVote review
                [self.parseReviewManager upVoteReview:review.parseReview];
                
                // Save upvote to user review dictionary
                [user recordVote:@1 forReviewID:review.uuid];
                
                completion(YES, nil);
            }
            
            // Double upvote
            else if ([num intValue] == 1) {
                completion(NO, [NSError alreadyVotedError]);
            }
               
            // Reverse downvote
            else if ([num intValue] == -1) {
                
                // Remove downvote + increment upvote
                [self.parseReviewManager removeDownVoteForReview:review.parseReview];
                [self.parseReviewManager upVoteReview:review.parseReview];
                
                // Save upvote to user review dictionary
                [user recordVote:@1 forReviewID:review.uuid];
                
                completion(YES, nil);
            }
        }
    }];
}

- (void)downVoteReview:(Review *)review withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion {
    
    // Get the user. If no current user return error.
    [self.userManager getCurrentUserWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {
        if (error != nil) {
           completion(NO, [NSError noLoggedInUserError]);
        } else {
       
           // Check user voted array
           NSNumber *num = [user.votingRecord valueForKey:review.uuid];
           
           // No key exists so any vote is valid.
           if (num == nil) {
               // DownVote review
               [self.parseReviewManager downVoteReview:review.parseReview];
               
               // Save upvote to user review dictionary
               [user recordVote:@-1 forReviewID:review.uuid];
               
               completion(YES, nil);
           }
           
           // Reverse upvote
           else if ([num intValue] == 1) {
               // Remove upvote + increment downvote
               [self.parseReviewManager removeUpVoteForReview:review.parseReview];
               [self.parseReviewManager downVoteReview:review.parseReview];
               
               // Save upvote to user review dictionary
               [user recordVote:@-1 forReviewID:review.uuid];
               
               completion(YES, nil);
           }
              
           // Double downvote
           else if ([num intValue] == -1) {
               completion(NO, [NSError alreadyVotedError]);
               
           }
       }
   }];
}

- (void)flagReview:(Review *)review withCompletion:(void (^)(BOOL, NSError * _Nullable))completion {
    
    // Get the user. If no user then return error.
    [self.userManager getCurrentUserWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {
        if (error != nil) {
            completion(NO, [NSError noLoggedInUserError]);
        } else {
            // Check user flagged array.
            if ([user.flagRecord containsObject:review.uuid]) {
                // Return error that the review has already been flagged.
                NSError *error = [NSError errorWithDomain:UserErrorDomain
                                                     code:999
                                                 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Already Flagged.", nil), NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"You have already flagged this review. No further action is needed.", nil)}];
                completion(NO, error);
            } else {
                // Flag review
                [self.parseReviewManager flagReview:review.parseReview];
                
                // Save user flag in their record
                [user recordFlagForReviewID:review.uuid];
                completion(YES, nil);
            }
            
        }
    }];
}

#pragma mark - Delete

- (void)deleteReview:(Review *)review withCompletion:(void (^)(BOOL, NSError * _Nullable))completion {
    
    // Get the user. If no current user return error.
    [self.userManager getCurrentUserWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {
        if (error != nil) {
            completion(NO, [NSError noLoggedInUserError]);
        } else {
            
            // Get authorID from current user object
            NSString *authorID = user.uuid;
            
            // Verify authorIDs match
            if ([review.authorID isEqualToString:authorID]) {
                
                // Call database manager to delete review.
                [self.parseReviewManager deleteReview:review.parseReview withCompletion:^(BOOL success, NSError * _Nullable error) {
                    
                    // TODO: Should we refresh review objects here? Or remove review from a cache?
                    
                    completion(success, error);
                }];
                
            } else {
                completion(NO, [NSError cannotEditOtherAuthorReviewsError]);
            }
        }
    }];
}

@end
