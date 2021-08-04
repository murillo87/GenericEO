////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NSString+Formatting.h
/// @author     Lynette Sesodia
/// @date       7/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

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

@interface NSString (Formatting)

/**
 Inserts spaces before capital letters in a camelCase string.
 @example 'thisIsMyString' -> 'this Is My String'
 */
+ (NSString *)addSpacesBeforeCapitalLettersInString:(NSString *)str;

#pragma mark - SKStoreKit Formatting

/**
 Returns localized user facing string for the given enum value.
 @param unit A SKProductPeriodUnit enum value.
 */
+ (NSString *)stringForSKSProductPeriodUnit:(SKProductPeriodUnit)unit;

@end
