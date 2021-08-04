////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ParseUserManager.m
/// @author     Lynette Sesodia
/// @date       3/14/19
//
//  Copyright © 2019 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ParseUserManager.h"
#import "Constants.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ParseUserManager

#pragma mark - User Accounts



#pragma mark - Create

- (void)createUserWithUsername:(NSString *)username
                      password:(NSString *)password
                         email:(NSString *)email
                      deviceID:(NSString *)deviceID
                      userUUID:(NSString *)uuid
                withCompletion:(void (^)(ParseUser * _Nullable user, NSError * _Nullable error))completion {
 
    ParseUser *user = [ParseUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    user.deviceIDs = @[deviceID];
    user.uuid = uuid;
    
    NSError *error;
    [user signUp:&error];
    
    completion(user, error);
}

#pragma mark -  Read

- (ParseUser *)getCurrentUser {
    return [ParseUser currentUser];
}

- (void)loginParseUserWithUsername:(NSString *)username
                          password:(NSString *)password
                    withCompletion:(void (^)(ParseUser * _Nullable, NSError * _Nullable))completion {
    
    //TODO: Need to test this!
    NSError *error;
    ParseUser *user = [ParseUser logInWithUsername:username password:password error:&error];
    completion(user, error);
}

#pragma mark - Update

- (void)updateParseUserPassword:(NSString *)newPW withCompletion:(void (^)(BOOL success, NSError * _Nullable))completion {
    ParseUser *user = [self getCurrentUser];
    user.password = newPW;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(succeeded, error);
    }];
}

- (void)updateParseUserEmail:(NSString *)newEmail withCompletion:(void (^)(BOOL success, NSError * _Nullable))completion {
    ParseUser *user = [self getCurrentUser];
    user.email = newEmail;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(succeeded, error);
    }];
}

- (void)updateParseUsername:(NSString *)newUsername withCompletion:(void (^)(BOOL success, NSError * _Nullable))completion {
    ParseUser *user = [self getCurrentUser];
    user.username = newUsername;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(succeeded, error);
    }];
}

- (void)resetPasswordForParseUserWithEmail:(NSString *)email withCompletion:(void (^)(NSError * error))completion {
    NSError *error;
    [PFUser requestPasswordResetForEmail:email error:&error];
    completion(error);
}

#pragma mark - Delete

- (void)logoutParseUserWithCompletion:(void (^)(NSError * _Nullable))completion {
    [ParseUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        completion(error);
    }];
}

#pragma mark - IAP Queries

- (void)findUserObjectInParse:(void (^)(PFObject * _Nullable userObject, NSError * _Nullable error))completion {
    PFQuery *userQuery = [PFQuery queryWithClassName:ParseUserClass];
    NSLog(@"%@", [[[UIDevice currentDevice] identifierForVendor] UUIDString]);
    [userQuery whereKey:@"deviceID" equalTo:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        // TODO: If multiple objects exist, find the most recently update one (this shouldn't happen though).
        if (objects) {
            completion([objects firstObject], error);
        } else {
            completion(nil, error);
        }
    }];
}

#pragma mark - IAP Saving

- (void)updateParseIAPInfoIfUserAlreadyExists:(BOOL)shouldUpdate withCompletion:(void (^)(BOOL, BOOL, NSError * _Nullable))completion {
    [self findUserObjectInParse:^(PFObject * _Nullable userObject, NSError * _Nullable error) {
        if (!error) {
            // User object exists, update IAP info.
            if (userObject && shouldUpdate) {
                
                // Get user app receipt info
                NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                NSString *receiptStr = [receipt base64EncodedStringWithOptions:0];
                
                // Update in parse
                userObject[@"appleReceipt"] = (receiptStr) ? receiptStr : [NSNull null];
                [userObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    completion(succeeded, YES, error);
                }];
            } else if (userObject && !shouldUpdate) {
                completion(YES, YES, nil);
            } else {
                // No user object exists, create one.
                [self createNewParseUserObject:^(BOOL success, NSError * _Nullable error) {
                    completion(success, NO, error);
                }];
            }
        } else {
            completion(NO, NO, error);
        }
    }];
}

- (void)updateParseUserEmail:(NSString *)email {
    [self findUserObjectInParse:^(PFObject * _Nullable userObject, NSError * _Nullable error) {
        if (userObject) {
            userObject[@"email"] = (email) ? email : [NSNull null];
            [userObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                //
            }];
        }
    }];
}

- (void)createUserWithUsername:(NSString *)username
                      password:(NSString *)password
                         email:(NSString *)email
                      deviceID:(NSString *)deviceID
                      userUUID:(NSString *)uuid {
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    user[@"deviceID"] = deviceID;
    [user signUp];
}

- (void)updateUserReceipt {
    // Get user receipt info
    NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSString *receiptStr = [receipt base64EncodedStringWithOptions:0];
    
    PFUser *user = [PFUser currentUser];
    user[@"appleReceipt"] = (receiptStr) ? receiptStr : [NSNull null];
    [user saveInBackground];
}

- (void)createNewParseUserObject:(void(^)(BOOL success, NSError * _Nullable error))completion {
    // Get user app receipt info
    NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSString *receiptStr = [receipt base64EncodedStringWithOptions:0];
    
    // Create the PFObject for the user (do not use PFUser class)
    PFObject *user = [[PFObject alloc] initWithClassName:ParseUserClass];
    user[@"deviceID"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    user[@"email"] = @"";
    user[@"phone"] = @"";
    user[@"name"] = @"";
    user[@"appleReceipt"] = (receiptStr) ? receiptStr : [NSNull null];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"saved user with device: %@ and receiptData:%@", [[[UIDevice currentDevice] identifierForVendor] UUIDString], receipt);
    }];
}

@end
