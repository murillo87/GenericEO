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

#import "NSError+Constants.h"
#import <UIKit/UIKit.h>

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
///----------------------------------------

///-----------------------------------------
///  Object Definitions
///----------------------------------------

@implementation NSError (Constants)

+ (NSError *)noLoggedInUserError {
    return [NSError errorWithDomain:UserErrorDomain code:001 userInfo:[self noLoggedInUserErrorDictionary]];
}

+ (NSError *)alreadyVotedError {
    return [NSError errorWithDomain:ReviewErrorDomain code:010 userInfo:[self alreadyVotedErrorDictionary]];
}

+ (NSError *)cannotEditOtherAuthorReviewsError {
    return [NSError errorWithDomain:ReviewErrorDomain code:020 userInfo:[self cannotEditOtherAuthorReviewsErrorDictionary]];
}

+ (NSDictionary *)noLoggedInUserErrorDictionary {
    return @{
        NSLocalizedDescriptionKey: @"No logged in user.",
        NSLocalizedFailureReasonErrorKey: @"Without a valid user, reviews cannot be written or voted on. Please log in and try again.",
        NSLocalizedRecoverySuggestionErrorKey: @"Please log in before attempting to write or vote on reviews."
    };
}

+ (NSDictionary *)alreadyVotedErrorDictionary {
    return @{
        NSLocalizedDescriptionKey: @"Too many votes.",
        NSLocalizedFailureReasonErrorKey: @"User has attempted to post a duplicate review vote.",
        NSLocalizedRecoverySuggestionErrorKey: @"You may only vote one time on each review."
    };
}

+ (NSDictionary *)cannotEditOtherAuthorReviewsErrorDictionary {
    return @{
        NSLocalizedDescriptionKey: @"Cannot edit review.",
        NSLocalizedFailureReasonErrorKey: @"User has attempted to edit a review created by another author.",
        NSLocalizedRecoverySuggestionErrorKey: @"You may only edit reviews that you have created. You cannot edit a review created by another user."
    };
}

@end
