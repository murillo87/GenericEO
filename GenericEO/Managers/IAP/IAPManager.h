////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       IAPManager.h
/// @author     Lynette Sesodia
/// @date       6/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import "IAPProduct.h"

@import StoreKit;

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

/// Enum defining IAP transaction result types.
typedef NS_ENUM(NSInteger, IAPTransactionStatus) {
    IAPTransactionStatusPending = 0,        /// Defines a purchase transaction that is in queue or is deferred pending further action.
    IAPTransactionStatusPurchased,          /// Defines a purchase transaction that completed successfully.
    IAPTransactionStatusConsumed,           /// Defines a consume transaction that completed successfully.
    IAPTransactionStatusRestored,           /// Defines a restore transaction that completed successfully.
    IAPTransactionStatusFailure             /// Defines a transaction that failed.
};

///-----------------------------------------
///  Global Data
///-----------------------------------------

static NSString * const IAPGuideOneMonth = @"com_essentl_eo_generic_iap_sub_renew_guide_1mo";
static NSString * const IAPGuideOneYear = @"com_essentl_eo_generic_iap_sub_renew_guide_1yr";

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface IAPTransactionResult : NSObject

/// The IAPProduct corresponding to the transaction result.
@property (nonatomic, strong, readonly) IAPProduct *product;

/// The IAPTransactionStatus describing the transaction outcome.
@property (nonatomic, assign, readonly) IAPTransactionStatus status;

/// The NSError describing the transaction error (if any).
@property (nonatomic, strong, readonly, nullable) NSError *error;

@end


@protocol IAPManagerDelegate <NSObject>

/**
 Informs the delegate that the purchase process has completed.
 @param product The IAP Product that completed processing.
 @param transaction The SKPaymentTransaction that just completed.
 */
- (void)purchaseProcessDidCompleteForIAPProduct:(IAPProduct *)product withTransaction:(SKPaymentTransaction *)transaction;

@end

@interface IAPManager : NSObject

@property (nonatomic, weak) id<IAPManagerDelegate> delegate;

+ (instancetype)sharedManager;

/**
 Refreshes the current statuses for all IAPs. Should be called when the app is reopened from the background.
 */
- (void)refreshIAPStatuses;

/**
 Retrieves the IAPProduct for a given identifier.
 @param uuid The unique string identifier for the IAPProduct.
 @returns The IAPProduct object or nil if invalid uuid.
 */
- (IAPProduct * _Nullable)productWithIdentifier:(NSString *)uuid;

/**
 Restores purchases previously made by the user.
 */
- (void)restorePurchases;

/**
 Begins the purchase process for the given IAP.
 @param uuid The string identifier for the IAP product.
 */
- (void)purchaseIAPWithIdentifier:(NSString *)uuid;

@end

NS_ASSUME_NONNULL_END
