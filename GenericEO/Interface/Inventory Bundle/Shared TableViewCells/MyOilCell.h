////////////////////////////////////////////////////////////////////////////////
//  Generic EO 
/// @file       MyOilCell.h
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import "Constants.h"

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

@protocol MyOilCellDelegate <NSObject>

/**
 Notifies the delegate that the selected quantity left of the oil has changed.
 @param amount The newly selected quantity left.
 @param indexPath The indexPath of the cell with the value change.
 */
- (void)quantityLeftDidChange:(QuantityLeft)amount forCellAtIndex:(NSIndexPath *)indexPath;

@end

@interface MyOilCell : UITableViewCell

@property (nonatomic, weak) id<MyOilCellDelegate> delegate;

/// Tag for the table view cell.
@property (nonatomic, strong) NSIndexPath *indexPath;

/// Image view displaying icon for cell.
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

/// Width contraint for the iconImageView.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *iconImageViewWidthConstraint;

/// Bold label displaying cell's title.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Segmented control displaying quantity options for the oil.
@property (nonatomic, strong) IBOutlet UISegmentedControl *quantitySegmentedControl;

@end
