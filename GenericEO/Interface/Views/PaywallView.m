////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PaywallView.m
/// @author     Lynette Sesodia
/// @date       6/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "PaywallView.h"
#import "Constants.h"

#import "ABPaywallView.h"
#import "ESTLPaywallView.h"

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

@interface PaywallView()

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation PaywallView

- (id)initForTarget {
#ifdef AB
    self = [[ABPaywallView alloc] init];
#else
    self = [[ESTLPaywallView alloc] init];
#endif
    
    return self;
}

- (IBAction)upgrade:(UIButton *)sender {
    [self.delegate iapUpgradeSelectedFromPaywallView:self];
}

- (void)animate {
#ifdef AB
    [self animate];
#endif
}

@end
