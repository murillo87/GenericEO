////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       InventoryTableViewCell.h
/// @author     Lynette Sesodia
/// @date       8/6/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "PKYStepper.h"

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
///  Object Declarations
///-----------------------------------------

@protocol InventoryTableViewCellDelegate <NSObject>

/**
 Notifies the delegate that the selected quantity left of the oil has changed.
 @param amount The newly selected quantity left.
 @param indexPath The indexPath of the cell with the value change.
 */
- (void)amountDidChange:(double)amount forCellAtIndex:(NSIndexPath *)indexPath;

/**
 Notifies the delegate to add the current oil to the shopping list.
 */
- (void)addOilToShoppingListAtIndex:(NSIndexPath *)indexPath;

@end

@interface InventoryTableViewCell : UITableViewCell

@property (nonatomic, weak) id<InventoryTableViewCellDelegate> delegate;

/// The indexPath of the cell in its parent tableview.
@property (nonatomic, strong) NSIndexPath *indexPath;

/// The white background view containing the oil info for the cell.
@property (nonatomic, strong) IBOutlet UIView *whiteBackgroundView;

/// Icon image view for the cell.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

/// Name label displaying a user facing string for the cell.
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

/// Button used to add the oil to the shopping list.
@property (nonatomic, strong) IBOutlet UIButton *shoppingListAddButton;

- (void)setStepperValue:(NSInteger)value;

@end
