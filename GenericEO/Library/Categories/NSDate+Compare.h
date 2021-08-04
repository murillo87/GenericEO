////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NSDate+Compare.h
/// @author     Lynette Sesodia
/// @date       8/9/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
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

@interface NSDate (Compare)

/**
 Compares current date with another date to determine if the current date is later than/equal to the other date.
 @param date The NSDate object to compare the current date object to.
 @returns Boolean indicating if the given date is after or the same as the current date.
 */
- (BOOL)isLaterThanOrEqualTo:(NSDate *)date;

/**
 Compares current date with another date to determine if the current date is earlier than/equal to the other date.
 @param date The NSDate object to compare the current date object to.
 @returns Boolean indicating if the given date is before or the same as the current date.
 */
- (BOOL)isEarlierThanOrEqualTo:(NSDate *)date;

/**
 Compares current date with another date to determine if the current date is later than the other date.
 @param date The NSDate object to compare the current date object to.
 @returns Boolean indicating if the given date is after the current date.
 */
- (BOOL)isLaterThan:(NSDate *)date;

/**
 Compares current date with another date to determine if the current date is earlier than the other date.
 @param date The NSDate object to compare the current date object to.
 @returns Boolean indicating if the given date is before the current date.
 */
- (BOOL)isEarlierThan:(NSDate *)date;

+ (NSDate *)dateByAddingOneMonthToDate:(NSDate *)date;
+ (NSDate *)dateByAddingOneYearToDate:(NSDate *)date;

@end
