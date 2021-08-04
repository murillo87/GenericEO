////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       OilViewControllerInitProtocol.h
/// @author     Lynette Sesodia
/// @date       3/11/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import "PFOil.h"
#import "PFDoterraOil.h"
#import "PFYoungLivingOil.h"

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

@protocol OilViewControllerInitProtocol <NSObject>

@required
/**
 Initializes the view controller with a generic oil object.
 @param oil The PFOil object from Parse.
 @param source The buy source PFObject from parse.
 */
- (instancetype)initWithOil:(PFOil *)oil andSources:(PFObject *)source;

/**
 Initializes the view controller with a doterra oil object.
 @param oil The PFDoterraOil object from Parse.
 */
- (instancetype)initWithDoterraOil:(PFDoterraOil *)oil;

/**
 Initializes the view controller with a young living oil object.
 @param oil The PFYoungLivingOil object from Parse.
 */
- (instancetype)initWithYoungLivingOil:(PFYoungLivingOil *)oil;

@end

NS_ASSUME_NONNULL_END
