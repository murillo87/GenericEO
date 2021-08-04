//
//  ABSmallIconTableViewCell.h
//  GenericEO
//
//  Created by Lynette Sesodia on 5/18/20.
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABSmallIconTableViewCell : UITableViewCell

/// Label displaying the title for the cell.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Imageview displaying icon for the cell.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

@end

NS_ASSUME_NONNULL_END
