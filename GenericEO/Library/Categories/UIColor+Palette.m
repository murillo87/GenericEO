////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UIColor+Palette.m
/// @author     Lynette Sesodia
/// @date       7/24/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "UIColor+Palette.h"
#import "Constants.h"

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

@implementation UIColor (Palette)

+ (UIColor *)targetAccentColor {

#if defined(AB) && defined(DOTERRA)
    return [UIColor accentPurple];

#elif defined (ESTL) && defined(DOTERRA)
    return [UIColor accentPurple];
    
#elif defined (AB) && defined(YOUNGLIVING)
    return [UIColor accentGreen];
    
#elif defined (ESTL) && defined(YOUNGLIVING)
    return [UIColor accentGreen];
    
#else
    return [UIColor accentBlue];
    
#endif
    
}

+ (UIColor *)colorForType:(NSInteger)type {
    
#ifdef GENERIC
    switch (type) {
        case EODataTypeSingleOil:
        case EODataTypeSearchSingle:
            return [UIColor accentBlue];
            break;
            
        case EODataTypeBlendedOil:
        case EODataTypeSearchBlend:
            return [UIColor accentBlue];
            break;
          
        case EODataTypeApplicationCharts:
            return [UIColor accentRed];
            break;
            
        case EODataTypeUsageGuide:
        case EODataTypeSearchGuide:
            return [UIColor accentGreen];
            break;
            
        case EODataTypeRecipe:
        case EODataTypeSearchRecipe:
            return [UIColor accentYellow];
            break;
            
        default:
            return [UIColor whiteColor];
            break;
    }
#elif defined(ESTL) && defined(DOTERRA)
    return [UIColor accentPurple];
    
#elif defined(AB) && defined(DOTERRA)
    return [UIColor accentPurple];
    
#elif YOUNGLIVING
    return [UIColor accentGreen];
    
    
#endif
}

+ (UIColor *)accentRed {
    return [UIColor colorWithRed:219/255. green:64/255. blue:59/255. alpha:1.0];
}

+ (UIColor *)accentYellow {
    return [UIColor colorWithRed:241/255. green:197/255. blue:85/255. alpha:1.0];
}

+ (UIColor *)accentGreen {
    return [UIColor colorWithRed:113/255. green:221/255. blue:191/255. alpha:1.0];
}

+ (UIColor *)accentBlue {
    return [UIColor colorWithRed:70/255. green:151/255. blue:242/255. alpha:1.0];
}

+ (UIColor *)accentMagenta {
    return [UIColor colorWithRed:136/255. green:47/255. blue:141/255. alpha:1.0];
}

+ (UIColor *)recipeLightPurple {
    return [UIColor colorWithRed:166/255. green:132/255. blue:204/255. alpha:1.0];
}

+ (UIColor *)accentPurple {
    return [UIColor colorWithRed:142/255. green:68/255. blue:173/255. alpha:1.0];
    ///Users/lynettesesodia/Downloads/shutterstock_153963224/rendered.tiff[UIColor colorWithRed:128/255.0 green:0/255.0 blue:127/255.0 alpha:1.0];
}



+ (UIColor *)colorWithColor:(UIColor *)color alpha:(CGFloat)alpha {
    CGFloat red = 0.0, green = 0.0, blue = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [self colorWithHexString:hexString withAlpha:1.0];
}

+ (UIColor *)colorWithRGBString:(NSString *)str {
    // Return clear color for invalid strings
    if (str == nil || str.length == 0) {
        NSLog(@"UIColor+Palette:colorWithRGBString: invalid RGB color string");
        return [UIColor clearColor];
    }
    
    // Split string into components
    NSArray *components = [str componentsSeparatedByString:@","];
    
    // Return clear color if there is invalid number of components
    if (components.count != 3 && components.count != 4) {
        NSLog(@"UIColor+Palette:colorWithRGBString: invalid number of RGB color components in string");
        return [UIColor clearColor];
    }
    
    double r = [components[0] doubleValue]/255.;
    double g = [components[1] doubleValue]/255.;
    double b = [components[2] doubleValue]/255.;
    double a = (components.count == 4) ? [components[3] doubleValue] : 1.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

#pragma mark - Private

+ (UIColor *)colorWithHexString:(NSString *)hexString withAlpha:(CGFloat)alpha {
    
    // Declare color and rgb union values
    UIColor *color = nil;
    union {
        uint32_t value;
        struct {
            uint8_t b;  // LSB
            uint8_t g;
            uint8_t r;
            uint8_t :8; // MSB (unused)
        };
    } rgb;
    
    // Use scanner to parse the rgb hex string
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Proceed if a valid hex string was found
    if([scanner scanHexInt:&rgb.value]) {
        
        // Create color from scanned rgb values
        color = [UIColor colorWithRed:(rgb.r/255.)
                                green:(rgb.g/255.)
                                 blue:(rgb.b/255.)
                                alpha:alpha];
    }
    
    return color;
}


@end
