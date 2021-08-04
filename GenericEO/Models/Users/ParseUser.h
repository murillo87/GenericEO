////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ParseUser.h
/// @author     Lynette Sesodia
/// @date       1/13/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Parse/Parse.h>
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

@interface ParseUser : PFUser<PFSubclassing>

/// Public username for the user.
@property (nonatomic, strong) NSString *username;

/// Private unique identifier for the user.
@property (nonatomic, strong) NSString *uuid;

/// The user's email address.
@property (nonatomic, strong) NSString *email;

/// The user's password.
@property (nonatomic, strong) NSString *password;

/// Array of deviceIDs used by the user.
@property (nonatomic, strong) NSArray *deviceIDs;

/// Dictionary of reviews the user has voted on. The key for each review is the review UUID, the value is -1, 0, 1
/// for upvote, no vote, or downvote. This prevents duplicate voting.
@property (nonatomic, strong) NSDictionary *votingRecord;

/// Array of reviews the user has flagged as inappropriate. The key for each review is the UUID.
@property (nonatomic, strong) NSArray *flagRecord;

@end

NS_ASSUME_NONNULL_END
