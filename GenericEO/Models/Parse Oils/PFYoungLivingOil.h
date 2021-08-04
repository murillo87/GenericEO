////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PFYoungLivingOil.h
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

@interface PFYoungLivingOil : PFObject <PFSubclassing, OilModel>

/// Array of suggested application method strings for the oil.
@property (nonatomic, strong) NSArray<NSString *> *applicationMethods;

/// Boolean value indicating if the oil is currently available for purchase from doTERRA.
@property (nonatomic) BOOL available;

/// Array of the primary benefits of the oil.
@property (nonatomic, strong) NSArray<NSString *> *benefits;

/// Blend classification for the oil.
@property (nonatomic, strong) NSString *blendClassification;

/// Array of oil UUIDs that the oil blends with.
@property (nonatomic, strong) NSArray<NSString *> *blendsWith;

/// String explaining blends with oil effects.
@property (nonatomic, strong) NSString *blendsWithText;

/// The body systems affected by the oil.
@property (nonatomic, strong) NSString *bodySystemsAffected;

/// The botanical family of the oil.
@property (nonatomic, strong) NSString *botanicalFamily;

/// Carrier oils for the essential oil.
@property (nonatomic, strong) NSString *carrierOils;

/// String identifiying the category of the oil (single, blend, massage, etc).
@property (nonatomic, strong) NSString *category;

/// The chemical constituents of the oil.
@property (nonatomic, strong) NSString *chemicalConstituents;

/// Collection method of the oil.
@property (nonatomic, strong) NSString *collectionMethod;

/// The hex string color code for the oil.
@property (nonatomic, strong) NSString *color;

/// Array of companion oil UUIDs (used for blends).
@property (nonatomic, strong) NSArray<NSString *> *companionOils;

/// Description text for the companionOils;
@property (nonatomic, strong) NSString *companionOilsDescription;

/// Folklore information about the oil.
@property (nonatomic, strong) NSString *folklore;

/// The frequency of the oil in mhz.
@property (nonatomic, strong) NSString *frequency;

/// The young living product image url string.
@property (nonatomic, strong) NSString *imageURL;

/// Boolean value indicating if the oil is a limited edition offering.
@property (nonatomic) BOOL limitedEdition;

/// Additional note for the oil.
@property (nonatomic, strong) NSString *note;

/// The intensity of the oils odor.
@property (nonatomic, strong) NSNumber *odorIntensity;

/// The plant part that the oil is sourced from.
@property (nonatomic, strong) NSString *plantPart;

/// Possible uses for the oil.
@property (nonatomic, strong) NSString *possibleUses;

/// Properties of the oil.
@property (nonatomic, strong) NSString *properties;

/// The region of the world the oil is sourced from.
@property (nonatomic, strong) NSString *region;

/// Array of recipes for the oil.
@property (nonatomic, strong) NSArray<NSString *> *recipes;

/// Array of single oil UUIDs included in the blend.
@property (nonatomic, strong) NSArray<NSString *> *singleOilsIncluded;

/// Description text for the single oils included in the blend.
@property (nonatomic, strong) NSString *singleOilsIncludedDescription;

/// The source of the oil information.
@property (nonatomic, strong) NSString *source;

/// Subcategory for the oil.
@property (nonatomic, strong) NSString *subcategory;

/// The display type for the oil image (Oil, Oil-Light, Rollon, etc.)
@property (nonatomic, strong) NSString *type;

/// Directions for diffusing the oil.
@property (nonatomic, strong) NSString *useDiffusion;

/// Historical uses for the oil.
@property (nonatomic, strong) NSString *useHistorical;

/// Directions for internal oil use.
@property (nonatomic, strong) NSString *useInternal;

/// Directions for topical oil use.
@property (nonatomic, strong) NSString *useTopical;

/// Array of uses for the oil.
@property (nonatomic, strong) NSArray<NSString *> *uses;

/// Common uses for the oil.
@property (nonatomic, strong) NSString *usesCommon;

/// Other uses for the oil.
@property (nonatomic, strong) NSString *usesOther;

/// French Medicinal uses for the oil.
@property (nonatomic, strong) NSString *usesMedicinalFrench;

/// Young Living number identifier.
@property (nonatomic, strong) NSString *youngLivingItemNumber;

/// Retail price of the oil from Young Living.
@property (nonatomic, strong) NSNumber *youngLivingPriceRetail;

/// Wholesale price of the oil from Young Living.
@property (nonatomic, strong) NSNumber *youngLivingPriceWholesale;

/// Product size (usually in mililiters).
@property (nonatomic, strong) NSString *youngLivingVolume;


@end
