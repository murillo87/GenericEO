////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       OilViewControllerDelegate.h
/// @author     Lynette Sesodia
/// @date       3/20/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>

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

@protocol OilViewControllerDelegate <NSObject>

@required

#pragma mark Data Processing

- (void)separateKeysForOil:(PFOil *)oil;

- (void)separateKeysForDoterraOil:(PFDoterraOil *)oil;

- (void)separateKeysForYoungLivingOil:(PFYoungLivingOil *)oil;

@optional

- (void)reviewProcessingDidFinishWithRatingAverage:(double)average;

#pragma mark UI Requirements

@required

/**
 Updates the UI to reflect if the favorite button for the oil is selected.
 @param selected Boolean value indicating if the oil object for the controller is a favorited oil.
 */
- (void)setFavoriteButtonSelected:(BOOL)selected;

/**
Updates the UI to reflect if the MyOil button for the oil is selected.
@param selected Boolean value indicating if the oil object for the controller has been saved as a MyOil object.
*/
- (void)setMyOilButtonSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
