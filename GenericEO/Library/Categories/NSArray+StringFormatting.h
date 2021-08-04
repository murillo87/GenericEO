////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NSArray+StringFormatting.h
/// @author     Lynette Sesodia
/// @date       7/26/18
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

@interface NSArray (StringFormatting)

/**
 Capitalizes all strings in a given array.
 */
+ (NSArray<NSString *> *)arrayByCapitalizingStringsInArray:(NSArray<NSString *> *)array;

@end
