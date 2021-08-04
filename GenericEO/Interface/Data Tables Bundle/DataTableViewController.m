////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       DataTableViewController.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "DataTableViewController.h"
#import "ABDataTableViewController.h"
#import "ESTLDataTableViewController.h"

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

@interface DataTableViewController () <PaywallViewDelegate, IAPProductObserver> {
    @private
    BOOL _restrictUsageGuide;
}

/// Paywall view displayed when the IAP has not been purchased.
@property (nonatomic, strong) PaywallView *paywallView;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation DataTableViewController

#pragma mark - Lifecycle

- (id)initWithType:(EODataType)type {
#ifdef AB
    self = [[ABDataTableViewController alloc] init];
#else
    self = [[ESTLDataTableViewController alloc] init];
#endif
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Register for IAP product updates
    {
        self.productManager = [IAPServerSubscriptionManager manager];
        _restrictUsageGuide = ![[NSUserDefaults standardUserDefaults] boolForKey:AppHasActivePremiumSubscriptionKey];
        [self.productManager addProductObserver:self];
    }
    
    // Retrieve data for view
    self.objectsDict = [[NSMutableDictionary alloc] init];
    [self queryParse];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self displayPaywallIfNeeded];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UITextField *txtSearchField;
    if (@available(iOS 13, *)) {
        txtSearchField = self.searchBar.searchTextField;
    } else {
        txtSearchField = [self.searchBar valueForKey:@"_searchField"];
    }
    txtSearchField.frame = CGRectMake(8, 10, self.searchBar.frame.size.width-16, 44);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Configure search bar text field after autolayout
    
    UITextField *txtSearchField;
    if (@available(iOS 13, *)) {
        txtSearchField = self.searchBar.searchTextField;
    } else {
        txtSearchField = [self.searchBar valueForKey:@"_searchField"];
    }
    
    txtSearchField.frame = CGRectMake(8, 10, self.searchBar.frame.size.width-16, 44);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)displayPaywallIfNeeded {
    if (self.type == EODataTypeRecipe || self.type == EODataTypeSearchRecipe) {
        if (_restrictUsageGuide) {
            [self showPaywall];
        } else {
            [self hidePaywall];
        }
    } else {
        [self hidePaywall];
    }
}

#pragma mark - Data

- (void)queryParse {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [[NetworkManager sharedManager] queryByType:self.type withCompletion:^(NSArray<PFObject *> *objects, NSError *error) {
        
        if (!error) {
            self.allObjects = objects;
            NSString *key = @"name";
            self.objectsDict = [self alphabeticallySortedDictionaryFromArray:objects withKey:key];
            
#ifdef GENERIC
            if (self.type == EODataTypeSingleOil || self.type == EODataTypeSearchSingle) {
                // Query matching source info from parse
                [[NetworkManager sharedManager] queryByType:EODataTypeOilSources withCompletion:^(NSArray<PFObject *> *objects, NSError *error) {
                    [hud hideAnimated:YES];
                    if (!error) {
                        self.oilSourceObjects = objects;
                    }
                    [self.tableView reloadData];
                }];
            } else {
                [hud hideAnimated:YES];
                [self.tableView reloadData];
            }
#else
            [hud hideAnimated:YES];
            [self.tableView reloadData];
#endif
        }
    }];
}

/**
 Sorts array into a dictionary with keys of the first character in the name.
 @param array Alphabetically sorted array of PFObjects
 @param key String key used to sort the objects by. This key should never have a nil value in any PFObject.
 */
- (NSMutableDictionary *)alphabeticallySortedDictionaryFromArray:(NSArray<PFObject *> *)array withKey:(NSString *)key {
    // Create dictionary
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    for (PFObject *object in array) {
        // Get the starting character of the object
        NSString *c = [[object valueForKey:key] substringToIndex:1].uppercaseString;
        
        // See if an array already exists for the character, if not create one
        NSMutableArray *charArray;
        if ([dict.allKeys containsObject:c]) {
            charArray = [[dict valueForKey:c] mutableCopy];
        } else {
            charArray = [[NSMutableArray alloc] init];
        }
        
        // Add object to array
        [charArray addObject:object];
        
        // Save array to dict
        [dict setObject:charArray forKey:c];
    }
    
    return dict;
}

/**
 Converts a string to a user facing camel string.
 @example "THIS IS A STRING" -> "This Is A String"
 */
- (NSString *)camelCaseStringFromString:(NSString *)string {
    return string.capitalizedString;
}

#pragma mark - IBActions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IAP

- (void)showPaywall {
    // Display paywall
    if (self.paywallView == nil) {
        self.paywallView = [[PaywallView alloc] initForTarget];
        self.paywallView.delegate = self;
        [self.view addSubview:self.paywallView];
        
        self.paywallView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.paywallView.widthAnchor constraintEqualToAnchor:self.tableView.widthAnchor].active = YES;
        [self.paywallView.heightAnchor constraintEqualToAnchor:self.tableView.heightAnchor].active = YES;
        [self.paywallView.centerXAnchor constraintEqualToAnchor:self.tableView.centerXAnchor].active = YES;
        [self.paywallView.centerYAnchor constraintEqualToAnchor:self.tableView.centerYAnchor].active = YES;
        self.paywallView.layer.cornerRadius = 22.0;
        self.paywallView.layer.masksToBounds = YES;
        
        //[self.paywallView animate];
    } else {
        [self.paywallView animate];
    }
    
    // Prevent user interction with search bar
    self.searchBar.userInteractionEnabled = NO;
}

- (void)hidePaywall {
    // Allow search bar interaction
    self.searchBar.userInteractionEnabled = YES;
    
    // Animate paywall view visibility
    [UIView animateWithDuration:0.1 animations:^{
        self.paywallView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.paywallView removeFromSuperview];
        self.paywallView = nil;
    }];
}

#pragma mark - PaywallViewDelegate

- (void)iapUpgradeSelectedFromPaywallView:(UIView *)view {
    if(_restrictUsageGuide) {
        UpgradeViewController *upgradeViewController = [[UpgradeViewController alloc] initForTarget];
        upgradeViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        upgradeViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:upgradeViewController animated:YES completion:nil];
    }
}

#pragma mark - IAPProductObserver

- (void)productManager:(IAPProductManager *)productManager didUpdateStatusOfProduct:(IAPProduct *)product {
    
    IAPProduct *monthyProduct = IAPProductUsageGuideSubscriptionRenewingMonthly;
    IAPProduct *yearlyProduct = IAPProductUsageGuideSubscriptionRenewingYearly;
    
    // Only look out for the Walking for Weight Loss Training Plan product
    if(IAPProductEqualToProduct(product, monthyProduct) || (IAPProductEqualToProduct(product, yearlyProduct))) {
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

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.isActiveSearch = YES;
    [self.tableView reloadData];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isActiveSearch = NO;
    } else {
        self.isActiveSearch = YES;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
        self.searchObjects = [self.allObjects filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isActiveSearch = NO;
}

@end
