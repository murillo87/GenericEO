
////////////////////////////////////////////////////////////////////////////////
//  Walking for Weight Loss
/// @file       IAPProducts.m
/// @author     Juan Roa
/// @date       6/18/17
//
//  Copyright © 2017 Impera, LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#include "IAPProducts.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

#if defined(ESTL) && defined(GENERIC)

IAPProduct *const IAPProductUsageGuideSubscriptionRenewingMonthly = @"com_essentl.oil_generic_usage_guide.auto_renewable.1M";
IAPProduct *const IAPProductUsageGuideSubscriptionRenewingYearly = @"com_essentl.oil_generic_usage_guide.auto_renewable.1Y";

#elif defined(ESTL) && defined (DOTERRA)

IAPProduct *const IAPProductUsageGuideSubscriptionRenewingMonthly = @"com_essentl.oil_doterra_usage_guide.auto_renewable.1M";
IAPProduct *const IAPProductUsageGuideSubscriptionRenewingYearly = @"com_essentl.oil_doterra_usage_guide.auto_renewable.1Y";

#elif defined(ESTL) && defined (YOUNGLIVING)

IAPProduct *const IAPProductUsageGuideSubscriptionRenewingMonthly = @"com_essentl.oil_youngliving_usage_guide.auto_renewable.1M";
IAPProduct *const IAPProductUsageGuideSubscriptionRenewingYearly = @"com_essentl.oil_youngliving_usage_guide.auto_renewable.1Y";

#elif defined(AB) && defined (DOTERRA)

IAPProduct *const IAPProductUsageGuideSubscriptionRenewingMonthly = @"com_aromabyte.oil_doterra_usage_guide.auto_renewable.1M";
IAPProduct *const IAPProductUsageGuideSubscriptionRenewingYearly = @"com_aromabyte.oil_doterra_usage_guide.auto_renewable.1Y";

#elif defined(AB) && defined (YOUNGLIVING)

IAPProduct *const IAPProductUsageGuideSubscriptionRenewingMonthly = @"com_aromabyte.oil_youngliving_usage_guide.auto_renewable.1M";
IAPProduct *const IAPProductUsageGuideSubscriptionRenewingYearly = @"com_aromabyte.oil_youngliving_usage_guide.auto_renewable.1Y";

#endif

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Function Prototypes
///-----------------------------------------

///-----------------------------------------
///  Function Definitions
///-----------------------------------------
