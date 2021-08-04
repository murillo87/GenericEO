////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       IAPProduct.h
/// @author     Lynette Sesodia
/// @date       6/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
@import StoreKit;

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

/// Enum defining IAP product subscription types.
typedef NS_ENUM(NSInteger, IAPProductType) {
    IAPProductTypeConsumable = 0,               /// Defines a consumable product type.
    IAPProductTypeNonConsumable,                /// Defines a non-consumable product type.
    IAPProductTypeAutoRenewableSubscription,    /// Defines an auto-renewable subscription product type.
    IAPProductTypeNonRenewingSubscription,      /// Defines a non-renewing subscription product type.
    IAPProductTypeUnknown                       /// Defines an unkonwn product type (typically indicative of an error).
};

/// Enum defining IAP status types.
typedef NS_ENUM(NSInteger, IAPProductStatus) {
    IAPProductStatusPurchased = 0,          /// Defines a consumable or non-consumable that has been purchased (at least once for a consumable).
    IAPProductStatusNotPurchased,           /// Defines a consumable or non-consumable that has not been purchased.
    IAPProductStatusSubscriptionActive,     /// Defines a subscription that is active.
    IAPProductStatusSubscriptionExpired     /// Defines a subscription that has expired.
};

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface IAPProduct : NSObject

/// The unique string identifier for the IAP.
@property (nonatomic, strong, readonly) NSString *uuid;

/// The IAP product type (consumable, subscription, etc.)
@property (nonatomic, readonly) IAPProductType type;

/// The current status of the IAP.
@property (nonatomic, readonly) IAPProductStatus status;

/// The SKProduct data for the IAP.
@property (nonatomic, strong) SKProduct *storeKitProduct;

/**
 Initializes a IAPProduct with the given uuid, type and status.
 @param uuid The unique string identifier for the IAPProduct.
 @param type The IAPProductType enum identifying the type of IAP for the product.
 @param status The IAPProductStatus enum for the current status of the IAP.
 */
- (id)initWithIdentifier:(NSString *)uuid type:(IAPProductType)type status:(IAPProductStatus)status NS_DESIGNATED_INITIALIZER;

/**
 Updates the product status with the given status.
 */
- (void)updateStatus:(IAPProductStatus)status;

@end

NS_ASSUME_NONNULL_END
