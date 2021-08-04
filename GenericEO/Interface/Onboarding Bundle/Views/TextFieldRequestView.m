////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       TextFieldRequestView.m
/// @author     Lynette Sesodia
/// @date       3/15/19
//
//  Copyright © 2019 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "TextFieldRequestView.h"

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

@implementation TextFieldRequestView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //Load nib
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"TextFieldRequestView" owner:self options:nil] firstObject];
        [self addSubview:view];
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
        
        [self layoutIfNeeded];
    }
    return self;
}

@end
