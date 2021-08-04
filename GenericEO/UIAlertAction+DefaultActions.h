////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UIAlertAction+DefaultActions.h
/// @author     Lynette Sesodia
/// @date       2/19/20
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

@interface UIAlertAction (DefaultActions)

/**
 Default "Ok" action that dimisses the alert controller.
 */
+ (UIAlertAction *)defaultOkAction;

@end

NS_ASSUME_NONNULL_END
