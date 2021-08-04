//
//  UpgradeCollectionViewCell.h
//  GenericEO
//
//  Created by Lynette Sesodia on 6/26/18.
//  Copyright © 2018 Lynette Sesodia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpgradeCollectionViewCell : UICollectionViewCell

/// Main content view for the cell.
@property (nonatomic, strong) IBOutlet UIView *colorView;

/// Label displaying the most popular text.
@property (nonatomic, strong) IBOutlet UILabel *mostPopularLabel;

/// Label displaying the subscription duration number value.
@property (nonatomic, strong) IBOutlet UILabel *durationLabel;

/// Label displaying the subscription weekly price value.
@property (nonatomic, strong) IBOutlet UILabel *weeklyPriceLabel;

/// Label displaying the subscription price.
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

/// Label displaying discount amount.
@property (nonatomic, strong) IBOutlet UILabel *discountLabel;

- (void)configureCellForFreeTrial;

@end
