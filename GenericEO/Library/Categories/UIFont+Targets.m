////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UIFont+Targets.m
/// @author     Lynette Sesodia
/// @date       1/4/19
//
//  Copyright © 2019 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "UIFont+Targets.h"

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

@implementation UIFont (Targets)

+ (UIFont *)headerFont {
    
#ifdef GENERIC
    return [UIFont fontWithName:@"bromello" size:35.0];
#elif ESTL
    return [UIFont fontWithName:@"coolvetica" size:35.0];
#elif AB
    return [UIFont fontWithName:@"Lato-Bold" size:30.0];
#else
    return [UIFont systemFontOfSize:35.0];
#endif
}

+ (UIFont *)textFont {
    
#ifdef ESTL
    return [UIFont systemFontOfSize:15.0];
#elif AB
    return [UIFont fontWithName:@"OpenSans-Light" size:15.0];
#else
    return [UIFont systemFontOfSize:15.0];
#endif
}

+ (UIFont *)boldTextFont {
    
#ifdef ESTL
    return [UIFont systemFontOfSize:15.0];
#elif AB
    return [UIFont fontWithName:@"OpenSans-Regular" size:15.0];
#else
    return [UIFont systemFontOfSize:15.0];
#endif
}


+ (UIFont *)titleFont {
        
#ifdef ESTL
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:19.0];
#elif AB
    return [UIFont fontWithName:@"Lato-Regular" size:19.0];
#else
    return [UIFont systemFontOfSize:19.0];
#endif
}

+ (UIFont *)cellFont {
    
#ifdef ESTL
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
#elif AB
    return [UIFont fontWithName:@"Lato-Light" size:17.0];
#else
    return [UIFont systemFontOfSize:17.0];
#endif
}

+ (UIFont *)brandFont {
#ifdef AB
    return [UIFont fontWithName:@"Pacifico-Regular" size:30.0];
#else
    return [UIFont headerFont];
#endif
    
}

+ (UIFont *)font:(UIFont *)font ofSize:(CGFloat)size {
    return [UIFont fontWithName:font.familyName size:size];
}

@end
