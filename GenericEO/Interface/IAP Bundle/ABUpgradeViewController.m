////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABUpgradeViewController.,
/// @author     Lynette Sesodia
/// @date       5/19/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ABUpgradeViewController.h"
#import "UpgradeTableViewCell.h"
#import "ABUpgradeFeatureTableViewCell.h"
#import "Constants.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kUpgradeTableCell @"UpgradeTableViewCell"
#define kFeatureCell @"ABUpgradeFeatureTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

static NSInteger const FeaturesTableViewTag = 100;
static NSInteger const PricingTableViewTag  = 200;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ABUpgradeViewController () <UITableViewDelegate, UITableViewDataSource>

/// Table view containing features for the premium versions.
@property (nonatomic, strong) IBOutlet UITableView *featuresTableView;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ABUpgradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.font = [UIFont titleFont];
    self.titleLabel.text = NSLocalizedString(@"Unlock Premium Access", nil);
    self.titleLabel.textColor = [UIColor blackColor];
    [self configureFeaturesTableView];
    [self configurePricingTableView];
    [self configureButtons];
}

#pragma mark UI

- (void)configureFeaturesTableView {
    [self.featuresTableView registerNib:[UINib nibWithNibName:kFeatureCell bundle:nil] forCellReuseIdentifier:kFeatureCell];
    self.featuresTableView.tag = FeaturesTableViewTag;
    self.featuresTableView.delegate = self;
    self.featuresTableView.dataSource = self;
    //self.featuresTableView.estimatedRowHeight = 60.0;
    self.featuresTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)configurePricingTableView {
    [self.pricingTableView registerNib:[UINib nibWithNibName:kUpgradeTableCell bundle:nil] forCellReuseIdentifier:kUpgradeTableCell];
    self.pricingTableView.tag = PricingTableViewTag;
    self.pricingTableView.delegate = self;
    self.pricingTableView.dataSource = self;
}

- (void)configureButtons {
    self.continueButton.tintColor = [UIColor whiteColor];
    self.continueButton.backgroundColor = [UIColor targetAccentColor];
    self.continueButton.layer.cornerRadius = self.continueButton.frame.size.height/2;
    [self.continueButton setTitle:NSLocalizedString(@"Upgrade", nil) forState:UIControlStateNormal];
    [self.restoreButton setTitle:NSLocalizedString(@"Restore Purchases", nil) forState:UIControlStateNormal];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (tableView.tag) {
        case FeaturesTableViewTag: // Features TableView
            // Do nothing: table view interactions should not be handled.
            break;
            
        default: // Pricing TableView
            self.selectedCellIndex = indexPath;
            NSLog(@"selectedCellIndex = %lu", self.selectedCellIndex.item);
            break;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (tableView.tag) {
        case FeaturesTableViewTag: // Features TableView
            return 3;
            break;
            
        default: // Pricing TableView
            return 2;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (tableView.tag) {
        case FeaturesTableViewTag: // Features TableView
            return UITableViewAutomaticDimension;
            break;
            
        default:
            return 60.0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (tableView.tag) {
        case FeaturesTableViewTag: // Features TableView
            return [self tableView:tableView featureCellForIndexPath:indexPath];
            break;
            
        default: // Pricing TableView
            return [self tableView:tableView upgradeCellForIndexPath:indexPath];
            break;
    }
}

- (ABUpgradeFeatureTableViewCell *)tableView:(UITableView *)tableView featureCellForIndexPath:(NSIndexPath *)indexPath {
    ABUpgradeFeatureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeatureCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentNatural];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont textFont]};
    NSDictionary *boldAttributes = @{NSFontAttributeName:[UIFont boldTextFont]};
    
    switch (indexPath.row) {
        case 0: { // Usage guide
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Unlock access to the ", nil) attributes:attributes];
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"complete usage guide ", nil) attributes:boldAttributes]];
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"with suggested recipes for each ailment", nil) attributes:attributes]];
            cell.attributedLabel.attributedText = str;
        } break;
            
        case 1: { // Oil recipes
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Discover 100+ ", nil) attributes:attributes];
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"oil recipes ", nil) attributes:boldAttributes]];
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"covering diffusion, topical application, household uses and much more", nil) attributes:attributes]];
            cell.attributedLabel.attributedText = str;
        } break;
            
        case 2: { // New content
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Exclusive new content added ", nil) attributes:attributes];
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"daily", nil) attributes:boldAttributes]];
            cell.attributedLabel.attributedText = str;
        } break;
            
        default:
            break;
    }
    
    return cell;
}

- (UpgradeTableViewCell *)tableView:(UITableView *)tableView upgradeCellForIndexPath:(NSIndexPath *)indexPath {
    UpgradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUpgradeTableCell];
    cell.selectedBackgroundColor = [UIColor targetAccentColor];
    
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
                //NSLog(@"intro price: monthly");
                [cell configureCellForFreeTrial:YES];
                NSString *introPrice = [self.productManager localizedPriceOfStoreProduct:storeProduct.introductoryPrice];
                NSString *introDuration = [self stringForSubscriptionPeriod:storeProduct.introductoryPrice.subscriptionPeriod];
                if ([introPrice containsString:@"0.00"]) {
                    introPrice = NSLocalizedString(@"Free", nil);
                }
                
                cell.durationLabel.text = [NSString stringWithFormat:@"%@ %@ %@", introDuration.lowercaseString, introPrice.lowercaseString, NSLocalizedString(@"trial", nil)];
                cell.priceLabel.text = [NSString stringWithFormat:@"%@/%@", price, NSLocalizedString(@"month", nil)];
                
                /*cell.durationLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Try for", nil), introPrice.lowercaseString];
                
                //cell.durationLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Try for", nil), introPrice];
                cell.priceLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@/%@",
                                        introDuration.lowercaseString,
                                        introPrice.lowercaseString,
                                        NSLocalizedString(@"trial then", nil),
                                        price,
                                        NSLocalizedString(@"month", nil)];
                 */
            } else {
                cell.durationLabel.text = NSLocalizedString(@"Monthly", nil);
                cell.priceLabel.text = [NSString stringWithFormat:@"%@/%@", price, NSLocalizedString(@"month", nil)];
            }
        } break;

        case 1: { // Yearly
            cell.discountLabel.hidden = NO;
            
            // Determine if intro price
            if (storeProduct.introductoryPrice != nil) {
                //NSLog(@"intro price: monthly");
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
