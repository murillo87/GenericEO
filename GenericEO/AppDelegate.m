////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       AppDelegate.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "AppDelegate.h"
#import "Constants.h"

#import <Impera/StoreKit.h>
#import "IAPProducts.h"
#import "ParseUserManager.h"

#import "FBManager.h"
#import "NetworkManager.h"
#import "CoreDataManager.h"

#import "TabBarViewController.h"

#import <MagicalRecord/MagicalRecord.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "KochavaTracker.h"
#import <OneSignal/OneSignal.h>

///Privacy - Tracking Usage Description
@import AppTrackingTransparency;


@import Firebase;

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

@interface AppDelegate () <KochavaTrackerDelegate>

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Initialize Parse
    [NetworkManager sharedManager];
    
    // Configure subscription manager
    NSSet<IAPProduct *> *products = [NSSet setWithObjects:IAPProductUsageGuideSubscriptionRenewingMonthly, IAPProductUsageGuideSubscriptionRenewingYearly, nil];
    [[IAPServerSubscriptionManager manager] setParseServerVerificationUserClass:ParseUserClass];
    [[IAPServerSubscriptionManager manager] setIAPProducts:products];
    
    // Make sure a parse user exists.
    ParseUserManager *parseUserManager = [[ParseUserManager alloc] init];
    [parseUserManager updateParseIAPInfoIfUserAlreadyExists:NO withCompletion:^(BOOL success, BOOL userDidExist, NSError * _Nullable error) {
        NSLog(@"updateParseIAPInfoIfUserAlreadyExist:(^)(success:%d, userDidExist:%d, error:%@", success, userDidExist, error);
    }];
    
    // Validate receipts for app on launch
    [[IAPServerSubscriptionManager manager] verifyReceiptsWithServer:^(BOOL hasActiveSubscription, NSError * _Nullable error) {
        // Update NSUserDefaults bool for subscription
        [[NSUserDefaults standardUserDefaults] setBool:hasActiveSubscription forKey:AppHasActivePremiumSubscriptionKey];
    }];
    
    // Magical Record
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:storeURL];
    
    // Fabric
    [Fabric with:@[[Crashlytics class],[Answers class]]];
    [[Fabric sharedSDK] setDebug: YES];
    
    // Firebase
    [FIRApp configure];
    
    // Configure analytics manager
    {
        IPAAnalyticsManager *analyticsManager = [IPAAnalyticsManager sharedInstance];
        analyticsManager.durationResolution = IPATrackedEventDurationResolutionSeconds;
        analyticsManager.sendsDurationResolutionForTrackedEvents = YES;
        analyticsManager.sendsSessionDataForTrackedEvents = YES;
        analyticsManager.eventLoggers = @[[[FabricAnalyticsLogger alloc] init]];
        analyticsManager.sessionProvider = [[IPAAnalyticsBasicSessionProvider alloc] init];
        
        // Start tracking several analytics events
        [analyticsManager startTrackingEvent:[IPAAnalyticsEvent eventWithName:AnalyticsSoftImpressionDataEvent]];
        [analyticsManager startTrackingEvent:[IPAAnalyticsEvent eventWithName:AnalyticsMediumImpressionDataEvent]];
        [analyticsManager startTrackingEvent:[IPAAnalyticsEvent eventWithName:AnalyticsHardImpressionDataEvent]];
        [analyticsManager startTrackingEvent:[IPAAnalyticsEvent eventWithName:AnalyticsPurchaseEvent]];
    }
    
    // FBSDK
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [FBManager sharedManager];
    
    //Kochave Parameters Dictionary
    NSDictionary *parametersDictionary = @{ kKVAParamAppGUIDStringKey:kochavaGUID,
                                            kKVAParamRetrieveAttributionBoolKey: @(YES) };
    
    //OneSignal. 'OneSignalID' is a constant for each Target
    [OneSignal initWithLaunchOptions:launchOptions appId:OneSignalID handleNotificationAction:nil settings:@{kOSSettingsKeyAutoPrompt: @false}];
    OneSignal.inFocusDisplayType = OSNotificationDisplayTypeNotification;
    
    [KochavaTracker.shared configureWithParametersDictionary:parametersDictionary delegate:self];
    
    // Set the window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ///Privacy - Tracking Usage Description
    if (@available(iOS 14, *)) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                switch (status) {
                    case ATTrackingManagerAuthorizationStatusNotDetermined:
                        //
                        break;
                    case ATTrackingManagerAuthorizationStatusRestricted:
                        //
                        break;
                    case ATTrackingManagerAuthorizationStatusDenied:
                        //
                        break;
                    case ATTrackingManagerAuthorizationStatusAuthorized:
                        //
                        break;
                        
                        
                    default:
                        break;
                }
            }];
        } else {
        }
    
    // On first launch show onboarding
    if (![[NSUserDefaults standardUserDefaults] boolForKey:UserHasCompletedOnboardingKey]) {
        // Inject Light Onboarding Here
         self.onboardingController = [[OnboardingViewController alloc] init];
        self.window.rootViewController = self.onboardingController;
        
    } else {
        TabBarViewController *tabVC = [[TabBarViewController alloc] init];
        self.navController = [[NavigationController alloc] initWithRootViewController:tabVC];
        self.window.rootViewController = self.navController;
        [self.window makeKeyAndVisible];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[[IAPManager sharedManager] refreshIAPStatuses];
    [FBSDKAppEvents activateApp];
    
    // Validate IAP receipts
    [[IAPServerSubscriptionManager manager] verifyReceiptsWithServer:^(BOOL hasActiveSubscription, NSError * _Nullable error) {
        // Update NSUserDefaults bool for subscription
        [[NSUserDefaults standardUserDefaults] setBool:hasActiveSubscription forKey:AppHasActivePremiumSubscriptionKey];
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

#pragma mark - Application's documents directory

//Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - KochavaTrackerDelegate

- (void)tracker:(KochavaTracker *)tracker didRetrieveAttributionDictionary:(NSDictionary *)attributionDictionary {
    NSLog(@"Kochave: Do something with attributionDictionary... %@", attributionDictionary);
}

@end
