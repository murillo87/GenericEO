////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PFYoungLivingOil.m
/// @author     Lynette Sesodia
/// @date       9/11/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

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
///  Static Data
///-----------------------------------------

#if defined (AB)
static NSString * const ParseClassName = @"P_AB_YL_Products_V1";
#else
static NSString * const ParseClassName = @"ESTL_MyEO_YL_Products_V1";
#endif

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation PFYoungLivingOil

@dynamic name;
@dynamic uuid;
@dynamic scientificName;
@dynamic scent;
@dynamic summaryDescription;
@dynamic precautionsText;

@dynamic applicationMethods;
@dynamic available;
@dynamic benefits;
@dynamic blendClassification;
@dynamic blendsWith;
@dynamic blendsWithText;
@dynamic bodySystemsAffected;
@dynamic botanicalFamily;
@dynamic carrierOils;
@dynamic category;
@dynamic chemicalConstituents;
@dynamic collectionMethod;
@dynamic color;
@dynamic companionOils;
@dynamic companionOilsDescription;
@dynamic folklore;
@dynamic frequency;
@dynamic imageURL;
@dynamic limitedEdition;
@dynamic note;
@dynamic odorIntensity;
@dynamic plantPart;
@dynamic possibleUses;
@dynamic properties;
@dynamic recipes;
@dynamic region;
@dynamic singleOilsIncluded;
@dynamic singleOilsIncludedDescription;
@dynamic source;
@dynamic subcategory;
@dynamic type;
@dynamic useDiffusion;
@dynamic useInternal;
@dynamic useHistorical;
@dynamic useTopical;
@dynamic uses;
@dynamic usesCommon;
@dynamic usesMedicinalFrench;
@dynamic usesOther;
@dynamic youngLivingItemNumber;
@dynamic youngLivingPriceRetail;
@dynamic youngLivingPriceWholesale;
@dynamic youngLivingVolume;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return ParseClassName;
}

@end
