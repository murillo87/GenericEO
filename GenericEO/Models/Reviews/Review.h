////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       Review.h
/// @author     Lynette Sesodia
/// @date       1/6/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
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

@interface Review : NSObject

/// Unique identifier for the review.
@property (nonatomic, readonly, strong) NSString *uuid;

/// The text for the review.
@property (nonatomic, readonly, strong) NSString *text;

/// The uuid of the parent object the review is for.
@property (nonatomic, readonly, strong) NSString *parentID;

/// The uuid of the user who created the review.
@property (nonatomic, readonly, strong) NSString *authorID;

/// The public username of the user who created the review.
@property (nonatomic, readonly, strong) NSString *authorUsername;

/// The number of times the review has been upvoted.
@property (nonatomic, readonly, strong) NSNumber *upCount;

/// The number of times the review has been downvoted.
@property (nonatomic, readonly, strong) NSNumber *downCount;

/// The star value for the review.
@property (nonatomic, readonly, strong) NSNumber *starValue;

/// The number of times the review has been flagged.
@property (nonatomic, readonly, strong) NSNumber *flagCount;

/// Reference to the saved parse database review object.
@property (nonatomic, readonly, strong) ParseReview *parseReview;

/**
 Initializes a Review with a given parseReview object. This is the only acceptable way to create a Review object.
 @param parseReview A ParseReview object saved in the parse database.
 */
- (id)initWithParseReview:(ParseReview *)parseReview NS_DESIGNATED_INITIALIZER;

- (id)init NS_UNAVAILABLE;
- (id)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
