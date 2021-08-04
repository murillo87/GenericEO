////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       EditFieldViewController.h
/// @author     Lynette Sesodia
/// @date       8/31/20
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

typedef NS_ENUM(NSInteger, TextFieldDataType) {
    DataTypeUsername = 0,
    DataTypePassword = 1,
    DataTypeEmail    = 2
};

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface EditFieldViewController : UIViewController

/**
 Initializes the controller for a given data type.
 @param type The TextFieldDataType to configure the controller for.
 */
- (id)initForType:(TextFieldDataType)type;

/**
 Initializes the controller for a given data type.
 @param type The TextFieldDataType to configure the controller for.
 @param value The current value to display in the controller's text field.
*/
- (id)initForType:(TextFieldDataType)type withValue:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
