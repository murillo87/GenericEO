////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NSError+Constants.h
/// @author     Lynette Sesodia
/// @date       1/31/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

static NSErrorDomain _Nonnull const ReviewErrorDomain = @"Error.Review";
static NSErrorDomain _Nonnull const UserErrorDomain = @"Error.User";

///-----------------------------------------
///  Object Declarations
///-----------------------------------------


NS_ASSUME_NONNULL_BEGIN

@interface NSError (Constants)

+ (NSError *)noLoggedInUserError;

+ (NSError *)cannotEditOtherAuthorReviewsError;

+ (NSError *)alreadyVotedError;

@end

NS_ASSUME_NONNULL_END
