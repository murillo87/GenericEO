////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       RoundedTextField.m
/// @author     Lynette Sesodia
/// @date       2/5/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "RoundedTextField.h"
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
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation RoundedTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultFormatting];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self defaultFormatting];
    }
    return self;
}

- (void)defaultFormatting {
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor systemGrayColor].CGColor;
    self.layer.cornerRadius = self.frame.size.height/2;
    self.clipsToBounds = YES;
}

- (UIView *)viewWithEmbeddedImageNamed:(NSString *)image {
    CGFloat height = self.frame.size.height;
    CGRect iconFrame = CGRectMake(8, 10, height-20, height-20);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:iconFrame];
    imageView.image = [UIImage imageNamed:image];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, height-8, height)];
    [view addSubview:imageView];
    
    return view;
}

@end
