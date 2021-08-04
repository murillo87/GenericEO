//
//  TwoColumnTableViewCell.h
//  GenericEO
//
//  Created by Lynette Sesodia on 3/21/20.
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TwoColumnTableViewCell : UITableViewCell

/// Label displaying the "title" text on the left side of the cell.
@property (nonatomic, strong) IBOutlet UILabel *leftLabel;

/// Label displyaing the text on the right side of the cell.
@property (nonatomic, strong) IBOutlet UILabel *rightLabel;

@end

NS_ASSUME_NONNULL_END
