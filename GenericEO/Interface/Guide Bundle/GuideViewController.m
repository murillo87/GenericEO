//
//  GuideViewController.m
//  GenericEO
//
//  Created by Lynette Sesodia on 5/5/20.
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
//

#import "GuideViewController.h"
#import "UpgradeViewController.h"
#import "ESTLGuideViewController.h"
#import "ABGuideViewController.h"

@interface GuideViewController () <IAPProductObserver> {
    @private
    BOOL _restrictUsageGuide;
}

@end

@implementation GuideViewController

- (id)initWithObject:(PFObject *)object {
#ifdef ESTL
    self = [[ESTLGuideViewController alloc] initWithObject:object];
#elif AB
    self = [[ABGuideViewController alloc] initWithObject:object];
#endif
    
    // Retrieve recipe objects for the guide object
    [[NetworkManager sharedManager] queryRecipesWithUUIDs:object[@"recipes"]
                                           withCompletion:^(NSArray<PFRecipe *> *objects, NSError *error) {
                                               [self.tableViewDictionary setValue:objects forKey:@"Recipes"];
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [self.tableView reloadData];
                                               });
    }];
        
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Register for IAP product updates
    {
        self.productManager = [IAPServerSubscriptionManager manager];
        _restrictUsageGuide = ![[NSUserDefaults standardUserDefaults] boolForKey:AppHasActivePremiumSubscriptionKey];
        [self.productManager addProductObserver:self];
    }
    
    IPAAnalyticsEvent *event = [IPAAnalyticsEvent eventWithName:AnalyticsViewedGuide];
    [event setValue:[NSString stringWithFormat:@"%@", self.object[@"name"]]
       forAttribute:AnalyticsNameAttribute];
    [[IPAAnalyticsManager sharedInstance] reportEvent:event];
}


- (void)upgrade:(id)sender {
    
}

#pragma mark - IAP

- (void)displayPaywallIfNeeded {
    if (_restrictUsageGuide) {
        [self showPaywall];
    } else {
        [self hidePaywall];
    }
}

- (void)showPaywall {
    if (self.paywallView == nil) {
        self.paywallView = [[PaywallView alloc] initForTarget];
        self.paywallView.delegate = self;
        [self.view addSubview:self.paywallView];
        
        self.paywallView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.paywallView.widthAnchor constraintEqualToAnchor:self.tableView.widthAnchor].active = YES;
        [self.paywallView.heightAnchor constraintEqualToAnchor:self.tableView.heightAnchor].active = YES;
        [self.paywallView.centerXAnchor constraintEqualToAnchor:self.tableView.centerXAnchor].active = YES;
        [self.paywallView.centerYAnchor constraintEqualToAnchor:self.tableView.centerYAnchor].active = YES;
    }
}

- (void)hidePaywall {
    [UIView animateWithDuration:0.1 animations:^{
        self.paywallView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.paywallView removeFromSuperview];
        self.paywallView = nil;
    }];
}

#pragma mark - PaywallViewDelegate

- (void)iapUpgradeSelectedFromPaywallView:(UIView *)view {
    if (_restrictUsageGuide) {
        UpgradeViewController *upgradeViewController = [[UpgradeViewController alloc] initForTarget];
        upgradeViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        upgradeViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:upgradeViewController animated:YES completion:nil];
    }
}

#pragma mark - IAPProductObserver

- (void)productManager:(IAPProductManager *)productManager didUpdateStatusOfProduct:(IAPProduct *)product {
    
    IAPProduct *monthlyProduct = IAPProductUsageGuideSubscriptionRenewingMonthly;
    IAPProduct *yearlyProduct = IAPProductUsageGuideSubscriptionRenewingYearly;
    
    // Only look out for the Walking for Weight Loss Training Plan products
    if(IAPProductEqualToProduct(product, monthlyProduct) || IAPProductEqualToProduct(product, yearlyProduct)) {
        
        IAPProductStatus status = [productManager productStatusOfProduct:product];
        
        switch (status) {
            case IAPProductStatusActive:
                // Unlock product features
                _restrictUsageGuide = NO;
            case IAPProductStatusPurchased:
                // Unlock product features
                _restrictUsageGuide = NO;
                break;
                
            case IAPProductStatusExpired:
            case IAPProductStatusNotPurchased:
                // Restrict product features
                _restrictUsageGuide = YES;
                break;
                
            default:
                break;
        }
        
        // Update bool with status and display paywall
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setBool:!self->_restrictUsageGuide forKey:AppHasActivePremiumSubscriptionKey];
            [self displayPaywallIfNeeded];
        });
    }
}

@end
