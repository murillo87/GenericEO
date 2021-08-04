////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UIAlertController+Window.h
/// @author     Lynette Sesodia
/// @date       8/19/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
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

@interface UIAlertController (Window)

// Animates the displays of the alert in a new window.
- (void)show;

// Displays the alert in a new window with animation option.
- (void)show:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
