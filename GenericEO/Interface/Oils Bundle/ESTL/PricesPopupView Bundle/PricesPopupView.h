////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PricesPopupView.h
/// @author     Lynette Sesodia
/// @date       8/7/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "NetworkManager.h"

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

NS_ASSUME_NONNULL_BEGIN

@protocol PricesPopupViewDelegate <NSObject>

/**
 Informs the delegate that the prices popupview should close.
 */
- (void)shouldClosePricesPopupView:(UIView *)view;

@end

@interface PricesPopupView : UIView

@property (nonatomic, weak) id<PricesPopupViewDelegate> delegate;

/**
 Initializes the view with the given frame and price sources.
 @param frame The frame for the view (should be the entire screen).
 @param sources The oil source object from parse with the relevant pricing information.
 */
- (id)initWithFrame:(CGRect)frame andPricingSources:(PFObject *)sources NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
