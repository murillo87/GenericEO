////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UpgradeTableViewCell.m
/// @author     Lynette Sesodia
/// @date       9/5/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "UpgradeTableViewCell.h"

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

@interface UpgradeTableViewCell()

/// Main rounded view for the cell.
@property (nonatomic, strong) IBOutlet UIView *mainView;

/// Height constraint for the duration label;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *durationLabelHeightConstraint;

/// Height constraint for the discount label.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *discountLabelHeightConstraint;

/// Accent yellow color.
@property (nonatomic, strong) UIColor *accentYellow;

/// Accent blue color.
@property (nonatomic, strong) UIColor *accentBlue;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation UpgradeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Default accent colors
    self.accentYellow = [UIColor colorWithRed:241/255. green:197/255. blue:85/255. alpha:1.0];
    self.accentBlue = [UIColor colorWithRed:70/255. green:151/255. blue:242/255. alpha:1.0];
    
    // Set selection colors / style
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectedBackgroundColor = self.accentYellow;
    
    // Round background corners
    self.mainView.layer.cornerRadius = 12.0;
    self.mainView.layer.masksToBounds = YES;
    
    // Configure discount label
    self.discountLabel.backgroundColor = self.accentBlue;
    self.discountLabel.layer.cornerRadius = 5.0;
    self.discountLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (selected) {
        self.mainView.layer.borderColor = self.selectedBackgroundColor.CGColor;
        self.mainView.layer.borderWidth = 2.0;
        self.mainView.backgroundColor = [self.selectedBackgroundColor colorWithAlphaComponent:0.25];
        self.checkMarkIcon.image = [UIImage imageNamed:@"icon-checked-blue"];
    } else {
        self.mainView.layer.borderWidth = 0.0;
        self.mainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.checkMarkIcon.image = [UIImage imageNamed:@"icon-unchecked-gray"];
    }
}

- (void)configureCellForFreeTrial:(BOOL)trial {
    if (trial) {
        self.durationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
        self.priceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        self.priceLabel.text = NSLocalizedString(@"Try For Free", nil);
        self.durationLabelHeightConstraint.constant = 20.0;
    } else {
        self.durationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
        self.priceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        self.durationLabelHeightConstraint.constant = 20.0;
    }
}


@end
