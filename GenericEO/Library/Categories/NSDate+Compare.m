////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NSDate+Compare.m
/// @author     Lynette Sesodia
/// @date       8/9/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "NSDate+Compare.h"

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

@implementation NSDate (Compare)

- (BOOL)isLaterThanOrEqualTo:(NSDate *)date {
    return !([self compare:date] == NSOrderedAscending);
}

- (BOOL)isEarlierThanOrEqualTo:(NSDate *)date {
    return !([self compare:date] == NSOrderedDescending);
}
- (BOOL)isLaterThan:(NSDate *)date {
    return ([self compare:date] == NSOrderedDescending);
    
}
- (BOOL)isEarlierThan:(NSDate *)date {
    return ([self compare:date] == NSOrderedAscending);
}

+ (NSDate *)dateByAddingOneMonthToDate:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
}

+ (NSDate *)dateByAddingOneYearToDate:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:1];
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
}

@end
