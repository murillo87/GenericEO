////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       OilViewController.m
/// @author     Lynette Sesodia
/// @date       3/11/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "OilViewController.h"
#import "ABOilViewController.h"
#import "SingleOilsViewController.h"

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

@interface OilViewController ()

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation OilViewController

#pragma mark - Lifecycle

- (instancetype)initWithOil:(PFOil *)oil andSources:(PFObject *)source {
    self = [[SingleOilsViewController alloc] init];
    if (self) {
        
        _object = oil;
        _sourceObject = source;
        _myOil = [[CoreDataManager sharedManager] getOilById:oil.uuid];
        
        // Retrieve valid source object if value is nil
        if (source == nil) {
            [[NetworkManager sharedManager] queryByClass:ParseClassNameOilSources
                                                  forKey:@"uuid"
                                              withValues:@[oil.uuid]
                                          withCompletion:^(NSArray<PFObject *> *objects, NSError *error) {
                                                      if (objects != nil && objects.count > 0) {
                                                          self.sourceObject = [objects firstObject];
                                                      }
                                                  }];
        }
        
        NSArray *oils = [NSArray arrayByCapitalizingStringsInArray:oil.blendsWith];
        [[NetworkManager sharedManager] queryProductsForKey:@"name"
                                                 withValues:oils
                                             withCompletion:^(NSArray<PFOil *> *objects, NSError *error) {
                                                 if (!error) {
                                                     self.blendsWith = objects;
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [self.tableView reloadData];
                                                     });
                                                 }
        }];
    }
    return self;
}

- (instancetype)initWithDoterraOil:(PFDoterraOil *)oil {
#ifdef AB
    self = [[ABOilViewController alloc] init];
#else
    self = [[SingleOilsViewController alloc] init];
#endif

    _object = oil;
    _myOil = [[CoreDataManager sharedManager] getOilById:oil.uuid];
    
    [self.oilVCDelegate separateKeysForDoterraOil:oil];
    
    // Query for blendsWith oil objects
    if (oil.blendsWith.count > 0) {
        [[NetworkManager sharedManager] queryProductsForKey:@"uuid"
                                                 withValues:oil.blendsWith
                                             withCompletion:^(NSArray<PFObject<OilModel> *> *objects, NSError *error) {
                                                 if (!error) {
                                                     self.blendsWith = objects;
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [self.tableView reloadData];
                                                     });
                                                 }
                                             }];
    }
    
    [self queryReviewsWithCompletion:^{}];
    
    return self;
}

- (instancetype)initWithYoungLivingOil:(PFYoungLivingOil *)oil {
#ifdef AB
    self = [[ABOilViewController alloc] init];
#else
    self = [[SingleOilsViewController alloc] init];
#endif
    
    if (self) {
        _object = oil;
        _myOil = [[CoreDataManager sharedManager] getOilById:oil.uuid];
        
        [self.oilVCDelegate separateKeysForYoungLivingOil:oil];
        
        // Query for blendsWith oil objects
        if (oil.blendsWith.count > 0) {
            [[NetworkManager sharedManager] queryProductsForKey:@"uuid"
                                                     withValues:oil.blendsWith
                                                 withCompletion:^(NSArray<PFObject<OilModel> *> *objects, NSError *error) {
                                                     if (!error) {
                                                         self.blendsWith = objects;
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [self.tableView reloadData];
                                                         });
                                                     }
                                                 }];
        }
        
        // Query for companion oils objects
        if (oil.companionOils.count > 0) {
            [[NetworkManager sharedManager] queryProductsForKey:@"uuid"
                                                     withValues:oil.companionOils
                                                 withCompletion:^(NSArray<PFObject<OilModel> *> *objects, NSError *error) {
                                                     self.companionOils = objects;
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                             [self.tableView reloadData];
                                                     });
                                                 }];
        }
            
        // Query for single oils included objects
        if (oil.companionOils.count > 0) {
            [[NetworkManager sharedManager] queryProductsForKey:@"uuid"
                                                     withValues:oil.singleOilsIncluded
                                                 withCompletion:^(NSArray<PFObject<OilModel> *> *objects, NSError *error) {
                                                     self.singleOilsIncluded = objects;
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                             [self.tableView reloadData];
                                                     });
                                                 }];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    IPAAnalyticsEvent *event = [IPAAnalyticsEvent eventWithName:AnalyticsViewedOil];
    [event setValue:[NSString stringWithFormat:@"%@", self.object.name]
       forAttribute:AnalyticsNameAttribute];
    [[IPAAnalyticsManager sharedInstance] reportEvent:event];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Query core data to see if the oil is saved to my oils
    self.myOil = [[CoreDataManager sharedManager] getOilById:self.object.uuid];
    [self.oilVCDelegate setMyOilButtonSelected:(self.myOil != nil) ? YES : NO];
    
    // Query core data to see if a note has been created
    self.note = [[CoreDataManager sharedManager] getNoteForID:self.object.uuid];
    [self.tableView reloadData];
    
    // Query core data to see if the recipe has been added to favorites
    self.favorite = [[CoreDataManager sharedManager] getFavoriteById:self.object.uuid];
    [self.oilVCDelegate setFavoriteButtonSelected:(self.favorite != nil) ? YES : NO];
    
    // Query for updated reviews.
    [self queryReviewsWithCompletion:^{}];
}

#pragma mark - Public

- (BOOL)isValid:(NSString *)str {
    if (str && str.length > 0) {
        return YES;
    }
    return NO;
}

- (void)reloadUserReviewCell {
#ifdef AB
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
#endif
}


#pragma mark - Data

- (void)getBlendsWithOils {
    
}

- (void)queryReviewsWithCompletion:(void(^)(void))completion {
    // Query for reviews
    [[[ReviewManager alloc] init] getReviewsForParentObjectID:self.object.uuid
                                               withCompletion:^(NSArray<Review *> * _Nullable reviews, NSError * _Nullable error) {
        if (!error) {
            self.reviews = reviews;
        }
        
        UserManager *manager = [[UserManager alloc] init];
        [manager getCurrentUserWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {
            if (!error && user) {
                // Get user ID and check against reviews
                NSString *userID = user.uuid;
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"authorID == %@", userID];
                NSArray *sources = [self.reviews filteredArrayUsingPredicate:predicate];
                
                if (sources.count > 0) {
                    self.userReview = [sources firstObject];
                    
                    // Remove the user's own review from the list of reviews since it will always be displayed at the top.
                    NSMutableArray *mutableReviews = [self.reviews mutableCopy];
                    [mutableReviews removeObject:self.userReview];
                    self.reviews = [mutableReviews copy];
                }
            }
        }];
        
        // Calculate star average for reviews.
        double total = 0.0;
        for (Review *r in reviews) {
            total += [r.starValue doubleValue];
        }
        
        NSLog(@"total = %.1f, count = %lu, average = %.2f", total, reviews.count, total/(double)reviews.count);
        
        // Call delegate for review average
        if ([self.oilVCDelegate respondsToSelector:@selector(reviewProcessingDidFinishWithRatingAverage:)]) {
            [self.oilVCDelegate reviewProcessingDidFinishWithRatingAverage:total/(double)reviews.count];
        }
        
        completion();
    }];
}

#pragma mark - IBActions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addToMyOils:(id)sender {
    if (self.myOil) {
        [[CoreDataManager sharedManager] removeOil:self.myOil fromInventory:YES fromShoppingList:NO withCompletion:^(BOOL didDelete, NSError *error) {
            self.myOil = [[CoreDataManager sharedManager] getOilById:self.object.uuid];
            [self.oilVCDelegate setMyOilButtonSelected:(self.myOil != nil) ? YES : NO];
        }];
    } else {
        [[CoreDataManager sharedManager] saveOil:self.object toInventory:YES toShoppingList:NO withCompletion:^(BOOL didSave, NSError *error) {
            if (didSave) {
                self.myOil = [[CoreDataManager sharedManager] getOilById:self.object.uuid];
                [self.oilVCDelegate setMyOilButtonSelected:(self.myOil != nil) ? YES : NO];
            }
            
            IPAAnalyticsEvent *event = [IPAAnalyticsEvent eventWithName:AnalyticsAddedOilToInventory];
            [event setValue:[NSString stringWithFormat:@"%@", self.object.name]
               forAttribute:AnalyticsNameAttribute];
            [[IPAAnalyticsManager sharedInstance] reportEvent:event];
        }];
    }
}

- (IBAction)favorite:(id)sender {
    if (self.favorite) {
        [[CoreDataManager sharedManager] removeFavorite:self.favorite withCompletion:^(BOOL didDelete, NSError *error) {
            if (didDelete) {
                self.favorite = nil;
                [self.oilVCDelegate setFavoriteButtonSelected:NO];
            }
        }];
    } else {
        [[CoreDataManager sharedManager] addFavorite:self.object withCompletion:^(BOOL didSave, NSError *error) {
            if (didSave) {
                self.favorite = [[CoreDataManager sharedManager] getFavoriteById:self.object.uuid];
                [self.oilVCDelegate setFavoriteButtonSelected:YES];
            }
        }];
        
        IPAAnalyticsEvent *event = [IPAAnalyticsEvent eventWithName:AnalyticsFavorited];
        [event setValue:[NSString stringWithFormat:@"%@", self.object.name]
           forAttribute:AnalyticsNameAttribute];
        [[IPAAnalyticsManager sharedInstance] reportEvent:event];
    }
}


@end
