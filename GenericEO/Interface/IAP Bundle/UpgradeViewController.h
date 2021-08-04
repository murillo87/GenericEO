////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UpgradeViewController.h
/// @author     Lynette Sesodia
/// @date       6/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import <Impera/StoreKit.h>
#import <Impera/AnalyticsKit.h>
#import "IAPProducts.h"
#import "MBProgressHUD.h"

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

@interface UpgradeViewController : UIViewController

#pragma mark IBOutlets

/// Label displaying title text for the view controller.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Table view displaying pricing options.
@property (nonatomic, strong) IBOutlet UITableView *pricingTableView;

/// Label displaying subscription terms.
@property (nonatomic, strong) IBOutlet UITextView *termsOfUseTextView;

/// Button used to begin the upgrade process.
@property (nonatomic, strong) IBOutlet UIButton *continueButton;

/// Button used to restore previous purchases.
@property (nonatomic, strong) IBOutlet UIButton *restoreButton;

/// Button used to cancel the upgrade process.
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;

/// Button used to display terms.
@property (nonatomic, strong) IBOutlet UIButton *termsButton;

/// Button used to display privacy policy.
@property (nonatomic, strong) IBOutlet UIButton *privacyButton;

/// Progress hud displayed
@property (nonatomic, strong) MBProgressHUD *progressHUD;

#pragma mark Instance Variables

/// IndexPath of the currently selected upgrade option cell.
@property (nonatomic, strong) NSIndexPath *selectedCellIndex;

/// The IAP product manager used by the application.
@property (nonatomic, strong) IAPServerSubscriptionManager *productManager;

#pragma mark Methods

/**
 Initializes the view controller for the current target.
 */
- (id)initForTarget;

/**
 Calculates and returns the discount percentage between two subscription period prices.
 */
- (double)determineDiscountBetweenBaseProduct:(SKProductSubscriptionPeriod *)basePeriod
                                    basePrice:(double)basePrice
                             andCurrentPeriod:(SKProductSubscriptionPeriod *)currentPeriod
                                 currentPrice:(double)currentPrice;

/**
 Returns a user facing string for the subscription period length.
 */
- (NSString *)stringForSubscriptionPeriod:(SKProductSubscriptionPeriod *)period;

- (IAPProduct *)monthlyProduct;
- (IAPProduct *)yearlyProduct;
- (SKProduct *)monthlyStoreProduct;
- (SKProduct *)yearlyStoreProduct;

@end
