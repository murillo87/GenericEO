////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       RoundedShadowButton.m
/// @author     Lynette Sesodia
/// @date       2/5/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "RoundedShadowButton.h"
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

@implementation RoundedShadowButton

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
    
    self.backgroundColor = [UIColor targetAccentColor];
    self.tintColor = [UIColor whiteColor];
    self.layer.shadowColor = [UIColor targetAccentColor].CGColor;
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowRadius = 6;
    self.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
    self.layer.cornerRadius = self.frame.size.height/2;
    self.clipsToBounds = YES;
    self.layer.masksToBounds = NO;
    self.layer.borderWidth = 0.0f;
}

@end
