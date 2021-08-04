////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UpgradeViewController.m
/// @author     Lynette Sesodia
/// @date       6/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "UpgradeViewController.h"
#import "ABUpgradeViewController.h"
#import "ESTLUpgradeViewController.h"

#import "UpgradeCollectionViewCell.h"


#import "Constants.h"

#import "WebViewController.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kUpgradeTableCell @"UpgradeTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface UpgradeViewController () <UITableViewDelegate, UITableViewDataSource> {
@private
    IAPProduct *_monthlyProduct;
    SKProduct *_monthlyStoreProduct;
    IAPProduct *_yearlyProduct;
    SKProduct *_yearlyStoreProduct;
    NSArray<IAPProduct *> *_products;
    NSMutableSet<SKProduct *> *_storeProducts;
}



@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation UpgradeViewController

- (id)initForTarget {
#ifdef AB
    self = [[ABUpgradeViewController alloc] init];
#else
    self = [[ESTLUpgradeViewController alloc] init];
#endif
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the product manager
    self.productManager = [IAPServerSubscriptionManager manager];
    
    // Setup products
    [self displayHUD];
    [self setupProductsForSaleWithCompletion:^{
        [self.progressHUD hideAnimated:YES];
        
        // Configure collection view
        [self.pricingTableView reloadData];
    }];
    
    // Setup notifications to complete purchase track event outcome
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    // Configure terms and conditions text
    [self configureTermsOfServiceTextView];

    // Setup notifications to complete purchase track event outcome
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //TODO: Analytics
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self preselectTableViewCell];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Product Setup

- (void)setupProductsForSaleWithCompletion:(void(^)(void))completion {
    
    _monthlyProduct = IAPProductUsageGuideSubscriptionRenewingMonthly;
    _yearlyProduct = IAPProductUsageGuideSubscriptionRenewingYearly;
    
    NSArray *allProducts = @[IAPProductUsageGuideSubscriptionRenewingMonthly, IAPProductUsageGuideSubscriptionRenewingYearly];
    
    _storeProducts = [[NSMutableSet alloc] init];
    
    dispatch_group_t storeGroup = dispatch_group_create();
    
    // Fetch store product from identifier
    for (IAPProduct *product in allProducts) {
        dispatch_group_enter(storeGroup);
        
        [[self.productManager storeProductForProduct:product] continueWithExecutor:[BFExecutor mainThreadExecutor]
         withSuccessBlock:^id _Nullable(BFTask<SKProduct *> * _Nonnull t) {
             SKProduct *storeProduct = t.result;
             if (storeProduct) {
                 if ([storeProduct.productIdentifier containsString:@".1M"]) {
                     _monthlyStoreProduct = storeProduct;
                 } else if ([storeProduct.productIdentifier containsString:@".1Y"]) {
                     _yearlyStoreProduct = storeProduct;
                 }
             }
             dispatch_group_leave(storeGroup);
             return nil;
         }];
    }
    
    dispatch_group_notify(storeGroup, dispatch_get_main_queue(), ^{
        completion();
        
        [self preselectTableViewCell];
    });
}

#pragma mark - Notifications

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    //TODO: Report tracked purchase event
}

#pragma mark Shared UI

- (void)displayHUD {
    // Display HUD
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    [self.progressHUD showAnimated:YES];
}

- (void)preselectTableViewCell {
    NSIndexPath *idx = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.pricingTableView selectRowAtIndexPath:idx animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.pricingTableView didSelectRowAtIndexPath:idx];
}

- (void)configureTermsOfServiceTextView {
    NSString *title = NSLocalizedString(@"Recurring billing, cancel anytime.\n", nil);
#ifdef AB
    NSString *details = NSLocalizedString(@"If you choose to purchase a subscription, payment will be charged to your iTunes account and your account will be charged within 24-hours prior to the end of the current period. Auto-renewal may be turned off at any time by going to your settings in the iTunes store after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable. For more information or to view our privacy policy, please visit www.aromabyte.com", nil);
    
#else
    NSString *details = NSLocalizedString(@"If you choose to purchase a subscription, payment will be charged to your iTunes account and your account will be charged within 24-hours prior to the end of the current period. Auto-renewal may be turned off at any time by going to your settings in the iTunes store after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable. For more information or to view our privacy policy, please visit www.myoilystuff.com", nil);
#endif
    NSMutableParagraphStyle *centerParagraph = [[NSMutableParagraphStyle alloc] init];
    [centerParagraph setAlignment:NSTextAlignmentCenter];
    
    NSMutableParagraphStyle *justfiedParagraph = [[NSMutableParagraphStyle alloc] init];
    [justfiedParagraph setAlignment:NSTextAlignmentJustified];
    
    NSDictionary *titleDict = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:10.0],
                                NSParagraphStyleAttributeName: centerParagraph};
    NSDictionary *detailsDict = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:10],
                                  NSParagraphStyleAttributeName: justfiedParagraph};
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title attributes:titleDict];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:details attributes:detailsDict]];
    [self.termsOfUseTextView setAttributedText:string];
    [self.termsOfUseTextView setTextColor:[UIColor blackColor]];
}

#pragma mark Actions

- (IBAction)viewTerms:(id)sender {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.websiteURL = TOSWebsiteURL;
    [vc setTitleText:NSLocalizedString(@"Terms", nil)];
    [self presentViewController:vc animated:YES completion:^{}];
}

- (IBAction)viewPrivacy:(id)sender {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.websiteURL = PrivacyWebsiteURL;
    [vc setTitleText:NSLocalizedString(@"Privacy Policy", nil)];
    [self presentViewController:vc animated:YES completion:^{}];
}

- (IBAction)cancel:(id)sender {
    
    // Report tracked purchase event
    {
        IPAAnalyticsManager *analyticsManager = [IPAAnalyticsManager sharedInstance];
        IPAAnalyticsEvent *event = [analyticsManager trackedEventWithName:AnalyticsPurchaseEvent];
        if(event) {
            [event setValue:AnalyticsEventAttributeOutcomeCancelled forAttribute:AnalyticsEventAttributeOutcome];
            [analyticsManager stopTrackingAndReportEvent:event];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        //TODO: Report analytics
    }];
}

- (IBAction)purchase:(id)sender {
    // Report hard impression analytics events
    {
        IPAAnalyticsManager *analyticsManager = [IPAAnalyticsManager sharedInstance];

        // Report impression
        IPAAnalyticsEvent *event = [IPAAnalyticsEvent eventWithName:AnalyticsHardImpressionEvent];
        [analyticsManager reportEvent:event];

        // Report tracked impression data
        IPAAnalyticsEvent *dataEvent = [analyticsManager trackedEventWithName:AnalyticsHardImpressionDataEvent];
        if(dataEvent) {
            [analyticsManager stopTrackingAndReportEvent:dataEvent];
        }
    }

    // Display HUD
    [self displayHUD];
    
    // Determine selected product
    IAPProduct *product = (self.selectedCellIndex.item == 1) ? _yearlyProduct : _monthlyProduct;
    
    // Dispatch product purchase operation
    [[self.productManager purchaseProduct:product]
     continueWithExecutor:[BFExecutor mainThreadExecutor]
     withBlock:^id _Nullable(BFTask<IAPTransactionResult *> * _Nonnull t) {
         
         // Hide activity progress
         [self.progressHUD hideAnimated:YES];
         
         UIAlertController *alertController = nil;
         
         if(t.result) {
             switch (t.result.status) {
                 case IAPTransactionStatusPurchased: {
                     alertController = [UIAlertController
                                        alertControllerWithTitle:NSLocalizedString(@"Thank You for Upgrading!", nil)
                                        message:NSLocalizedString(@"You now have access to the complete usage guide & recipes.", nil)
                                        preferredStyle:UIAlertControllerStyleAlert];
                     [alertController addAction:[UIAlertAction
                                                 actionWithTitle:NSLocalizedString(@"Got It!", nil)
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                                 }]];
                 }
                     break;
                     
                 case IAPTransactionStatusFailure: {
                     NSString *errorString = NSLocalizedString(@"Please try your purchase again.", nil);
                     if(t.result.error.localizedDescription) {
                         errorString = [NSString stringWithFormat:@"%@\n\n%@", errorString, t.result.error.localizedDescription];
                     }
                     alertController = [UIAlertController
                                        alertControllerWithTitle:NSLocalizedString(@"Unable to Complete Purchase", nil)
                                        message:errorString
                                        preferredStyle:UIAlertControllerStyleAlert];
                     [alertController addAction:[UIAlertAction
                                                 actionWithTitle:NSLocalizedString(@"Continue", nil)
                                                 style:UIAlertActionStyleDefault
                                                 handler:nil]];
                 }
                     break;
                     
                 default:
                     break;
             }
         } else if(t.error) {
             NSString *errorString = NSLocalizedString(@"Please try your purchase again.", nil);
             if(t.error.localizedDescription) {
                 errorString = [NSString stringWithFormat:@"%@\n\n%@", errorString, t.error.localizedDescription];
             }
             alertController = [UIAlertController
                                alertControllerWithTitle:NSLocalizedString(@"Unable to Complete Purchase", nil)
                                message:errorString
                                preferredStyle:UIAlertControllerStyleAlert];
             [alertController addAction:[UIAlertAction
                                         actionWithTitle:NSLocalizedString(@"Continue", nil)
                                         style:UIAlertActionStyleDefault
                                         handler:nil]];
         }
         
         if(alertController) {
             [self presentViewController:alertController animated:YES completion:nil];
         }
         
         // Report purchase analytics events
         {
             BOOL success = (t.error == nil && t.result.status == IAPTransactionStatusPurchased);

             // Report tracked purchase event
             IPAAnalyticsManager *analyticsManager = [IPAAnalyticsManager sharedInstance];
             IPAAnalyticsEvent *event = [analyticsManager trackedEventWithName:AnalyticsPurchaseEvent];
             if(event) {
                 NSString *outcome = AnalyticsEventAttributeOutcomeFailure;
                 if(success) {
                     outcome = AnalyticsEventAttributeOutcomeSuccess;
                 }
                 [event setValue:outcome forAttribute:AnalyticsEventAttributeOutcome];
                 [analyticsManager stopTrackingAndReportEvent:event];
             }
             
             // Report Answers-specific purchase event
             SKProduct *storeProduct = ([product containsString:@".1M"]) ? self->_monthlyStoreProduct : self->_yearlyStoreProduct;
             
             NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
             formatter.locale = storeProduct.priceLocale;
             NSString *currencyCode = formatter.currencyCode;
             [Answers logPurchaseWithPrice:storeProduct.price
                                  currency:currencyCode
                                   success:@(success)
                                  itemName:storeProduct.localizedTitle
                                  itemType:nil
                                    itemId:product
                          customAttributes:nil];
         }
         
         return nil;
     }];
}

- (IBAction)restorePurchases:(id)sender {
    // Display HUD
    [self displayHUD];
    
    [[self.productManager restorePurchases]
     continueWithExecutor:[BFExecutor mainThreadExecutor]
     withBlock:^id _Nullable(BFTask<NSArray<IAPTransactionResult *> *> * _Nonnull t) {
         
         // Hide activity progress
         [self.progressHUD hideAnimated:YES];
         
         UIAlertController *alertController = nil;
         
         if(t.result) {
             switch (t.result.lastObject.status) {
                 case IAPTransactionStatusPurchased:
                 case IAPTransactionStatusRestored:{
                     NSString *statusStr = nil;
                     IAPProductStatus status = [self.productManager productStatusOfProduct:t.result.lastObject.product];
                     if(status == IAPProductStatusActive || status == IAPProductStatusPurchased) {
                         statusStr = NSLocalizedString(@"You now have access to the complete usage guide & recipes.", nil);
                     } else if(status == IAPProductStatusExpired || status == IAPProductStatusNotPurchased) {
                         statusStr = NSLocalizedString(@"Your subscription for the complete usage guide & recipes is not active. Please make a purchase to unlock this content.", nil);
                     }
                     alertController = [UIAlertController
                                        alertControllerWithTitle:NSLocalizedString(@"Previous Purchases Restored", nil)
                                        message:statusStr
                                        preferredStyle:UIAlertControllerStyleAlert];
                     [alertController addAction:[UIAlertAction
                                                 actionWithTitle:NSLocalizedString(@"Got It!", nil)
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     if(status == IAPProductStatusActive || status == IAPProductStatusPurchased) {
                                                         [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                                     }
                                                 }]];
                 }
                     break;
                     
                 case IAPTransactionStatusFailure: {
                     NSString *errorString = NSLocalizedString(@"Please try again.", nil);
                     if(t.result.lastObject.error.localizedDescription) {
                         errorString = [NSString stringWithFormat:@"%@\n\n%@", errorString, t.result.lastObject.error.localizedDescription];
                     }
                     alertController = [UIAlertController
                                        alertControllerWithTitle:NSLocalizedString(@"Unable to Restore Purchases", nil)
                                        message:errorString
                                        preferredStyle:UIAlertControllerStyleAlert];
                     [alertController addAction:[UIAlertAction
                                                 actionWithTitle:NSLocalizedString(@"Continue", nil)
                                                 style:UIAlertActionStyleDefault
                                                 handler:nil]];
                 }
                     break;
                     
                 default:
                     break;
             }
         } else if(t.error) {
             NSString *errorString = NSLocalizedString(@"Please try again.", nil);
             if(t.error.localizedDescription) {
                 errorString = [NSString stringWithFormat:@"%@\n\n%@", errorString, t.error.localizedDescription];
             }
             alertController = [UIAlertController
                                alertControllerWithTitle:NSLocalizedString(@"Unable to Restore Purchases", nil)
                                message:errorString
                                preferredStyle:UIAlertControllerStyleAlert];
             [alertController addAction:[UIAlertAction
                                         actionWithTitle:NSLocalizedString(@"Continue", nil)
                                         style:UIAlertActionStyleDefault
                                         handler:nil]];
         }
         
         if(alertController) {
             [self presentViewController:alertController animated:YES completion:nil];
         }
         
         return nil;
     }];
}

#pragma mark IAPManagerDelegate

- (void)purchaseProcessDidCompleteForIAPProduct:(IAPProduct *)product withTransaction:(nonnull SKPaymentTransaction *)transaction {
    // After purchase completes do this...
    
    // Create alert to display info based on transaction state
    UIAlertController *alertController = nil;
    
    if (transaction) {
        switch (transaction.transactionState) {
            case IAPTransactionStatusPurchased: {
                [self.progressHUD hideAnimated:YES];
                alertController = [UIAlertController
                                   alertControllerWithTitle:NSLocalizedString(@"Thank You for Upgrading!", nil)
                                   message:NSLocalizedString(@"You now have access to the complete usage guide with recipes!", nil)
                                   preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction
                                            actionWithTitle:NSLocalizedString(@"Got It!", nil)
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                            }]];
            }
                break;
                
            case IAPTransactionStatusFailure: {
                [self.progressHUD hideAnimated:YES];
                NSString *errorString = NSLocalizedString(@"Please try your purchase again.", nil);
                if(transaction.error.localizedDescription) {
                    errorString = [NSString stringWithFormat:@"%@\n\n%@", errorString, transaction.error.localizedDescription];
                }
                alertController = [UIAlertController
                                   alertControllerWithTitle:NSLocalizedString(@"Unable to Complete Purchase", nil)
                                   message:errorString
                                   preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction
                                            actionWithTitle:NSLocalizedString(@"Continue", nil)
                                            style:UIAlertActionStyleDefault
                                            handler:nil]];
            }
                break;
                
            default:
                
                break;
        }
    } else if (transaction.error) {
        NSString *errorString = NSLocalizedString(@"Please try your purchase again.", nil);
        if(transaction.error.localizedDescription) {
            errorString = [NSString stringWithFormat:@"%@\n\n%@", errorString, transaction.error.localizedDescription];
        }
        alertController = [UIAlertController
                           alertControllerWithTitle:NSLocalizedString(@"Unable to Complete Purchase", nil)
                           message:errorString
                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Continue", nil)
                                    style:UIAlertActionStyleDefault
                                    handler:nil]];
    }
    
    if (alertController) {
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    //TODO: Report purchase analytics events
}


#pragma mark Convenience Methods

- (double)determineDiscountBetweenBaseProduct:(SKProductSubscriptionPeriod *)basePeriod
                                   basePrice:(double)basePrice
                            andCurrentPeriod:(SKProductSubscriptionPeriod *)currentPeriod
                                currentPrice:(double)currentPrice {
    
    int baseDays = [self daysInPeriod:basePeriod];
    int currentDays = [self daysInPeriod:currentPeriod];
    
    double basePricePerDay = basePrice / baseDays;
    double currentPricePerDay = currentPrice / currentDays;
    
    return 1. - (currentPricePerDay / basePricePerDay);
}

- (int)daysInPeriod:(SKProductSubscriptionPeriod *)period {
    switch (period.unit) {
        case SKProductPeriodUnitDay:
            return 1;
            break;
            
        case SKProductPeriodUnitWeek:
            return 7;
            break;
            
        case SKProductPeriodUnitMonth:
            return 30;
            break;
            
        case SKProductPeriodUnitYear:
            return 365;
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)stringForSubscriptionPeriod:(SKProductSubscriptionPeriod *)period {
    switch (period.unit) {
        case SKProductPeriodUnitDay:
            return [NSString stringWithFormat:@"%lu %@", period.numberOfUnits, NSLocalizedString(@"Day", nil)];
            break;
            
        case SKProductPeriodUnitWeek:
            return [NSString stringWithFormat:@"%lu %@", period.numberOfUnits, NSLocalizedString(@"Week", nil)];
            break;
            
        case SKProductPeriodUnitMonth:
            return [NSString stringWithFormat:@"%lu %@", period.numberOfUnits, NSLocalizedString(@"Month", nil)];
            break;
            
        case SKProductPeriodUnitYear:
            return [NSString stringWithFormat:@"%lu %@", period.numberOfUnits, NSLocalizedString(@"Year", nil)];
            break;
            
        default:
            break;
    }
}

- (IAPProduct *)monthlyProduct {
    return _monthlyProduct;
}

- (IAPProduct *)yearlyProduct {
    return _yearlyProduct;
}

- (SKProduct *)monthlyStoreProduct {
    return _monthlyStoreProduct;
}

- (SKProduct *)yearlyStoreProduct {
    return _yearlyStoreProduct;
}

@end
