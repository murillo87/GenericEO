////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ESTLUpgradeViewController.m
/// @author     Lynette Sesodia
/// @date       5/19/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ESTLUpgradeViewController.h"
#import "UpgradeTableViewCell.h"
#import "Constants.h"

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

@interface ESTLUpgradeViewController () <UITableViewDataSource, UITableViewDelegate>

/// Background image view for the upgrade controller.
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

/// Rounded corners view with solid background.
@property (nonatomic, strong) IBOutlet UIView *mainView;

/// Top half view with accent color background.
@property (nonatomic, strong) IBOutlet UIView *topHalfView;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ESTLUpgradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure main view appearance
    self.mainView.layer.cornerRadius = 22.0;
    self.mainView.layer.masksToBounds = NO;
    self.topHalfView.layer.cornerRadius = 22.0;
    self.topHalfView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.topHalfView.backgroundColor = [UIColor accentGreen];
    
    [self configurePricingTableView];
    [self configureButtons];
}

- (void)configurePricingTableView {
    [self.pricingTableView registerNib:[UINib nibWithNibName:kUpgradeTableCell bundle:nil] forCellReuseIdentifier:kUpgradeTableCell];
    self.pricingTableView.delegate = self;
    self.pricingTableView.dataSource = self;
    [self.pricingTableView reloadData];
}

- (void)configureButtons {
    self.continueButton.tintColor = [UIColor whiteColor];
    self.continueButton.backgroundColor = [UIColor accentBlue];
    self.continueButton.layer.cornerRadius = self.continueButton.frame.size.height/2;
    [self.continueButton setTitle:NSLocalizedString(@"Upgrade", nil) forState:UIControlStateNormal];
    [self.restoreButton setTitle:NSLocalizedString(@"Restore Purchases", nil) forState:UIControlStateNormal];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCellIndex = indexPath;
    NSLog(@"selectedCellIndex = %lu", self.selectedCellIndex.item);
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UpgradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUpgradeTableCell];
    
    IAPProduct *product = (indexPath.row == 1) ? [self yearlyProduct] : [self monthlyProduct];
    SKProduct *storeProduct = (indexPath.row == 1) ? [self yearlyStoreProduct] : [self monthlyStoreProduct];
    
    // Get product information
    NSString *price = [self.productManager localizedPriceOfStoreProduct:storeProduct];
    NSString *subscription = IAPProductGetSubscriptionDuration(product);
    
    [cell configureCellForFreeTrial:NO];
    switch (indexPath.row) {
        case 0: { // Monthly
            cell.discountLabel.hidden = YES;
            
            // Determine if intro price
            if (storeProduct.introductoryPrice != nil) {
                NSLog(@"intro price: monthly");
                [cell configureCellForFreeTrial:YES];
                NSString *introPrice = [self.productManager localizedPriceOfStoreProduct:storeProduct.introductoryPrice];
                NSString *introDuration = [self stringForSubscriptionPeriod:storeProduct.introductoryPrice.subscriptionPeriod];
                if ([introPrice containsString:@"0.00"]) {
                    introPrice = NSLocalizedString(@"Free", nil);
                }
                
                cell.durationLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Try for", nil), introPrice];
                cell.priceLabel.text = [NSString stringWithFormat:@"%@ %@ %@/%@",
                                        introDuration,
                                        NSLocalizedString(@"Trial then", nil),
                                        price,
                                        NSLocalizedString(@"month", nil)];
            } else {
                cell.durationLabel.text = NSLocalizedString(@"Monthly", nil);
                cell.priceLabel.text = [NSString stringWithFormat:@"%@/%@", price, NSLocalizedString(@"month", nil)];
            }
        } break;

        case 1: { // Yearly
            cell.discountLabel.hidden = NO;
            
            // Determine if intro price
            if (storeProduct.introductoryPrice != nil) {
                NSLog(@"intro price: monthly");
                [cell configureCellForFreeTrial:YES];
                NSString *introPrice = [self.productManager localizedPriceOfStoreProduct:storeProduct.introductoryPrice];
                NSString *introDuration = [self stringForSubscriptionPeriod:storeProduct.introductoryPrice.subscriptionPeriod];
                if ([introPrice containsString:@"0.00"]) {
                    introPrice = NSLocalizedString(@"Free", nil);
                }
                
                cell.durationLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Try for", nil), introPrice];
                cell.priceLabel.text = [NSString stringWithFormat:@"%@ %@ %@/%@",
                                        introDuration,
                                        NSLocalizedString(@"Trial then", nil),
                                        price,
                                        NSLocalizedString(@"year", nil)];
            } else {
                cell.durationLabel.text = NSLocalizedString(@"Yearly", nil);
                cell.priceLabel.text = [NSString stringWithFormat:@"%@/%@", price, NSLocalizedString(@"year", nil)];
            }
            
            // Calculate discount
            double discount = [self determineDiscountBetweenBaseProduct:[self monthlyStoreProduct].subscriptionPeriod
                                                              basePrice:[self monthlyStoreProduct].price.doubleValue
                                                       andCurrentPeriod:storeProduct.subscriptionPeriod
                                                           currentPrice:storeProduct.price.doubleValue];
            cell.discountLabel.text = [NSString stringWithFormat:@"%@ %.f%%", NSLocalizedString(@"SAVE", nil), discount*100];
        } break;


        default:
            break;
    }
    
    return cell;
}


@end
