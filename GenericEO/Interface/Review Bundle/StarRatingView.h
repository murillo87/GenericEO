////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       StarRatingView.h
/// @author     Lynette Sesodia
/// @date       2/3/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

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

@interface StarRatingView : UIView

/// The current rating set from the view.
@property (nonatomic) int currentRating;

/**
 Sets the rating value for the view.
 @param rating The rating value to be displayed (must be between 0 and 5)
 */
- (void)setRating:(int)rating;

@end

NS_ASSUME_NONNULL_END
