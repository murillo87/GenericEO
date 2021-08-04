////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       GradientMaskImageView.h
/// @author     Lynette Sesodia
/// @date       2/5/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>

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

@interface GradientMaskImageView : UIImageView

/**
 Creates a gradient with the given colors and masks to the given image.
 @param image String name of the image to act as a mask.
 @param colors Array of (id)CGColorRef colors to use in the gradient.
 @param frame The frame for the image to be created.
 */
- (void)loadGradientWithMaskFromImageNamed:(NSString *)image withGradientColors:(NSArray *)colors withFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
