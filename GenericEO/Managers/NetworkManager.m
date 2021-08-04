////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NetworkManager.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "NetworkManager.h"
#import "ParseUserManager.h"

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
///  Static Data
///-----------------------------------------

static NSString * const FeedClass = @"P_ESTL_MyEO_DT_Feed_V1";

#ifdef YOUNGLIVING
static NSString * const ApplicationClass = @"P_ESTL_MyEO_DT_Application";
#elif DOTERRA
static NSString * const ApplicationClass = @"P_ESTL_MyEO_DT_Application";
#else
static NSString * const ApplicationClass = @"DoTerra_Application_PROD_V1";
#endif

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface NetworkManager()

/// Cached array of all oil objects to reduce server calls. Will be nil if no call to the network has been made.
@property (nonatomic, strong) NSArray *localOilCache;

/// Cached array of all recipe objects to reduce server calls. Will be nil if no call to the network has been made.
@property (nonatomic, strong) NSArray *localRecipeCache;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation NetworkManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager {
    static NetworkManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NetworkManager alloc] init];
    });
    
    return sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        
        // Initialize Parse.
        
#if defined (AB)
        [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
            configuration.applicationId = @"29052e884e77a24cd5b35844b23e40f0";
            configuration.clientKey     = @"7f7f291328ccf57f76665fe98a43e67b";
            configuration.server        = @"https://aromabyte-4357.nodechef.com/parse";
        }]];
#elif defined (ESTL)
        [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
            configuration.applicationId = @"b699e0c59dbdb9e391e85aa587a83523";
            configuration.clientKey     = @"7b9fe14f6959a42addd09834217a15a3";
            configuration.server        = @"https://oil-apps-4357.nodechef.com/parse";
        }]];

#else
        [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
            configuration.applicationId = @"VugUJ49FpE59bnUR";
            configuration.clientKey     = @"pYVqvWFKaEYaG8BN";
            configuration.server        = @"https://cloforce-apps-4357.nodechef.com/parse";
        }]];
#endif
    }
    return self;
}

#pragma mark - Public General Queries

- (void)queryByType:(EODataType)type withCompletion:(void (^)(NSArray<PFObject *> *, NSError *))completion {
    switch (type) {
        case EODataTypeSingleOil:
        case EODataTypeSearchSingle: {
            // Check oil cache, if nil call server. If not return the oil cache.
            if (self.localOilCache == nil) {
                [self querySingleOilsWithCompletion:^(NSArray<PFObject<OilModel> *> *oils, NSError *error) {
                    self.localOilCache = oils;
                    completion(oils, error);
                }];
            } else {
                completion(self.localOilCache, nil);
            }
        } break;
            
        case EODataTypeUsageGuide:
        case EODataTypeSearchGuide: {
            [self queryByClassName:ParseClassNameUsageGuide withCompletion:^(NSArray<PFObject *> *objects, NSError *error) {
                completion(objects, error);
            }];
        } break;
            
        case EODataTypeApplicationCharts: {
            [self queryByClassName:ApplicationClass withCompletion:^(NSArray<PFObject *> *objects, NSError *error) {
                completion(objects, error);
            }];
        } break;
            
        case EODataTypeRecipe:
        case EODataTypeSearchRecipe: {
            [self queryRecipesWithCompletion:^(NSArray<PFRecipe *> *recipes, NSError *error) {
                completion(recipes, error);
            }];
        } break;
            
        case EODataTypeOilSources: {
            [self queryOilSourcesWithCompletion:^(NSArray<PFObject *> *oils, NSError *error) {
                completion(oils, error);
            }];
        } break;
            
        default: {
            NSError *error = [NSError errorWithDomain:@"LocalError"
                                                 code:001
                                             userInfo:@{NSLocalizedDescriptionKey: @"Invalid EODataType enum for query."}];
            completion(nil, error);
        } break;
    }
}

#pragma mark - Public Specific Type & Object Queries

- (void)getDailyFeedObjectForDate:(NSString *)date withCompletion:(void (^)(DailyFeed * _Nullable, NSError * _Nullable))completion {
    PFQuery *query = [DailyFeed query];
    [query whereKey:@"date" equalTo:date];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (objects != nil && objects.count > 0) {
            
            /**
             Multilayer query. We recieve the UUID for the oil of day object. We need to have that object itself.
             */
            DailyFeed *df = [objects firstObject];
            
            if (df.oil != nil) {
                completion(df, error);
            } else {
                // Get UUID from daily feed and query for oil object
                [self queryProductsForKey:@"uuid" withValues:@[df.oilUUID] withCompletion:^(NSArray<PFObject<OilModel> *> *objects, NSError *error) {
                    if (objects != nil && objects.count > 0) {
                        df.oil = [objects firstObject];
                        completion(df, error);
                    } else {
                        completion(df, error);
                    }
                }];
            }
        } else {
            completion(nil, error);
        }
    }];
}

/**
 Queries for all objects in the given class that matching the given parameters. Completion block returns array of PFObjects or an error.
 @param className The string class name of the parse class containing the objects to search for.
 @param key The string column key in the parse db to search by.
 @param values Array of string key values for the products to find.
 */
- (void)queryByClass:(NSString *)className
              forKey:(NSString *)key
          withValues:(NSArray<NSString *> *)values
      withCompletion:(void(^)(NSArray<PFObject *> *objects, NSError *error))completion {
    
    NSMutableArray *queries = [[NSMutableArray alloc] init];
    
    for (NSString *value in values) {
        PFQuery *q = [PFQuery queryWithClassName:className];
        [q whereKey:key equalTo:value];
        [queries addObject:q];
    }
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:queries];
    [query orderByAscending:@"uuid"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

/**
 Queries for all products matching the given values. Completion block returns array of PFOil objects or an error.
 @param key The string column key in the parse db to search by.
 @param values Array of string key values for the products to find.
 */
- (void)queryProductsForKey:(NSString *)key withValues:(NSArray<NSString *> *)values withCompletion:(void(^)(NSArray<PFObject<OilModel> *> *objects, NSError *error))completion {
    NSMutableArray *queries = [[NSMutableArray alloc] init];
    
    if (self.localOilCache != nil) {
            
        // Create predicate for each value to look for.
        for (NSString *value in values) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", key, value];
            [queries addObject:predicate];
        }
        
        NSPredicate *orPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:queries];
        NSArray *objects = [self.localOilCache filteredArrayUsingPredicate:orPredicate];
        completion(objects, nil);
        
    } else {
    
        // Create subquery for each value to look for.
        for (NSString *value in values) {
    #ifdef GENERIC
            PFQuery *q = [PFOil query];
    #elif DOTERRA
            PFQuery *q = [PFDoterraOil query];
    #elif YOUNGLIVING
            PFQuery *q = [PFYoungLivingOil query];
    #endif
            [q whereKey:key equalTo:value];
            [queries addObject:q];
                
        }
        
        // Call server.
        PFQuery *query = [PFQuery orQueryWithSubqueries:queries];
        [query orderByAscending:@"uuid"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            completion(objects, error);
        }];
    }
}

/**
 Queries for recipe objects with the given UUIDs. Completion block returns array of PFRecipes or an error.
 @param uuids Array of UUID strings for the recipes to find.
 */
- (void)queryRecipesWithUUIDs:(NSArray<NSString *> *)uuids withCompletion:(void (^)(NSArray<PFRecipe *> *objects, NSError *))completion {
    NSMutableArray *queries = [[NSMutableArray alloc] init];
    
    for (NSString *uuid in uuids) {
        PFQuery *q = [PFRecipe query];
        [q whereKey:@"uuid" equalTo:uuid];
        [queries addObject:q];
    }
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:queries];
    [query orderByAscending:@"uuid"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

#pragma mark - Private Type Queries

/**
 Queries Parse recipes database for oil recipes. Completion block returns array of PFRecipe objects or an error.
 */
- (void)queryRecipesWithCompletion:(void(^)(NSArray<PFRecipe *> *recipes, NSError *error))completion {
    PFQuery *query = [PFRecipe query];
    query.limit = 1000;
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

/**
 Queries Parse DoTerra_Products database for products matching the given category. Completion block returns array of
 PFDoterraOil objects or an error.
 @param category String value for the category to query for.
 */
- (void)queryProductsForCategory:(NSString *)category
                  withCompletion:(void(^)(NSArray<PFOil *> *objects, NSError *error))completion {
    PFQuery *query = [PFOil query];
    query.limit = 1000;
    [query orderByAscending:@"Product_Short_Name"];
    [query whereKey:@"Category" equalTo:category];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

/**
 Queries for all usage guide objects matching the given name. Completion block returns array of PFObjects or an error.
 @param name The string value for the name key in the parse database.
 */
- (void)queryGuideObjectsWithName:(NSString *)name withCompletion:(void (^)(NSArray<PFObject *> *, NSError *))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"DoTerra_Guide_PROD_V1"];
    query.limit = 1000;
    [query whereKey:@"name" equalTo:name];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

/**
 Queries for all oil objects. Completion block returns array of PFOil objects or an error.
 */
- (void)querySingleOilsWithCompletion:(void(^)(NSArray<PFObject<OilModel> *> *oils, NSError *error))completion {
#ifdef GENERIC
    PFQuery *query = [PFOil query];
#elif DOTERRA
    PFQuery *single = [PFDoterraOil query];
    [single whereKey:@"category" equalTo:@"Singleoils"];
    
    PFQuery *blend = [PFDoterraOil query];
    [blend whereKey:@"category" equalTo:@"Proprietary-blends"];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[single, blend]];
    [query orderByAscending:@"name"];
    
#elif YOUNGLIVING
    PFQuery *query = [PFYoungLivingOil query];
#endif
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

/**
 Queries for all oil source objects. Completion block returns array of PFObjects or an error.
 */
- (void)queryOilSourcesWithCompletion:(void(^)(NSArray<PFObject *> *oils, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:ParseClassNameOilSources];
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

#pragma mark - Private General Queries

- (void)queryFeedObjectsForDates:(NSArray<NSString *> *)dates withCompletion:(void (^)(NSArray<PFObject *> *, NSError *))completion {
    NSMutableArray *queries = [[NSMutableArray alloc] init];
    
    for (NSString *dateStr in dates) {
        PFQuery *q = [PFQuery queryWithClassName:FeedClass];
        [q whereKey:@"datePosted" equalTo:dateStr];
        //[q whereKey:@"fbPageName" equalTo:@"Essential Oils Reference Guide for DoTerra"];
        [queries addObject:q];
    }
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:queries];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

- (void)queryByClassName:(NSString *)className withCompletion:(void(^)(NSArray<PFObject *> *objects, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:className];
    query.limit = 1000;
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

- (void)queryClass:(NSString *)className forObjectWithID:(NSString *)identifier withCompletion:(void(^)(PFObject *object, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:className];
    [query getObjectWithId:identifier];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion([objects firstObject], error);
    }];
}

- (void)queryClass:(NSString *)className forKey:(NSString *)key matchingIDs:(NSArray<NSString *> *)IDs withCompletion:(void(^)(NSArray<PFObject *> *objects, NSError *error))completion {
    NSMutableArray *queries = [[NSMutableArray alloc] init];
    
    for (NSString *identifier in IDs) {
        PFQuery *q = [PFQuery queryWithClassName:className];
        [q whereKey:key equalTo:identifier];
        [queries addObject:q];
    }
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:queries];
    [query orderByAscending:key];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

#pragma mark - Private Data Fetch

/**
 Fetches the suggested oils pointer objects for the given guide object.
 @param guide The PFObject from the guide table in the parse database.
 */
- (void)fetchGuide:(PFObject *)guide withCompletion:(void (^)(PFObject *, NSError *))completion {
    [guide fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            NSArray *pointers = guide[@"oils"];
            for (PFObject *oil in pointers) {
                [oil fetchIfNeeded];
            }
        }
        
        completion(object, error);
    }];
}

@end
