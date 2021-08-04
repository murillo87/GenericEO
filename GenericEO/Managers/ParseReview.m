////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ParseReview.m
/// @author     Lynette Sesodia
/// @date       1/13/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ParseReview.h"

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
static NSString * const ParseClassName = @"";
#elif DOTERRA
static NSString * const ParseClassName = @"P_AB_DT_Reviews";
#elif YOUNGLIVING
static NSString * const ParseClassName = @"P_AB_YL_Reviews";
#endif

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ParseReview

@dynamic uuid;
@dynamic text;
@dynamic parentID;
@dynamic authorID;
@dynamic authorUsername;
@dynamic upCount;
@dynamic downCount;
@dynamic starValue;
@dynamic flagCount;

+ (void)load {
    [self registerSubclass];
}

+ (nonnull NSString *)parseClassName {
    return ParseClassName;
}

@end
