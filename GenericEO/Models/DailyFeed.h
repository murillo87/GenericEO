////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       DailyFeed.h
/// @author     Lynette Sesodia
/// @date       5/27/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "OilModel.h"

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

/**
 Model object for the daily feed.
 */
@interface DailyFeed : PFObject <PFSubclassing>

/// The oil object for the oil of the day.
@property (nonatomic, strong) PFObject<OilModel> * _Nullable oil;

/// The uuid of the oil object for the oil of the day.
@property (nonatomic, strong) NSString * oilUUID;

/// Optional description label to accompany the oil of the day.
@property (nonatomic, strong) NSString * _Nullable oilDescription;

/// The image url string for the diffuser blend of the day.
@property (nonatomic, strong) NSString *blendImageURLString;

/// The blend of the day image data.
@property (nonatomic, strong) NSData * _Nullable blendImageData;

/// Optional description label to accompany the blend image.
@property (nonatomic, strong) NSString * _Nullable blendImageDescription;

/// Returns the blend image.
- (UIImage *)blendImage;

@end

NS_ASSUME_NONNULL_END
