////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UserManager.h
/// @author     Lynette Sesodia
/// @date       1/10/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import "User.h"
#import "Constants.h"

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

@interface UserManager : NSObject

#pragma mark - Create

/**
 Creates a user object with the given parameters.
 */
- (void)createUserWithEmail:(NSString *)email name:(NSString *)name pw:(NSString *)password withCompletion:(void(^)(User * _Nullable user, NSError * _Nullable error))completion;

#pragma mark - Read

/**
 Retrieves the current user object.
 Completion block returns the current user object or nil if no user.
 */
- (void)getCurrentUserWithCompletion:(void(^)(User * _Nullable user, NSError * _Nullable error))completion;

/**
 Returns the curren't user's profile image CDN URL to load the image from.
 @param userUUID A users uuid string.
 */
- (NSURL *)getProfileImageURLForUserUUID:(NSString *)userUUID;

#pragma mark - Update

/**
 Updates the user's profile image saved in the CDN. Completion block returns success if the change was successful or an error if not.
 @param image The UIImage to save as the user's profile image.
 */
- (void)updateProfileImage:(UIImage *)image withCompletion:(void (^)(BOOL, NSError * _Nullable))completion;

/**
 Updates the users password. Completion block returns success if the change was successful or an error if not.
 @param newPW The new password.
 */
- (void)updatePassword:(NSString *)newPW withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

/**
 Updates the users username. Completion block returns success if the change was successful or and error if not.
 @param newUsername The new username that the user is requesting.
 */
- (void)updateUsername:(NSString *)newUsername withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

/**
 Updates the user's email. Completion block returns success if the change was successfull or an error if not.
 @param newEmail The new email that the user is requesting.
 */
- (void)updateEmail:(NSString *)newEmail withCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

/**
 Sends a password reset link to the user's email.
 @param email The email to send the reset password link to.
 */
- (void)resetPasswordForEmail:(NSString *)email withCompletion:(void(^)(NSError *error))completion;


#pragma mark - Delete

/**
 Deletes a user's profile image from the CDN.
 */
- (void)deleteProfileImageWithCompletion:(void(^)(NSError * _Nullable error))completion;

//TODO: Do we want the ability to delete a user? Or simply deactivate them?

#pragma mark - Login / Logout
/**
 Logs in the user.
 @param username The username for the user to log in as.
 @param password The password for the user.
 Completion block returns valid user if successful, or nil & an error if not.
 */
- (void)loginUserWithUsername:(NSString *)username andPassword:(NSString *)password withCompletion:(void(^)(User * _Nullable user, NSError * _Nullable error))completion;

/**
 Logout user.
 */
- (void)logoutUserWithCompletion:(void(^)(BOOL success, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
