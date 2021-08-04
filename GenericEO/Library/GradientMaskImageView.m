////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       GradientMaskImageView.m
/// @author     Lynette Sesodia
/// @date       2/5/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "GradientMaskImageView.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

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

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation GradientMaskImageView

- (void)loadGradientWithMaskFromImageNamed:(NSString *)image
                        withGradientColors:(NSArray *)colors
                                 withFrame:(CGRect)frame {
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    layer.colors = colors;

    UIGraphicsBeginImageContext(frame.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradient = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:image] CGImage];
    mask.frame = frame;
    self.layer.mask = mask;
    self.layer.masksToBounds = YES;
    self.image = gradient;
}

@end
