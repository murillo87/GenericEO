////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UIColor+Palette.h
/// @author     Lynette Sesodia
/// @date       7/24/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>

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

@interface UIColor (Palette)

+ (UIColor *)targetAccentColor;

+ (UIColor *)colorForType:(NSInteger)type;

+ (UIColor *)accentRed;

+ (UIColor *)accentYellow;

+ (UIColor *)accentGreen;

+ (UIColor *)accentBlue;

+ (UIColor *)accentMagenta;

+ (UIColor *)recipeLightPurple;

+ (UIColor *)accentPurple;

/**
 Adjusts the given colors alpha levels.
 */
+ (UIColor *)colorWithColor:(UIColor *)color alpha:(CGFloat)alpha;

/**
 Returns a color from the given hex string.
 @param hexString NSString hex code for the color, may or may not contain a starting '#' sign.
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 Returns a color from the given RGB string.
 @param str RGB string with components separated by commas
 @example `220,100,30`
 */
+ (UIColor *)colorWithRGBString:(NSString *)str;

@end
