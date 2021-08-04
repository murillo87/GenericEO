////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ParseUser.m
/// @author     Lynette Sesodia
/// @date       1/13/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

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
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------
///
///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ParseUser

@dynamic username;
@dynamic uuid;
@dynamic email;
@dynamic password;
@dynamic deviceIDs;
@dynamic votingRecord;
@dynamic flagRecord;

- (NSString *)uuid {
    return [self valueForKey:@"objectId"];
}


@end
