////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       FeedViewController.h
/// @author     Lynette Sesodia
/// @date       5/27/20
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

@interface FeedViewController : UIViewController

/**
 Initializes the FeedController for the current target.
 */
- (id)initForTarget;

@end

NS_ASSUME_NONNULL_END
