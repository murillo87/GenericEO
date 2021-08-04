////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       EditUserProfileViewController.h
/// @author     Lynette Sesodia
/// @date       2/19/20
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

@protocol EditUserProfileDelegate

/**
 Informs the delegate that the user profile was updated.
 */
- (void)userProfileDidUpdate;

@end

@interface EditUserProfileViewController : UIViewController

@property (nonatomic, weak) id<EditUserProfileDelegate> delegate;

- (instancetype)initForUser:(User *)user withProfileImage:(UIImage *)profilePic;

@end

NS_ASSUME_NONNULL_END
