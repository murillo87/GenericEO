////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ParseObjectViewControllerInitProtocol.h
/// @author     Lynette Sesodia
/// @date       5/5/20
//
//  Copyright © 2020 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

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

@protocol ParseObjectViewControllerInitProtocol <NSObject>

/**
 Initializes a controller with the given parse object.
 @param object The Parse guide object to create the view controller with.
 */
- (id)initWithObject:(PFObject *)object;

@end

NS_ASSUME_NONNULL_END
