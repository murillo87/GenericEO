////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PFDoterraOil.h
/// @author     Lynette Sesodia
/// @date       9/11/18
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

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface PFDoterraOil : PFObject <PFSubclassing, OilModel>

/// Array of the primary benefits of the oil.
@property (nonatomic, strong) NSArray<NSString *> *benefits;

/// Array of oil UUIDs that the oil blends with.
@property (nonatomic, strong) NSArray<NSString *> *blendsWith;

// Doterra product category.
@property (nonatomic, strong) NSString *category;

/// Collection method of the oil.
@property (nonatomic, strong) NSString *collectionMethod;

/// The hex string color code for the oil.
@property (nonatomic, strong) NSString *color;

/// Boolean value indicating if the oil is currently available for purchase from doTERRA.
@property (nonatomic) BOOL available;

/// Boolean value indicating if the oil is a limited edition offering.
@property (nonatomic) BOOL limitedEdition;

/// Point value in doterra's reward system.
@property (nonatomic, strong) NSString *doterraPV;

/// doTERRA part number identifier.
@property (nonatomic, strong) NSString *doterraPartNumber;

/// Retail price of the oil from doTERRA.
@property (nonatomic, strong) NSString *doterraPriceRetail;

/// Wholesale price of the oil from doTERRA.
@property (nonatomic, strong) NSString *doterraPriceWholesale;

/// Product URL on doTERRA site.
@property (nonatomic, strong) NSString *doterraURL;

/// Product size (usually in mililiters).
@property (nonatomic, strong) NSString *doterraVolume;

/// Internal image url.
@property (nonatomic, strong) NSString *image;

/// Longer description of the oil.
@property (nonatomic, strong) NSString *longDescription;

/// Extra note for the oil.
@property (nonatomic, strong) NSString *note;

/// String of other names the oil may be called.
@property (nonatomic, strong) NSString *otherNames;

/// Plant part the oil is extracted from.
@property (nonatomic, strong) NSString *plantPart;

/// List of precautions.
@property (nonatomic, strong) NSArray<NSString *> *precautionsList;

/// The source of the data.
@property (nonatomic, strong) NSString *source;

/// The doterra product subcategory.
@property (nonatomic, strong) NSString *subcategory;

/// The bottle type for the oil product.
@property (nonatomic, strong) NSString *type;

/// Diffusion uses.
@property (nonatomic, strong) NSString *useDiffusion;

/// Internal uses.
@property (nonatomic, strong) NSString *useInternal;

/// Topical uses.
@property (nonatomic, strong) NSString *useTopical;

/// Main chemical constituents of the oil.
@property (nonatomic, strong) NSString *mainConstituents;

/// Array of uses for the oil.
@property (nonatomic, strong) NSArray<NSString *> *applicationMethods;













@end
