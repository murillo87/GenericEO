////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       IAPManager.m
/// @author     Lynette Sesodia
/// @date       6/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "IAPManager.h"
#import "SimpleKeychain.h"
#import "Constants.h"

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

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface IAPManager() <SKProductsRequestDelegate, SKPaymentTransactionObserver>

/// Dictionary of IAP statuses.
@property (nonatomic, strong) NSMutableSet<IAPProduct *> *products;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation IAPManager

#pragma mark - Initialization

+ (instancetype)sharedManager {
    static IAPManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[IAPManager alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createIAPProducts];
    }
    return self;
}

- (void)refreshIAPStatuses {
    NSLog(@"IAPManager refreshIAPStatuses");
    [self createIAPProducts];
}

#pragma mark - IAPProduct Retrieval

- (IAPProduct * _Nullable)productWithIdentifier:(NSString *)uuid {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid contains %@", uuid];
    NSSet<IAPProduct *> *matchingSet = [self.products filteredSetUsingPredicate:predicate];
    return [matchingSet anyObject];
}

/**
 Saves updated product in the product set.
 @param product The update IAPProduct to save.
 */
- (void)saveUpdatedProduct:(IAPProduct *)product {
    IAPProduct *old = [self productWithIdentifier:product.uuid];
    if (old != nil) {
       [self.products removeObject:old];
    }
    
    [self.products addObject:product];
}

#pragma mark - Purchasing

- (void)restorePurchases {
    NSLog(@"IAPManager restorePurchases");
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)purchaseIAPWithIdentifier:(NSString *)uuid {
    
    // Verify that the user can make payments
    if (SKPaymentQueue.canMakePayments == YES) {
        
        IAPProduct *iap = [self productWithIdentifier:uuid];
        [self purchaseProduct:iap.storeKitProduct];

    } else {
        // TODO: Display error to user
    }
}

- (void)purchaseProduct:(SKProduct *)product {
    if (product == nil) {
        return;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"IAPManager paymentQueueRestoreCompletedTransactionFinished:");
    for (SKPaymentTransaction *transaction in queue.transactions) {
        if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            // Called when user successfully restores a purchase.
            NSLog(@"transactionState = restored");
            
            IAPProduct *product = [self productWithIdentifier:transaction.payment.productIdentifier];
            [self saveUpdatedProduct:product statusWithTransaction:transaction];
            
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    NSLog(@"IAPManager: paymentQueueUpdatedTransatctions:");
    for (SKPaymentTransaction *transaction in transactions) {
        
        IAPProduct *product = [self productWithIdentifier:transaction.payment.productIdentifier];
        
        switch (transaction.transactionState) {
                
            // Called when user is in the process of purchasing
            case SKPaymentTransactionStatePurchasing: {
                NSLog(@"IAPManager paymentQueue:updatedTransactions: transactionState = Purchasing");
            } break;
                
            // Called when the user has successfully purchased the package
            case SKPaymentTransactionStatePurchased: {
                NSLog(@"IAPManager paymentQueue:updatedTransactions: transactionState = Purchased");
                [self saveUpdatedProduct:product statusWithTransaction:transaction];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self.delegate purchaseProcessDidCompleteForIAPProduct:product withTransaction:transaction];
            } break;
                
            // Called when the transaction does not finish
            case SKPaymentTransactionStateFailed: {
                NSLog(@"IAPManager paymentQueue:updatedTransactions: transactionState = Failed");
                if (transaction.error.code == SKErrorPaymentCancelled) {
                    NSLog(@"transaction was cancelled");
                }
            
                [self saveUpdatedProduct:product statusWithTransaction:transaction];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self.delegate purchaseProcessDidCompleteForIAPProduct:product withTransaction:transaction];
            } break;
                
            // Called when the transaction is restored
            case SKPaymentTransactionStateRestored: {
                NSLog(@"IAPManager paymentQueue:updatedTransactions: transactionState = Restored");
                [self saveUpdatedProduct:product statusWithTransaction:transaction];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self.delegate purchaseProcessDidCompleteForIAPProduct:product withTransaction:transaction];
            } break;
                
            case SKPaymentTransactionStateDeferred: {
                NSLog(@"IAPManager paymentQueue:updatedTransactions: transactionState = Deferred");
            } break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"paymentQueue:restoreCompletedTransactionsFailedWithError:%@", error.localizedDescription);
}

#pragma mark - IAPProduct Creation

- (void)createIAPProducts {
    self.products = [[NSMutableSet alloc] init];
    
    NSArray *iapIDs = @[IAPGuideOneMonth, IAPGuideOneYear];
    
    for (NSString *identifier in iapIDs) {
        IAPProductStatus status = [self getSubscriptionStatusFromKeychainForProductWithIdentifier:identifier];
        [self.products addObject:[[IAPProduct alloc] initWithIdentifier:identifier
                                                                   type:IAPProductTypeAutoRenewableSubscription
                                                                 status:status]];
    }
    
    // Verify the storekit products are valid
    NSSet *ids = [NSSet setWithArray:iapIDs];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:ids];
    request.delegate = self; // SKProductsRequestDelegate will be called upon completion
    [request start];
    NSLog(@"IAPManager createIAPProducts:[request start]");
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    // Set SKProduct object for each IAPProduct
    for (SKProduct *product in response.products) {
        IAPProduct *iap = [self productWithIdentifier:product.productIdentifier];
        if (iap) {
            // Update object and save
            iap.storeKitProduct = product;
            [self saveUpdatedProduct:iap];
            NSLog(@"IAPManager productsRequest:didRecieveResponse: %@ [saveUpdatedProduct]", product.productIdentifier);
        }
    }
    
    [self restorePurchases];
}

#pragma mark - Product Status Changes

- (void)saveUpdatedProduct:(IAPProduct *)product statusWithTransaction:(SKPaymentTransaction *)transaction {
    // Verify the transaction is for the correct product before updating status
    if (![transaction.payment.productIdentifier isEqualToString:product.uuid]) {
        return;
    }
    
    NSDateComponents *dateComponents = [self dateComponentsForProductIdentifier:product.uuid];
    
    switch (transaction.transactionState) {
        case SKPaymentTransactionStatePurchased:
        case SKPaymentTransactionStateRestored: {
            switch (product.type) {
                case IAPProductTypeNonRenewingSubscription:
                case IAPProductTypeAutoRenewableSubscription: {
                    
                    // Get date of original transaction
                    NSDate *originalTransactionDate = [self originalTransactionDateFromTransaction:transaction];
                    
                    // Create expiration date
                    NSDate *expireDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                                       toDate:originalTransactionDate
                                                                                      options:0];
                    
                    // Save expiration date to keychain
                    [self saveKeychainSubscriptionExpirationDate:expireDate forProductWithIdentifier:product.uuid];
                    
                    // Update product status
                    [product updateStatus:IAPProductStatusSubscriptionActive];
                } break;
                    
                default: {
                    [product updateStatus:IAPProductStatusPurchased];
                } break;
            }
        } break;
            
        default: {
            switch (product.type) {
                case IAPProductTypeNonRenewingSubscription:
                case IAPProductTypeAutoRenewableSubscription: {
                    [product updateStatus:IAPProductStatusSubscriptionExpired];
                } break;
                    
                default: {
                    [product updateStatus:IAPProductStatusNotPurchased];
                } break;
            }
        } break;
    }
    
    // Save updated product
    [self saveUpdatedProduct:product];
}

#pragma mark - Keychain

- (IAPProductStatus)getSubscriptionStatusFromKeychainForProductWithIdentifier:(NSString *)productIdentifier {
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    
    // Get the expiration date for the iap
    NSString *expireDateStr = [keychain stringForKey:productIdentifier];
    NSDate *expireDate = [self dateFromString:expireDateStr];
    
    if (expireDate != nil) {
        
        /**
         - See if the expiration date has already passed,
         - Set subscription status accordingly
         */
        if ([expireDate isLaterThan:[NSDate date]]) {
            // Expiration date is in the future
            return IAPProductStatusSubscriptionActive;
        } else {
            // Expiration date is in the past
            return IAPProductStatusSubscriptionExpired;
        }
    }
    
    return IAPProductStatusSubscriptionExpired;
}

- (void)saveKeychainSubscriptionExpirationDate:(NSDate *)date forProductWithIdentifier:(NSString *)productIdentifier {
    if (date == nil) {
        // Do nothing.
        return;
    }
    
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    
    // Convert date to string to save
    NSString *expireDateStr = [self stringFromDate:date];
    
    // Save string to keychain
    [keychain setString:expireDateStr forKey:productIdentifier];
}

#pragma mark - Date Helpers

/**
 Returns the original transaction date for the transaction. Return nil if transaction state is not purchased or restored.
 */
- (NSDate *)originalTransactionDateFromTransaction:(SKPaymentTransaction *)transaction {
    NSDate *originalTransactionDate;
    
    if (transaction.transactionState == SKPaymentTransactionStateRestored) {
        originalTransactionDate = [[transaction originalTransaction] transactionDate];
    } else if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
        originalTransactionDate = [transaction transactionDate];
    }
    
    return originalTransactionDate;
}

/**
 Returns date components for the product identifier.
 */
- (NSDateComponents *)dateComponentsForProductIdentifier:(NSString *)productIdentifier {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    if ([productIdentifier isEqualToString:IAPGuideOneYear]) {
        // One year subscription
        [components setYear:1];
    } else if ([productIdentifier isEqualToString:IAPGuideOneMonth]) {
        // One month subscription
        [components setMonth:1];
    }
    
    return components;
}

/**
 Returns the NSDate object for a given string. Returns nil if string is invalid.
 */
- (NSDate *)dateFromString:(NSString *)str {
    if (str == nil || str.length == 0) {
        return nil;
    }
    
    NSDateFormatter *formatter = [self uniformDateFormatter];
    return [formatter dateFromString:str];
}

/**
 Returns NSString object for a given date. Returns nil if date object is invalid.
 */
- (NSString *)stringFromDate:(NSDate *)date {
    if (date == nil) {
        return nil;
    }
    
    NSDateFormatter *formatter = [self uniformDateFormatter];
    return [formatter stringFromDate:date];
}

- (NSDateFormatter *)uniformDateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return formatter;
}


@end
