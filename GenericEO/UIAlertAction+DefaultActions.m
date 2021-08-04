////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UIAlertAction+DefaultActions.m
/// @author     Lynette Sesodia
/// @date       2/19/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "UIAlertAction+DefaultActions.h"

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

@implementation UIAlertAction (DefaultActions)

+ (UIAlertAction *)defaultOkAction {
    return [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil)
                                    style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * _Nonnull action) {}];
}

@end
