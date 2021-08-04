////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       FeedManager.h
/// @author     Lynette Sesodia
/// @date       8/10/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Constants.h"
#import "DailyFeed.h"

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

@interface FeedManager : NSObject

/**
 Queries for the daily feed object for the current date. Completion block returns the DailyFeedObject.
 */
- (void)getDailyFeedObjectWithCompletion:(void (^)(DailyFeed *, NSError *))completion;

/**
 Query for feed objects.
 */
- (void)queryNewFeedObjectsWithCompletion:(void(^)(NSArray<PFObject *> *objects, NSError *error))completion;

@end
