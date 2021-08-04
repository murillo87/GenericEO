////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       FeedManager.m
/// @author     Lynette Sesodia
/// @date       8/10/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "FeedManager.h"
#import "NetworkManager.h"

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
static NSString * const UserDefaultsViewedImagesKey = @"previouslyViewedFeedImages";

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@implementation FeedManager

#pragma mark - Public

- (void)getDailyFeedObjectWithCompletion:(void (^)(DailyFeed *, NSError *))completion {
    
    NSDate *today = [NSDate date];
    NSString *todayDateString = [self stringForDate:today];
    
    [[NetworkManager sharedManager] getDailyFeedObjectForDate:todayDateString withCompletion:^(DailyFeed * _Nullable feed, NSError * _Nullable error) {
        if (feed) {
            NSURL *imgURL = [NSURL URLWithString:feed.blendImageURLString];
            NSData *imgData = [[NSData alloc] initWithContentsOfURL:imgURL];
            feed.blendImageData = imgData;
        }
        
        completion(feed, error);
    }];
}

- (void)queryNewFeedObjectsWithCompletion:(void (^)(NSArray<PFObject *> *, NSError *))completion {
    
    //TEST
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = 5;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    
    NSArray<NSString *> *dates = [self getDateStringsFor:1 beforeDate:nextDate];
    
    [[NetworkManager sharedManager] queryFeedObjectsForDates:dates withCompletion:^(NSArray<PFObject *> *objects, NSError *error) {
        completion(objects, error);
    }];
}

#pragma mark - Private

#pragma mark Date Processing

- (NSArray<NSString *> *)getDateStringsFor:(NSInteger)numDays beforeDate:(NSDate *)date {
    // Prevent negative days
    if (numDays <= 0) {
        return @[];
    }
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    
    NSDate *adjDate = date;
    for (int i=0; i<numDays; i++) {
        adjDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:adjDate options:0];
        NSString *adjDateStr = [self stringForDate:adjDate];
        [dates addObject:adjDateStr];
    }
    
    return dates;
}

- (NSString *)stringForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d/yy"];
    return [formatter stringFromDate:date];
}

@end
