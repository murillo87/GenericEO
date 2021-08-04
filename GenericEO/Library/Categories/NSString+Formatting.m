////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NSString+Formatting.m
/// @author     Lynette Sesodia
/// @date       7/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "NSString+Formatting.h"

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

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation NSString (Formatting)

+ (NSString *)addSpacesBeforeCapitalLettersInString:(NSString *)str {
    NSRegularExpression *regexp = [NSRegularExpression
                                   regularExpressionWithPattern:@"([a-z])([A-Z])"
                                   options:0
                                   error:NULL];
    NSString *newString = [regexp
                           stringByReplacingMatchesInString:str
                           options:0
                           range:NSMakeRange(0, str.length)
                           withTemplate:@"$1 $2"];
    
    NSLog(@"Changed '%@' -> '%@'", str, newString);
    return newString;
}

#pragma mark - SKStoreKit Formatting

+ (NSString *)stringForSKSProductPeriodUnit:(SKProductPeriodUnit)unit {
    switch (unit) {
        case SKProductPeriodUnitDay:
            return NSLocalizedString(@"Day", nil);
            break;
            
        case SKProductPeriodUnitWeek:
            return NSLocalizedString(@"Week", nil);
            break;
            
        case SKProductPeriodUnitMonth:
            return NSLocalizedString(@"Month", nil);
            break;
            
        case SKProductPeriodUnitYear:
            return NSLocalizedString(@"Year", nil);
            break;
            
        default:
            nil;
            break;
    }
}

@end
