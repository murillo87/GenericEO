////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       GuideViewController.m
/// @author     Lynette Sesodia
/// @date       5/5/20
//
//  Copyright © 2020 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import "ParseObjectViewControllerInitProtocol.h"

#import "PaywallView.h"
#import <Impera/StoreKit.h>
#import "IAPProducts.h"

#import "NetworkManager.h"
#import "CoreDataManager.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

static NSString * const GuideParseKeyName = @"name";
static NSString * const GuideParseKeyDescription = @"summaryDescription";
static NSString * const GuideParseKeyOils = @"oils";
static NSString * const GuideParseKeyUsage = @"usage";

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface GuideViewController : UIViewController <PaywallViewDelegate, ParseObjectViewControllerInitProtocol>

#pragma mark - Instance Variables

/// Paywall view displayed when the guide IAP has not been purchased.
@property (nonatomic, strong) PaywallView *paywallView;

/// The object for the controller
@property (nonatomic, strong) PFObject *object;

/// Dictionary of titles and text for the table view.
@property (nonatomic, strong) NSMutableDictionary *tableViewDictionary;

/// The product manager used by the application.
@property (nonatomic, strong) IAPServerSubscriptionManager *productManager;

/// IAPProducts for the guide paywall.
@property (nonatomic, strong) NSArray<IAPProduct *> *guideIAPs;

#pragma mark - IBOutlets

/// Back button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *backButton;

/// Table view displaying the controller's data
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/// Label displaying the name controller's object
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

#pragma mark - Functions

/// Action to upgrade to the complete usage guide.
- (IBAction)upgrade:(id)sender;

/// Displays the paywall if the IAP has been purchased.
- (void)displayPaywallIfNeeded;

/// Shows the paywall view.
- (void)showPaywall;

/// Hides the paywall view.
- (void)hidePaywall;

#pragma mark - IAP

- (void)productManager:(IAPProductManager *)productManager didUpdateStatusOfProduct:(IAPProduct *)product;


@end

NS_ASSUME_NONNULL_END
