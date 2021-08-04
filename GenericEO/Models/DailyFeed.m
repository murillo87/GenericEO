////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       DailyFeed.m
/// @author     Lynette Sesodia
/// @date       5/27/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "DailyFeed.h"

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

#ifdef DOTERRA
static NSString * const ParseClassName = @"P_AB_DT_Feed_V0";
#else
static NSString * const ParseClassName = @"P_AB_YL_Feed_V0";
#endif

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation DailyFeed

@dynamic oil;
@dynamic oilUUID;
@dynamic oilDescription;
@dynamic blendImageData;
@dynamic blendImageURLString;
@dynamic blendImageDescription;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return ParseClassName;
}

- (UIImage *)blendImage {
    if (!self.blendImageData) {
        self.blendImageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.blendImageURLString]];
    }
    return [[UIImage alloc] initWithData:self.blendImageData];
}

@end
