////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PFRecipe.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "PFRecipe.h"

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

#ifdef GENERIC
static NSString * const ParseClassName = @"GEO_Recipes";
#elif DOTERRA
static NSString * const ParseClassName = @"P_ESTL_MyEO_DT_Recipes_V1";
#elif YOUNGLIVING
static NSString * const ParseClassName = @"ESTL_MyEO_YL_Recipes_V1";
#endif

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation PFRecipe

@dynamic uuid;
@dynamic name;
@dynamic amount;
@dynamic category;
@dynamic oilsUsed;
@dynamic summaryDescription;
@dynamic ingredients;
@dynamic steps;
@dynamic usedFor;
@dynamic note;
@dynamic pictureURLString;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return ParseClassName;
}

- (NSURL *)pictureURL {
    return [NSURL URLWithString:self.pictureURLString];
}

@end
