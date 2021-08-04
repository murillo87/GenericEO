////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       FilterOptionsView.h
/// @author     Lynette Sesodia
/// @date       6/18/18
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

typedef NS_ENUM(NSInteger, VisualState) {
    VisualStateExpanded     = 10,
    VisualStateInTransition = 20,
    VisualStateCollapsed    = 30
};

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@protocol FilterOptionsViewDelegate;

@interface FilterOptionsView : UIView

@property (nonatomic, weak) id<FilterOptionsViewDelegate> delegate;

/// Label displaying title for the view.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Button to animate expansion or collapse of the view.
@property (nonatomic, strong) IBOutlet UIButton *expandCollapseBtn;

/// The current state of the view.
@property (nonatomic) VisualState state;

/**
 Initializes the view with the options for a given type.
 @param type The EODataType displayed in the parent view controller for which the options will be shown.
 */
- (instancetype)initWithOptionsForType:(EODataType)type;

/**
 Called to inform the view that it will be expanded.
 @param animated Boolean value indicating if the expansion should be animated.
 */
//- (void)expandView:(BOOL)animated;

/**
 Called to inform the view that it will be collapsed.
 @param animated Boolean value indicating if the collapse should be animated.
 */
//- (void)collapseView:(BOOL)animated;

@end

@protocol FilterOptionsViewDelegate <NSObject>

/**
 Informs the delegate to adjust the filter options view height.
 @param view The FilterOptionsView to adjust.
 @param height The desired height of the view.
 @param duration The duration of the height animation, use 0 for no animation.
 @param completion The completion block called at the end of the animation.
 */
- (void)updateHeight:(CGFloat)height forFilterOptionsView:(FilterOptionsView *)view animationDuration:(CGFloat)duration
      withCompletion:(void(^)(void))completion;

/**
 Informs the delegate that the selected brands were selected.
 @param view The FilterOptionsView that selected the brands.
 @param brands Array of brand NSNumber objects that's integer values correspond to the brand enum.
 */
- (void)filterOptionsView:(FilterOptionsView *)view shouldFilterForBrands:(NSArray *)brands;

@optional

/**
 Informs the delegate that the filter options view is going to collapse.
 @param view The FilterOptionsView affected.
 */
- (void)filterOptionsViewWillCollapse:(FilterOptionsView *)view;

/**
 Informs the delegate that the filter options view has collapsed.
 @param view The FilterOptionsView affected.
 */
- (void)filterOptionsViewDidCollapse:(FilterOptionsView *)view;

/**
 Informs the delegate that the filter options view is going to expand.
 @param view The FilterOptionsView affected.
 */
- (void)filterOptionsViewWillExpand:(FilterOptionsView *)view;

/**
 Informs the delegate that the filter options view has expanded.
 @param view The FilterOptionsView affected.
 */
- (void)filterOptionsViewDidExpand:(FilterOptionsView *)view;

@end
