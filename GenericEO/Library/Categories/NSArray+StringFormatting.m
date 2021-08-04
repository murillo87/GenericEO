////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NSArray+StringFormatting.h.m
/// @author     Lynette Sesodia
/// @date       7/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "NSArray+StringFormatting.h"

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

@implementation NSArray (StringFormatting)

+ (NSArray<NSString *> *)arrayByCapitalizingStringsInArray:(NSArray<NSString *> *)array {
    NSMutableArray *capitalized = [[NSMutableArray alloc] init];
    for (NSString *str in array) {
        [capitalized addObject:str.capitalizedString];
    }
    return capitalized;
}

@end
