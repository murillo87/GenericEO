////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UIFont+Targets.h
/// @author     Lynette Sesodia
/// @date       1/4/19
//
//  Copyright © 2019 Essentl LLC. All rights reserved.
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

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Targets)

/// The default header font for the target (displayed at the top of controllers).
+ (UIFont *)headerFont;

/// The default text font for the target.
+ (UIFont *)textFont;

/// Bold version of the default text font for the target.
+ (UIFont *)boldTextFont;

/// The default title text font for the target.
+ (UIFont *)titleFont;

/// The default font for tableview cells.
+ (UIFont *)cellFont;

/// The font for the brand name displayed on the homescreen.
+ (UIFont *)brandFont;

/**
 Returns a given font with a specific size.
 @param font The UIFont to take the font-family from.
 @param size The new size of the returned font.
 */
+ (UIFont *)font:(UIFont *)font ofSize:(CGFloat)size;



@end

NS_ASSUME_NONNULL_END
