////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PFOil.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "PFDoterraOil.h"

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

static NSString * const ParseClassName = @"P_ESTL_MyEO_DT_Oils_V1";

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation PFDoterraOil

@dynamic name;
@dynamic uuid;
@dynamic scientificName;
@dynamic scent;
@dynamic summaryDescription;
@dynamic precautionsText;

@dynamic applicationMethods;
@dynamic blendsWith;
@dynamic benefits;
@dynamic category;
@dynamic collectionMethod;
@dynamic color;
@dynamic available;
@dynamic limitedEdition;
@dynamic doterraPV;
@dynamic doterraPartNumber;
@dynamic doterraPriceRetail;
@dynamic doterraPriceWholesale;
@dynamic doterraURL;
@dynamic doterraVolume;
@dynamic image;
@dynamic longDescription;
@dynamic note;
@dynamic otherNames;
@dynamic plantPart;
@dynamic precautionsList;
@dynamic source;
@dynamic subcategory;
@dynamic useDiffusion;
@dynamic useInternal;
@dynamic useTopical;
@dynamic mainConstituents;

@dynamic type;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return ParseClassName;
}

@end
