////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UserProfileViewController.h
/// @author     Lynette Sesodia
/// @date       9/18/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import "User.h"

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

@interface UserProfileViewController : UIViewController

/**
 Reloads the controller's tableview containing user reviews.
 */
- (void)reloadReviews;

@end

NS_ASSUME_NONNULL_END
