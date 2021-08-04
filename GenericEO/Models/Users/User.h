////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       User.h
/// @author     Lynette Sesodia
/// @date       1/10/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import "ParseUser.h"

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

@interface User : NSObject

/// Public username for the user.
@property (nonatomic, readonly, strong) NSString *username;

/// Private unique identifier for the user.
@property (nonatomic, readonly, strong) NSString *uuid;

/// The user's email address.
@property (nonatomic, readonly, strong) NSString *email;

/// The user's password.
@property (nonatomic, readonly, strong) NSString *password;

/// Array of deviceIDs used by the user.
@property (nonatomic, readonly, strong) NSArray *deviceIDs;

/// Dictionary of reviews the user has voted on. The key for each review is the review UUID, the value is -1, 0, 1
/// for upvote, no vote, or downvote. This prevents duplicate voting.
@property (nonatomic, strong) NSDictionary *votingRecord;

/// Array of reviews the user has flagged as inappropriate. The key for each review is the review UUID.
@property (nonatomic, strong) NSArray *flagRecord;

/**
 Initializes a User with a given parseUser object. This is the only acceptable way to create a User object.
 @param parseUser A ParseUser object saved in the parse database.
 */
- (id)initWithParseUser:(ParseUser *)parseUser NS_DESIGNATED_INITIALIZER;

- (id)init NS_UNAVAILABLE;
- (id)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 Records a user's vote to their voting record.
 @param vote The vote value: 1 for upvote, -1 for downvote.
 @param reviewID The uuid for the review voted on.
 */
- (void)recordVote:(NSNumber *)vote forReviewID:(NSString *)reviewID;

/**
 Records a user's flag to their flag record.
 @param reviewID The uuid for the review flagged as inappropriate.
 */
- (void)recordFlagForReviewID:(NSString *)reviewID;

/**
 Adds a deviceID to the user objects array of deviceIDs.
 @param deviceID The string deviceID to add.
 */
- (void)addDeviceID:(NSString *)deviceID;


@end

NS_ASSUME_NONNULL_END
