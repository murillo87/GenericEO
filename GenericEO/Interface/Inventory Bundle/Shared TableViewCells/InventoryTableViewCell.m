////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       InventoryTableViewCell.m
/// @author     Lynette Sesodia
/// @date       8/6/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "InventoryTableViewCell.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

@interface InventoryTableViewCell()

/// Increment button for the stepper label.
@property (nonatomic, strong) IBOutlet UIButton *incrementButton;

/// Decrement button for the stepper label.
@property (nonatomic, strong) IBOutlet UIButton *decrementButton;

/// Quantity label displayed in the cell.
@property (nonatomic, strong) IBOutlet UILabel *quantityLabel;

/// Quantity value for the inventory object.
@property (nonatomic) NSInteger value;

@end

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@implementation InventoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.whiteBackgroundView.layer.cornerRadius = 10.0;
    self.whiteBackgroundView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.height/2;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStepperValue:(NSInteger)value {
    self.value = value;
    self.quantityLabel.text = [NSString stringWithFormat:@"%lu", self.value];
}

#pragma mark - IBActions

- (IBAction)quantityAdd:(id)sender {
    [self setStepperValue:self.value+1];
    [self.delegate amountDidChange:self.value forCellAtIndex:self.indexPath];
}

- (IBAction)quantitySubtract:(id)sender {
    if (self.value > 1) {
        [self setStepperValue:self.value-1];
        [self.delegate amountDidChange:self.value forCellAtIndex:self.indexPath];
    }
}

- (IBAction)addToShoppingList:(id)sender {
    [self.delegate addOilToShoppingListAtIndex:self.indexPath];
    
    [self.shoppingListAddButton setImage:[UIImage imageNamed:@"icon-check"] forState:UIControlStateNormal];
}

@end
