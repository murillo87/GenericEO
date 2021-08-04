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

#import "UserManager.h"
#import "ParseUserManager.h"

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

@interface UserManager()

@property (nonatomic, strong) ParseUserManager *parseUserManager;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation UserManager

- (id)init {
    self = [super init];
    if (self) {
        self.parseUserManager = [[ParseUserManager alloc] init];
    }
    return self;
}

#pragma mark - Create

- (void)createUserWithEmail:(NSString *)email
                       name:(NSString *)name
                         pw:(NSString *)password
             withCompletion:(void (^)(User * _Nullable, NSError * _Nullable))completion {
      
    // Create uuid from deviceID
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [self.parseUserManager createUserWithUsername:name
                                         password:password
                                            email:email
                                         deviceID:deviceID
                                         userUUID:deviceID
                                   withCompletion:^(ParseUser * _Nullable user, NSError * _Nullable error) {
        completion(user, error);
    }];
}

#pragma mark - Read

- (void)getCurrentUserWithCompletion:(void(^)(User * _Nullable user, NSError * _Nullable error))completion {
    ParseUser *parseUser = [self.parseUserManager getCurrentUser];
    if (parseUser) {
        User *currentUser = [[User alloc] initWithParseUser:parseUser];
        completion(currentUser, nil);
    } else {
        completion(nil, [NSError noLoggedInUserError]);
    }
    
    [self.parseUserManager findUserObjectInParse:^(PFObject * _Nullable userObject, NSError * _Nullable error) {
        if (userObject == nil) {
            
        }
    }];
}

- (NSURL *)getProfileImageURLForUserUUID:(NSString *)userUUID {
    
    if (userUUID == nil) {
        return nil;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://aromabyte.b-cdn.net/profilepictures/%@.png", userUUID];
    return [NSURL URLWithString:urlString];
}

#pragma mark - Update

- (void)updateProfileImage:(UIImage *)image withCompletion:(void (^)(BOOL, NSError * _Nullable))completion {
    
    __block UIImage *blockImage = image;
    
    [self getCurrentUserWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {
        
        // Catch nil users.
        if (user == nil) {
            //TODO: Return no logged in user error.
            completion(NO, nil);
            return;
        }
        
        // Catch nil profile image.
        if (image == nil) {
            // TODO: Return nil image error.
            completion(NO, nil);
        }
        
        // Create image data
        NSData *imgData = UIImagePNGRepresentation(image);
        
        // Create URL to upload to
        NSURL *uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://ny.storage.bunnycdn.com/aromabyte/profilepictures/%@.png", user.uuid]];
        
        // Create upload request
        NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:uploadURL];
        [uploadRequest setHTTPMethod:@"PUT"];
        [uploadRequest setValue:@"4f1def7d-2246-48f6-a4812f99d9e9-8594-4380" forHTTPHeaderField:@"AccessKey"];
        [uploadRequest setHTTPBody:imgData];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:uploadRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                // Handle error...
                completion(NO, error);
                return;
            }
            
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                switch((long)[(NSHTTPURLResponse *)response statusCode]) {
                    case 200:
                    case 201: {
                        NSLog(@"BunnyCDN Upload Success: 200/201");
                        // Update the image in NSUserDefaults
                        NSData *imgData = UIImagePNGRepresentation(blockImage);
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        [dict setObject:[NSDate date] forKey:@"date"];
                        [dict setObject:imgData forKey:@"image"];
                        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:UserDefaultsProfileImageDictionaryKey];
                        
                        // Purge the cache on BunnyCDN
                        NSURL *url = [self getProfileImageURLForUserUUID:user.uuid];
                        [self purgeCacheForURL:url.absoluteString withCompletion:^(NSError * _Nullable error) {
                            if (error) {
                                NSLog(@"error purging cache");
                            }
                            completion(YES, nil);
                        }];
                    } break;
                    
                    case 503:
                    default: {
                        NSString *errorDescription = [NSString stringWithFormat:@"%@ %ld %@", NSLocalizedString(@"An error occurred while uploading the profile image. Error code:", nil), (long)[(NSHTTPURLResponse *)response statusCode], NSLocalizedString(@") Please try again later.", nil)];
                        NSError *userError = [NSError errorWithDomain:NSNetServicesErrorDomain
                                                             code:(NSInteger)[(NSHTTPURLResponse *)response statusCode]
                                                         userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
                        completion(NO, userError);
                    }
                }
            }
            
            // Not sure when we'll get here but just in case
            else {
                NSString *errorDescription = NSLocalizedString(@"Uh oh! Something went wrong. Error code:999. Please try again later.", nil);
                NSError *userError = [NSError errorWithDomain:NSNetServicesErrorDomain
                                                     code:999
                                                 userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
                completion(NO, userError);
            }
                
                  //NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                  //NSLog(@"Response Body:\n%@\n", body);
        }];
        [task resume];
        
    }];
}

- (void)purgeCacheForURL:(NSString *)purgeURL withCompletion:(void(^)(NSError * _Nullable error))completion {
    
    NSString *fullPurgeURL = [NSString stringWithFormat:@"https://bunnycdn.com/api/purge?url=%@", purgeURL];
    NSURL *URL = [NSURL URLWithString:fullPurgeURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"0b719ce9-8755-4e04-8d1f-7cf99fb2e6f893994393-a01f-421e-a653-3f53601032ce" forHTTPHeaderField:@"AccessKey"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {

                                      if (error) {
                                          // Handle error...
                                          return;
                                      }

                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                          NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                      }

                                      NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"Response Body:\n%@\n", body);
                                      completion(error);
                                  }];
    [task resume];
}

- (void)updateEmail:(NSString *)newEmail withCompletion:(void (^)(BOOL, NSError * _Nullable))completion {
    [self.parseUserManager updateParseUserEmail:newEmail withCompletion:^(BOOL success, NSError * _Nullable error) {
        // Add any custom error handling here.
        completion(success, error);
    }];
}

- (void)updateUsername:(NSString *)newUsername withCompletion:(void (^)(BOOL, NSError * _Nullable))completion {
    [self.parseUserManager updateParseUsername:newUsername withCompletion:^(BOOL success, NSError * _Nullable error) {
        // Add any custom error handling here.
        completion(success, error);
    }];
}

- (void)updatePassword:(NSString *)newPW withCompletion:(void (^)(BOOL, NSError * _Nullable))completion {
    [self.parseUserManager updateParseUserPassword:newPW withCompletion:^(BOOL success, NSError * _Nullable error) {
        // Add any custom error handling here.
        completion(success, error);
    }];
}

- (void)resetPasswordForEmail:(NSString *)email withCompletion:(void (^)(NSError *error))completion {
    [self.parseUserManager resetPasswordForParseUserWithEmail:email withCompletion:^(NSError * _Nonnull error) {
        // Add custom error handling here.
        completion(error);
    }];
}

#pragma mark - Delete

- (void)deleteProfileImageWithCompletion:(void(^)(NSError * _Nullable error))completion {
    
    [self getCurrentUserWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {
    
        NSString *deleteString = [NSString stringWithFormat:@"https://ny.storage.bunnycdn.com/aromabyte/profilepictures/%@.png", user.uuid];
        NSURL *deleteURL = [NSURL URLWithString:deleteString];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:deleteURL];
        [request setHTTPMethod:@"DELETE"];
        [request setValue:@"4f1def7d-2246-48f6-a4812f99d9e9-8594-4380" forHTTPHeaderField:@"AccessKey"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           
            if (error) {
                // Handle error
                completion(error);
            }
            
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                switch((long)[(NSHTTPURLResponse *)response statusCode]) {
                    case 200:
                    case 201: {
                        NSLog(@"BunnyCDN Delete Success: 200/201");
                        // Remove the image dictionary from NSUserDefaults
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserDefaultsProfileImageDictionaryKey];
                        
                        // Purge the cache on BunnyCDN
                        NSURL *url = [self getProfileImageURLForUserUUID:user.uuid];
                        [self purgeCacheForURL:url.absoluteString withCompletion:^(NSError * _Nullable error) {
                            if (error) {
                                NSLog(@"error purging cache");
                                completion(error);
                            }
                            completion(nil);
                        }];
                    } break;
                    
                    case 503:
                        NSLog(@"Service Unavailable: 503");
                    default: {
                        NSString *errorDescription = [NSString stringWithFormat:@"%@ %ld %@", NSLocalizedString(@"An error occurred while attempting to delete the profile image. Error code:", nil), (long)[(NSHTTPURLResponse *)response statusCode], NSLocalizedString(@") Please try again later.", nil)];
                        NSError *userError = [NSError errorWithDomain:NSNetServicesErrorDomain
                                                             code:(NSInteger)[(NSHTTPURLResponse *)response statusCode]
                                                         userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
                        completion(userError);
                    }
                }
            }
        }];
        
        [task resume];
    }];
    
    
    
}

#pragma mark - Login / Logout

- (void)loginUserWithUsername:(NSString *)username
                  andPassword:(NSString *)password
               withCompletion:(void (^)(User * _Nullable, NSError * _Nullable))completion {
    
    [self.parseUserManager loginParseUserWithUsername:username
                                             password:password
                                       withCompletion:^(ParseUser * _Nullable user, NSError * _Nullable error) {
        if (user) {
            User *loggedInUser = [[User alloc] initWithParseUser:user];
            completion(loggedInUser, nil);
        } else {
            completion(nil, error);
        }
    }];
    
}

- (void)logoutUserWithCompletion:(void (^)(BOOL, NSError * _Nullable))completion {
    [self.parseUserManager logoutParseUserWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            completion(NO, error);
        } else {
            completion(YES, error);
        }
    }];
}



@end
