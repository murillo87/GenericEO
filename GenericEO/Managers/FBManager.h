////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       FBManager.h
/// @author     Lynette Sesodia
/// @date       7/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

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

@interface FBManager : NSObject

+ (instancetype)sharedManager;

//- (void)scrapeFeedWithCompletion:(void(^)(NSArray *feedJSON, NSError *error))completion;

- (void)refreshPageInfoWithCompletion:(void(^)(NSArray *pageJSON, NSError *error))completion;

- (void)refreshFeedWithCompletion:(void(^)(NSArray *feedJSON, NSError *error))completion;

@end
