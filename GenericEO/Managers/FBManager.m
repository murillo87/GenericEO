////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       FBManager.m
/// @author     Lynette Sesodia
/// @date       7/26/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "FBManager.h"
#import <AFNetworking/AFNetworking.h>
#import "Ono.h"

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

static NSString * const tk = @"252252208716481|K_HdOc2Yd85uuFp-rpzt7uQw49U";

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface FBManager()

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation FBManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager {
    static FBManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[FBManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - FBSDK

- (void)refreshPageInfoWithCompletion:(void (^)(NSArray *, NSError *))completion {
    //[self refreshAccessToken];
    
//    if ([FBSDKAccessToken currentAccessToken]) {
//        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                      initWithGraphPath:@"/1331747103590852?fields=name,id,picture"
//                                      parameters:nil
//                                      HTTPMethod:@"GET"];
//        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//            if (result) {
//                completion(result, error);
//            } else {
//                completion(nil, error);
//            }
//        }];
//    }
}

- (void)refreshFeedWithCompletion:(void(^)(NSArray *feedJSON, NSError *error))completion {
    
    //[self refreshAccessToken];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/doTERRAapp/feed"
                                      parameters:@{ @"fields": @"attachments",}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            // Parse JSON
            if (result) {
                completion([result valueForKey:@"data"], error);
            }
        }];
    } else {
        // Refresh login
        [self refreshAccessTokenWithCompletion:^{
            [self refreshFeedWithCompletion:^(NSArray *feedJSON, NSError *error) {
                completion(feedJSON, error);
            }];
        }];
    }
}

- (void)refreshAccessToken {
//    NSString *tokenStr = @"EAADlbAtLWsEBAHcx3NWQXjZB5xmgIaaqR0jzko430SbRAOcmvF1ijHcZCFunwqWL7n5kEbUNZAfJiDrndRIMHaBRNaEmSwHzwcdov9uQixthmMXkWoMSM9lrrqRZBhaH0EIsNPnqq9aA7wwOZBji1BJWbLdRCnhRGZCwgn632PcZCZCco7eXXI1eOrPZCxY0kEJlL7Ql9Udjc5QZDZD";
//    FBSDKAccessToken *token = [[FBSDKAccessToken alloc] initWithTokenString:tokenStr
//                                                                permissions:nil
//                                                        declinedPermissions:nil
//                                                                      appID:nil
//                                                                     userID:nil
//                                                             expirationDate:nil
//                                                                refreshDate:nil];
//    [FBSDKAccessToken setCurrentAccessToken:token];
}

- (void)refreshAccessTokenWithCompletion:(void(^)(void))completion {
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:@"https://graph.facebook.com/oauth/access_token?client_id=252252208716481&client_secret=f23ba0ef74093adb7a0947c2e13048fb&grant_type=client_credentials"
//      parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//          NSString *tokenStr = [responseObject valueForKey:@"access_token"];
//          FBSDKAccessToken *token = [[FBSDKAccessToken alloc] initWithTokenString:tokenStr
//                                                                      permissions:nil
//                                                              declinedPermissions:nil
//                                                                            appID:nil
//                                                                           userID:nil
//                                                                   expirationDate:nil
//                                                                      refreshDate:nil];
//          [FBSDKAccessToken setCurrentAccessToken:token];
//          completion();
//          //NSLog(@"JSON: %@", responseObject);
//      } failure:^(NSURLSessionTask *operation, NSError *error) {
//          NSLog(@"Error: %@", error);
//      }];
}

#pragma mark - Ono

//- (void)scrapeFeedWithCompletion:(void (^)(NSArray *feedJSON, NSError *error))completion {
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.facebook.com/doterraapp"]];
//    NSError *error;
//    
//    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:data error:&error];
//    for (ONOXMLElement *element in document.rootElement.children) {
//        NSLog(@"%@: %@", element.tag, element.attributes);
//    }
//    
//    // Support for Namespaces
//    NSString *author = [[document.rootElement firstChildWithTag:@"creator" inNamespace:@"dc"] stringValue];
//    
//    // Automatic Conversion for Number & Date Values
//    NSDate *date = [[document.rootElement firstChildWithTag:@"created_at"] dateValue]; // ISO 8601 Timestamp
//    NSInteger numberOfWords = [[[document.rootElement firstChildWithTag:@"word_count"] numberValue] integerValue];
//    BOOL isPublished = [[[document.rootElement firstChildWithTag:@"is_published"] numberValue] boolValue];
//    
//    // Convenient Accessors for Attributes
//    NSString *unit = [document.rootElement firstChildWithTag:@"Length"][@"unit"];
//    NSDictionary *authorAttributes = [[document.rootElement firstChildWithTag:@"author"] attributes];
//    
//    // Support for XPath & CSS Queries
//    [document enumerateElementsWithXPath:@"//Content" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
//        NSLog(@"%@", element);
//    }];
//}
     
@end
