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

#import "PFOil.h"

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

static NSString * const ParseClassName = @"GEO_Oils";

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation PFOil

@dynamic name;
@dynamic uuid;
@dynamic scientificName;
@dynamic scent;
@dynamic summaryDescription;
@dynamic otherNames;
@dynamic primaryBenefits;
@dynamic blendsWith;
@dynamic applicationMethods;
@dynamic medicialUses;
@dynamic precautionsText;
@dynamic precautionsList;
@dynamic buySources;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return ParseClassName;
}

@end
