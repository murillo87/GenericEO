////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UserStatsView.h
/// @author     Lynette Sesodia
/// @date       9/18/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
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

@interface UserStatsView : UIView

/**
 Initializes the view for a given user and number of reviews.
 @param user The user to populate the stats for.
 @param reviewCount The number of reviews that the user has posted.
 */
- (id)initForUser:(User *)user withNumberOfReviews:(NSInteger)reviewCount;

/**
 Sets the user for the view.
 @param user The user to populate stats for.
 */
- (void)setUser:(User *)user;

/**
 Sets the review count for the view.
 @param numReviews The number of reviews to display in the stats view.
 */
- (void)setReviewCount:(NSInteger)numReviews;

@end

NS_ASSUME_NONNULL_END
