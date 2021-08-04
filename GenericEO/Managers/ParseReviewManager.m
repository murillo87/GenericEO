////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ParseReviewManager.m
/// @author     Lynette Sesodia
/// @date       1/13/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ParseReviewManager.h"
#import "ParseReview.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

#if defined(AB) && defined(YOUNGLIVING)
static NSString * const ApplicationClass = @"P_AB_YL_Reviews";
#elif defined(ESTL) && defined(YOUNGLIVING)
static NSString * const ApplicationClass = @"";
#elif defined(ESTL) && defined(DOTERRA)
static NSString * const ApplicationClass = @"T_ESTL_MyEO_DT_Reviews";
#elif defined(AB) && defined(DOTERRA)
static NSString * const ApplicationClass = @"P_AB_DT_Reviews";
#else
static NSString * const ApplicationClass = @"";
#endif

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ParseReviewManager

#pragma mark - Create

- (void)postReviewWithText:(NSString *)reviewText
                starRating:(NSNumber *)rating
                      uuid:(NSString *)uuid
                  authorID:(NSString *)authorID
            authorUsername:(NSString *)authorUsername
            parentObjectID:(NSString *)parentID
            withCompletion:(void (^)(BOOL, NSError * _Nonnull))completion {
    
    ParseReview *review = [ParseReview object];
    review.text = reviewText;
    review.starValue = rating;
    review.uuid = uuid;
    review.authorID = authorID;
    review.authorUsername = authorUsername;
    review.parentID = parentID;
    [review saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(succeeded, error);
    }];
}

#pragma mark - Read

- (void)getReviewsWithCompletion:(void (^)(NSArray<ParseReview *> * _Nonnull, NSError * _Nullable))completion {
    PFQuery *query = [ParseReview query];
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

- (void)getReviewsForKey:(NSString *)key
               withValue:(NSString *)value
          withCompletion:(void (^)(NSArray<ParseReview *> * _Nullable, NSError * _Nullable))completion {
    
    PFQuery *query = [ParseReview query];
    query.limit = 1000;
    [query whereKey:key equalTo:value];
    [query orderByAscending:@"upCount"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

#pragma mark - Update

- (void)updateReview:(ParseReview *)review
         withNewText:(nonnull NSString *)newText
          starRating:(nonnull NSNumber *)rating
      withCompletion:(void (^)(BOOL, NSError * _Nullable))completion {
    
    //TODO: May have issues here since the review being passed in is a readonly object.
    review.text = newText;
    review.starValue = rating;
    [review saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(succeeded, error);
    }];
}

- (void)upVoteReview:(ParseReview *)review;  {
    [review incrementKey:@"upCount"];
    [review saveInBackground];
}

- (void)removeUpVoteForReview:(ParseReview *)review {
    [review incrementKey:@"upCount" byAmount:@-1];
    [review saveInBackground];
}

- (void)downVoteReview:(ParseReview *)review; {
    [review incrementKey:@"downCount"];
    [review saveInBackground];
}

- (void)removeDownVoteForReview:(ParseReview *)review {
    [review incrementKey:@"downCount" byAmount:@-1];
    [review saveInBackground];
}

- (void)flagReview:(ParseReview *)review {
    [review incrementKey:@"flagCount" byAmount:@1];
    [review saveInBackground];
}

#pragma mark - Delete

- (void)deleteReview:(ParseReview *)review withCompletion:(void (^)(BOOL, NSError * _Nullable))completion {
    [review deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(YES, error);
    }];
}

@end
