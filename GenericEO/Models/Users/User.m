////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       User.m
/// @author     Lynette Sesodia
/// @date       1/10/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

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
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface User()

/// Reference to the Parse User.
@property (nonatomic, strong) ParseUser *parseUser;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation User

@synthesize username = _username;
@synthesize uuid = _uuid;
@synthesize email = _email;
@synthesize password = _password;
@synthesize deviceIDs = _deviceIDs;
@synthesize votingRecord = _votingRecord;
@synthesize flagRecord = _flagRecord;

#pragma mark Initialization

- (id)initWithParseUser:(ParseUser *)parseUser {
    self = [super init];
    if (self) {
        self.parseUser = parseUser;
    }
    return self;
}

#pragma mark - Getters/Setters

- (NSString *)username {
    return self.parseUser.username;
}

- (NSString *)uuid {
    return self.parseUser.uuid;
}

- (NSString *)email {
    return self.parseUser.email;
}

- (NSString *)password {
    return self.parseUser.password;
}

- (NSArray *)deviceIDs {
    return self.parseUser.deviceIDs;
}

- (NSDictionary *)votingRecord {
    return self.parseUser.votingRecord;
}

- (NSArray *)flagRecord {
    return self.parseUser.flagRecord;
}


- (void)addDeviceID:(NSString *)deviceID {
    NSMutableSet *deviceIDs = [NSMutableSet setWithArray:[self.parseUser.deviceIDs mutableCopy]];
    if (![deviceIDs containsObject:deviceID]) {
        [deviceIDs addObject:deviceID];
        self.parseUser.deviceIDs = deviceIDs.allObjects;
        [self.parseUser saveInBackground];
    }
}

- (NSDictionary *)reviewVotes {
    return self.parseUser.votingRecord;
}

- (void)recordVote:(NSNumber *)vote forReviewID:(NSString *)reviewID {
    NSMutableDictionary *recordedVotes = [self.parseUser.votingRecord mutableCopy];
    
    if (recordedVotes == nil) {
        recordedVotes = [[NSMutableDictionary alloc] init];
    }
    
    [recordedVotes setValue:vote forKey:reviewID];
    
    self.parseUser.votingRecord = [recordedVotes copy];
    [self.parseUser saveInBackground];
}

- (void)recordFlagForReviewID:(NSString *)reviewID {
    NSMutableArray *recordedFlags = [self.parseUser.flagRecord mutableCopy];
    
    if (recordedFlags == nil) {
        recordedFlags = [[NSMutableArray alloc] init];
    }
    
    [recordedFlags addObject:reviewID];
    self.parseUser.flagRecord = [recordedFlags copy];
    [self.parseUser saveInBackground];
}

@end
