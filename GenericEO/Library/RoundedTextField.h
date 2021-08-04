////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       RoundedTextField.h
/// @author     Lynette Sesodia
/// @date       2/5/20
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

@interface RoundedTextField : UITextField

- (UIView *)viewWithEmbeddedImageNamed:(NSString *)image;

@end

NS_ASSUME_NONNULL_END
