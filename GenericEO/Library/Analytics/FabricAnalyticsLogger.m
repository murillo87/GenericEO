////////////////////////////////////////////////////////////////////////////////
//  Walking for Weight Loss
/// @file       FabricAnalyticsLogger.m
/// @author     Juan Roa
/// @date       11/13/17
//
//Copyright © 2017 Impera, LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Crashlytics/Crashlytics.h>

#import "FabricAnalyticsLogger.h"

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

@implementation FabricAnalyticsLogger

// Fabric doesn't provide hooks for reporting success/failure
- (void)reportEventWithoutOutcome:(IPAAnalyticsEvent *)event {
    [Answers logCustomEventWithName:event.name customAttributes:event.attributes];
}

@end
