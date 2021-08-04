////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ParseUserManager.h
/// @author     Lynette Sesodia
/// @date       3/14/19
//
//  Copyright © 2019 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
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

@interface ParseUserManager : NSObject

#pragma mark - User Accounts



#pragma mark - Create

/**
 Creates a user in the parse database with the given parameters.
 */
- (void)createUserWithUsername:(NSString *)username
                      password:(NSString *)password
                         email:(NSString *)email
                      deviceID:(NSString *)deviceID
                      userUUID:(NSString *)uuid
                withCompletion:(void(^)(ParseUser * _Nullable user, NSError * _Nullable error))completion;


#pragma mark - Read

/**
 Returns the current user from the Parse Database.
 */
- (ParseUser *)getCurrentUser;


#pragma mark - Update

/**
 Updates the users password. Completion block returns error if unsuccessful.
 @param newPW The new password.
 */
- (void)updateParseUserPassword:(NSString *)newPW withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

/**
 Updates the users username. Completion block returns error if unsuccessful.
 @param newUsername The new username that the user is requesting.
 */
- (void)updateParseUsername:(NSString *)newUsername withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

/**
 Updates the user's email. Completion block returns success if the email change was successful or an error if not.
 @param newEmail The new email that the user is requesting.
 */
- (void)updateParseUserEmail:(NSString *)newEmail withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

/**
 Sends a password reset link to the user's email. Completion block returns error if unsuccessful.
 @param email The email address to send the reset link to, this must match the previously created user account email.
 */
- (void)resetPasswordForParseUserWithEmail:(NSString *)email withCompletion:(void(^)(NSError * _Nullable error))completion;

#pragma mark - Login/Logout

/**
 Logs in a user.
 @param username The username for the user.
 @param password The plain text password for the user.
 Completion block returns ParseUser if successful or nil & error if not.
 */
- (void)loginParseUserWithUsername:(NSString *)username
                          password:(NSString *)password
                    withCompletion:(void(^)(ParseUser * _Nullable user, NSError * _Nullable error))completion;

/**
 Logout an active user.
 */
- (void)logoutParseUserWithCompletion:(void(^)(NSError * _Nullable error))completion;

#pragma mark - InApp Purchases

/**
 Queries parse for a user object from the Parse User Class.
 */
- (void)findUserObjectInParse:(void(^)(PFObject * _Nullable userObject, NSError * _Nullable error))completion;

/**
 Updates an existing parse user class object with IAP info.
 @details If the parse user does not exist, this method creates a completed user object with Profile info as well.
 @param shouldUpdate Boolean indicating if the user exists, should IAP info be sent to parse.
 */
- (void)updateParseIAPInfoIfUserAlreadyExists:(BOOL)shouldUpdate
                               withCompletion:(void(^)(BOOL success, BOOL userDidExist, NSError * _Nullable error))completion;


/**
 Updates an
 */
- (void)updateParseUserEmail:(NSString *)email;

@end

NS_ASSUME_NONNULL_END
