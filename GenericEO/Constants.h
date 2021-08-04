////////////////////////////////////////////////////////////////////////////////
//  GenericEO
/// @file       Constants.h
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#ifndef Constants_h
#define Constants_h

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "NSArray+StringFormatting.h"
#import "NSDate+Compare.h"
#import "NSError+Constants.h"
#import "NSString+Formatting.h"
#import "UIAlertAction+DefaultActions.h"
#import "UIAlertController+Window.h"
#import "UIColor+Palette.h"
#import "UIFont+Targets.h"
#import "UIImageView+AFNetworking.h"


#import "Analytics.h"
#import "FabricAnalyticsLogger.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

typedef NS_ENUM(NSInteger, QuantityLeft) {
    QuantityLeftFull  = 0,
    QuantityLeftHalf  = 1,
    QuantityLeftEmpty = 2
};

typedef NS_ENUM(NSInteger, EODataType) {
    EODataTypeUsageGuide        = 100,
    EODataTypeSearchGuide       = 150,
    EODataTypeApplicationCharts = 200,
    EODataTypeSingleOil         = 300,
    EODataTypeOilSources        = 301,
    EODataTypeSearchSingle      = 350,
    EODataTypeBlendedOil        = 400,
    EODataTypeSearchBlend       = 450,
    EODataTypeRecipe            = 500,
    EODataTypeSearchRecipe      = 550
};

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

static CGFloat const iPhoneXHeight = 812; // Height of iPhone X screen
static CGFloat const iPhoneXHeaderBarDelta = 24.0; // The additional pixels added to all header bar heights on iPhone X
static CGFloat const DefaultHeaderBarHeight = 64.0; // Standard height of the header bar for
static CGFloat const SearchHeaderBarHeight = 108; // Height of the header bar when containing a search bar



static NSString *AppHasActivePremiumSubscriptionKey = @"376HasActivePremiumSubscription"; // Random ### added to obfuscate key
static NSString *UserHasCompletedOnboardingKey = @"UserHasCompletedOnboardingKey";

static NSString * _Nonnull const UserDefaultsProfileImageDictionaryKey = @"userProfilePicture";

#if defined(ESTL) && defined(GENERIC)
static NSString *kochavaGUID = @"komyeo-generic-y8yx8mk";
static NSString *OneSignalID = @"0401e2db-4ac4-4f1c-8131-d0df4b2b1751";
static NSString *ParseUserClass = @"ESTL_MyEO_G_Users";

static NSString *UUIDPrefix = @"MyEO-G";
static NSString *TOSWebsiteURL = @"http://www.myoilystuff.com/tos.html";
static NSString *PrivacyWebsiteURL = @"http://www.myoilystuff.com/privacy.html";

#elif defined(ESTL) && defined(DOTERRA)
static NSString *kochavaGUID = @"komyeo-doterra-rr004p";
static NSString *OneSignalID = @"695c8893-a38d-4b4c-8d1b-79d79ce69a0a";
static NSString *ParseUserClass = @"P_ESTL_MyEO_DT_Users";

static NSString *UUIDPrefix = @"MyEO-DT";
static NSString *TOSWebsiteURL = @"http://www.myoilystuff.com/tos.html";
static NSString *PrivacyWebsiteURL = @"http://www.myoilystuff.com/privacy.html";

#elif defined(ESTL) && defined(YOUNGLIVING)
static NSString *kochavaGUID = @"komyeo-young-living-6a6sw0";
static NSString *OneSignalID = @"81b57f6f-35b4-4f52-b08a-356d3f2f895f";
static NSString *ParseUserClass = @"ESTL_MyEO_YL_Users";

static NSString *UUIDPrefix = @"MyEO-YL";
static NSString *TOSWebsiteURL = @"http://www.myoilystuff.com/tos.html";
static NSString *PrivacyWebsiteURL = @"http://www.myoilystuff.com/privacy.html";

#elif defined(AB) && defined (DOTERRA)
static NSString *kochavaGUID = @"koaromabyte-doterra-q0mhi";
static NSString *OneSignalID = @"695c8893-a38d-4b4c-8d1b-79d79ce69a0a"; // This needs to be updated
static NSString *ParseUserClass = @"P_AB_DT_Users";

static NSString *UUIDPrefix = @"MyEO-DT";
static NSString *TOSWebsiteURL = @"http://www.aromabyte.com/terms.html";
static NSString *PrivacyWebsiteURL = @"http://www.aromabyte.com/privacy.html";

#elif defined(AB) && defined(YOUNGLIVING)
static NSString *kochavaGUID = @"koaromabyte-youngliving-wbtpv";
static NSString *OneSignalID = @"695c8893-a38d-4b4c-8d1b-79d79ce69a0a"; // This needs to be updated
static NSString *ParseUserClass = @"P_AB_YL_Users";

static NSString *UUIDPrefix = @"MyEO-YL";
static NSString *TOSWebsiteURL = @"http://www.aromabyte.com/terms.html";
static NSString *PrivacyWebsiteURL = @"http://www.aromabyte.com/privacy.html";

#endif

///-----------------------------------------
///  Object Declarations
///-----------------------------------------


#endif /* Constants_h */

NS_ASSUME_NONNULL_END
