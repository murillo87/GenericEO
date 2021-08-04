////////////////////////////////////////////////////////////////////////////////
//  Walking for Weight Loss
/// @file       Analytics.h
/// @author     Juan Roa
/// @date       11/13/17
//
//Copyright © 2017 Impera, LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Impera/AnalyticsKit.h>
#import <Crashlytics/Crashlytics.h>

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

// Defines analytics events for an in-app purchase soft impression
extern NSString *const AnalyticsSoftImpressionEvent;
extern NSString *const AnalyticsSoftImpressionDataEvent;

// Defines analytics events for an in-app purchase medium impression
extern NSString *const AnalyticsMediumImpressionEvent;
extern NSString *const AnalyticsMediumImpressionDataEvent;

// Defines analytics events for an in-app purchase hard impression
extern NSString *const AnalyticsHardImpressionEvent;
extern NSString *const AnalyticsHardImpressionDataEvent;

// Defines an analytic event for an in-app purchase attempt
extern NSString *const AnalyticsPurchaseEvent;

// Defines analytic events for oils
extern NSString *const AnalyticsViewedOil;
extern NSString *const AnalyticsAddedOilToInventory;
extern NSString *const AnalyticsViewedOilPrices;

// Defines general analytic events for actions
extern NSString *const AnalyticsAddedReview;
extern NSString *const AnalyticsAddedNote;
extern NSString *const AnalyticsFavorited;

// Defines analytic events for viewage
extern NSString *const AnalyticsViewedRecipe;
extern NSString *const AnalyticsViewedCharts;
extern NSString *const AnalyticsViewedGuide;

// Defines analytic event attributes
extern NSString *const AnalyticsNameAttribute;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

