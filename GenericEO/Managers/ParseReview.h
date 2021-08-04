////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ParseReview.h
/// @author     Lynette Sesodia
/// @date       1/13/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

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

@interface ParseReview : PFObject<PFSubclassing>

/// Unique identifier for the review.
@property (nonatomic, strong) NSString *uuid;

/// The text for the review.
@property (nonatomic, strong) NSString *text;

/// The uuid of the parent object the review is for.
@property (nonatomic, strong) NSString *parentID;

/// The uuid of the user who created the review.
@property (nonatomic, strong) NSString *authorID;

/// The public username of the user who created the review.
@property (nonatomic, strong) NSString *authorUsername;

/// The number of times the review has been upvoted.
@property (nonatomic, strong) NSNumber *upCount;

/// The number of times the review has been downvoted.
@property (nonatomic, strong) NSNumber *downCount;

/// The star value for the review.
@property (nonatomic, strong) NSNumber *starValue;

/// The number of times the review has been flagged.
@property (nonatomic, strong) NSNumber *flagCount;

@end

NS_ASSUME_NONNULL_END
