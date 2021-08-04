////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       WebViewController.h
/// @author     Lynette Sesodia
/// @date       1/23/19
//
//  Copyright © 2019 Essentl LLC. All rights reserved.
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

@interface WebViewController : UIViewController

/// The url to load the website for.
@property (nonatomic, strong) NSString *websiteURL;

/// Sets the header bar title to the given string.
- (void)setTitleText:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
