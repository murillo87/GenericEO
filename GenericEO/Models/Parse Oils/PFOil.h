////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PFOil.h
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Parse/Parse.h>
#import "PFObject.h"
#import "OilModel.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

static NSString * const BrandKeyDoterra = @"doterra";
static NSString * const BrandKeyYoungLiving = @"youngliving";

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface PFOil : PFObject <PFSubclassing, OilModel>

/// String of other names the oil may be called.
@property (nonatomic, strong) NSString *otherNames;

/// Array of strings for each way to use the oil.
@property (nonatomic, strong) NSArray<NSString *> *applicationMethods;

/// Array of oil objects UUID strings for the oil blends with.
@property (nonatomic, strong) NSArray<NSString *> *blendsWith;

/// Array of string precautions for the oil.
@property (nonatomic, strong) NSArray<NSString *> *precautionsList;

/// Array of strings for each medicinal ailment the oil can be used for.
@property (nonatomic, strong) NSArray<NSString *> *medicialUses;

/**
 Array of companies dictionaries that sell the oil and more info:
 
 @note A sample dictionary.
    @{
        @"companyName" : @"doTERRA"
        @"salePriceUSD" : @"19.99"
        @"buyURL" : @"www.doterra.com/xxx"
    }
 */
@property (nonatomic, strong) NSArray<NSDictionary *> *buySources;

/// The user facing primary benefits of the oil.
@property (nonatomic, strong) NSString *primaryBenefits;

+ (NSString *)parseClassName;

@end
