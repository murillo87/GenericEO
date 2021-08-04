////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PrettySearchBar.h
/// @author     Lynette Sesodia
/// @date       8/7/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "PrettySearchBar.h"

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

@interface PrettySearchBar()

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation PrettySearchBar

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UITextField *searchField;
    NSUInteger numViews = [self.subviews count];
    for (int i = 0; i < numViews; i++) {
        if ([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
            searchField = [self.subviews objectAtIndex:i];
        }
    }
    
    if(!(searchField == nil)) {
        searchField.frame = CGRectMake(10, 10, self.frame.size.width-20, 44);
        searchField.textColor = [UIColor darkGrayColor];
        searchField.backgroundColor = [UIColor whiteColor];
        searchField.borderStyle = UITextBorderStyleNone;
        searchField.layer.cornerRadius = 22.0;
    }
    
    [super layoutSubviews];
}

@end
