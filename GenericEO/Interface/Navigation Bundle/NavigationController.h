////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NavigationController.h
/// @author     Lynette Sesodia
/// @date       6/18/18
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

@interface NavigationController : UINavigationController

/**
 Removes visible background for UINavigationBar.
 */
- (void)clearBarBackground;

/**
 Resets bar visuals to default.
 */
- (void)normalBarBackground;

/**
 Changes the bar tint color to the given color.
 @param color The new bar tint UIColor.
 */
- (void)changeBarTintColor:(UIColor *)color;

@end
