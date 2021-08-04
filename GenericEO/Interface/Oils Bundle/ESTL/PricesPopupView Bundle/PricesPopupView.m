////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PricesPopupView.m
/// @author     Lynette Sesodia
/// @date       8/7/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "PricesPopupView.h"
#import "PriceTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Constants.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kPriceCell @"PriceTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface PricesPopupView() <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/// Close button for the view.
@property (nonatomic, strong) IBOutlet UIButton *closeButton;

/// Title label for the view.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Main view containing elements of the view.
@property (nonatomic, strong) IBOutlet UIView *mainView;

/// Tableview displaying price lists.
@property (nonatomic, strong) IBOutlet UITableView *tableView;

#pragma mark - Instance Variables

@property (nonatomic, strong) PFObject *pricingSources;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation PricesPopupView

- (id)initWithFrame:(CGRect)frame andPricingSources:(PFObject *)sources {
    self = [super initWithFrame:frame];
    if (self) {
        _pricingSources = sources;
        
        //Get nib from file
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"PricesPopupView" owner:self options:nil] firstObject];
        [self addSubview:view];
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
        [self layoutIfNeeded];
        
        // Configure the view
        self.mainView.layer.cornerRadius = 22.0;
        self.mainView.layer.masksToBounds = YES;
        self.titleLabel.text = sources[@"name"];
        
        // Configure the tableview
        [self.tableView registerNib:[UINib nibWithNibName:kPriceCell bundle:nil] forCellReuseIdentifier:kPriceCell];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    return self;
}

#pragma mark - IBActions

- (IBAction)close:(id)sender {
    [self.delegate shouldClosePricesPopupView:self];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Do nothing for now.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *brands = self.pricingSources[@"brands"];
    NSLog(@"brands.count = %lu", brands.count);
    return brands.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *brands = self.pricingSources[@"brands"];
    NSString *brandKey = brands[indexPath.row];
    
    // Get keys for data displayed in cell
    NSString *imageKey = [NSString stringWithFormat:@"bottle-%@", brandKey];
    NSString *volumeKey = [NSString stringWithFormat:@"%@Volume", brandKey];
    NSString *retailPriceKey = [NSString stringWithFormat:@"%@PriceRetail", brandKey];
    NSString *wholesalePriceKey = [NSString stringWithFormat:@"%@PriceWholesale", brandKey];
    
    // Color magic
    NSString *colorKey = [NSString stringWithFormat:@"%@Color", brandKey];
    UIColor *color = [UIColor colorWithRGBString:self.pricingSources[colorKey]];
    
    // Number conversions
    double retailPrice = [self.pricingSources[retailPriceKey] doubleValue];
    double wholesalePrice = [self.pricingSources[wholesalePriceKey] doubleValue];
    
    // Create cell and display
    PriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPriceCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.brandNameLabel.text = brandKey.capitalizedString;
    cell.brandLogoImageView.backgroundColor = color;
    cell.brandLogoImageView.image = [UIImage imageNamed:imageKey];
    cell.volumeLabel.text = [NSString stringWithFormat:@"%@ mL", self.pricingSources[volumeKey]];
    cell.retailPriceLabel.text = [NSString stringWithFormat:@"Retail: $%.2f", retailPrice];
    cell.wholesalePriceLabel.text = [NSString stringWithFormat:@"Wholesale: $%.2f", wholesalePrice];
    
    return cell;
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pencil"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableAttributedString *str;
//    NSString *first = NSLocalizedString(@"Empty Inventory", nil).uppercaseString;
//    NSString *last = NSLocalizedString(@"Add a product to your Inventory to see it here.", nil);
//
//    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
//
//    // Create attributed string
//    NSString *temp = [NSString stringWithFormat:@"%@\n%@", first, last];
//    str = [[NSMutableAttributedString alloc] initWithString:temp attributes:attributes];
//
//    // Add string-specific attributes
//    NSRange r1 = NSMakeRange(0, first.length);
//    NSRange r2 = NSMakeRange(first.length, str.length-first.length);
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:17.0] range:r1];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0] range:r2];
//
    return str;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -60.0;
}

#pragma mark - DZNEmptySetDelegate

/**
 Determines if empty data set should allow user interactions.
 */
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return NO;
}

@end
