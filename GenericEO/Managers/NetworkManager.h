////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NetworkManager.h
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "Constants.h"
#import "PFOil.h"
#import "PFDoterraOil.h"
#import "PFYoungLivingOil.h"
#import "PFRecipe.h"
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

static NSString * _Nonnull const ParseClassNameOilSources = @"GEO_Sources";

#ifdef GENERIC
static NSString * _Nonnull const ParseClassNameUsageGuide = @"GEO_Guide";
#elif DOTERRA
static NSString * _Nonnull const ParseClassNameUsageGuide = @"P_ESTL_MyEO_DT_Guide_V1";
#elif YOUNGLIVING
static NSString * _Nonnull const ParseClassNameUsageGuide = @"ESTL_MyEO_YL_Guide_V1";
#endif

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

+ (instancetype)sharedManager;

#pragma mark - General Queries

/**
 Queries for PFObjects based on the given type. Completion block returns array of PFObjects or an error.
 @param type The EODataType enum for the desired PFObjects to be retrieved.
 */
- (void)queryByType:(EODataType)type withCompletion:(void(^)(NSArray<PFObject *> *objects, NSError *error))completion;

#pragma mark - Specific Type & Object Queries

/**
 Queries for the daily feed object for the current date. Completion block returns the DailyFeedObject or an error.
 @param date The formatted date string to retrieve the DailyFeed object by.
 */
- (void)getDailyFeedObjectForDate:(NSString *)date withCompletion:(void (^)(DailyFeed * _Nullable, NSError * _Nullable))completion;

/**
 Queries for feed objects with date strings matching the given dates. Completion block returns array of PFObjects or an error.
 @param dates Array of date strings for the dates to query for.
 */
- (void)queryFeedObjectsForDates:(NSArray<NSString *> *)dates withCompletion:(void (^)(NSArray<PFObject *> *, NSError *))completion;

/**
 Queries for all objects in the given class that matching the given parameters. Completion block returns array of PFObjects or an error.
 @param className The string class name of the parse class containing the objects to search for.
 @param key The string column key in the parse db to search by.
 @param values Array of string key values for the products to find.
 */
- (void)queryByClass:(NSString *)className
              forKey:(NSString *)key
          withValues:(NSArray<NSString *> *)values
      withCompletion:(void(^)(NSArray<PFObject *> *objects, NSError *error))completion;
    
/**
 Queries for all products matching the given UUIDs. Completion block returns array of PFOil objects or an error.
 @param key The string column key in the parse db to search by.
 @param values Array of string key values for the products to find.
 */
- (void)queryProductsForKey:(NSString *)key
                 withValues:(NSArray<NSString *> *)values
             withCompletion:(void(^)(NSArray<PFObject<OilModel> *> *objects, NSError *error))completion;

/**
 Queries for recipe objects with the given UUIDs. Completion block returns array of PFRecipes or an error.
 @param uuids Array of UUID strings for the recipes to find.
 */
- (void)queryRecipesWithUUIDs:(NSArray<NSString *> *)uuids withCompletion:(void(^)(NSArray<PFRecipe *> *, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
