////////////////////////////////////////////////////////////////////////////////
//  Essential Oils
/// @file       ESTLRecipeViewController.h
/// @author     Lynette Sesodia
/// @date       7/16/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "RecipeViewController.h"
#import "ABRecipeViewController.h"
#import "ESTLRecipeViewController.h"

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

@interface RecipeViewController ()

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation RecipeViewController

- (id)initWithRecipe:(PFRecipe *)recipe {
    
#ifdef AB
    self = [[ABRecipeViewController alloc] init];
#else
    self = [[ESTLRecipeViewController alloc] init];
#endif
    
    _recipe = recipe;
    if (self.recipe.oilsUsed.count > 0) {
    #ifdef GENERIC
        NSArray *capitalized = [NSArray arrayByCapitalizingStringsInArray:self.recipe.oilsUsed];
        [[NetworkManager sharedManager] queryProductsForKey:@"name"
                                                 withValues:capitalized
                                             withCompletion:^(NSArray<PFOil *> *objects, NSError *error) {
                                                 if (!error) {
                                                     self.oilsUsed = objects;
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [self.tableView reloadData];
                                                     });
                                                 }
                                             }];
    #else
        // Search for oilsUsed by UUID
        [[NetworkManager sharedManager] queryProductsForKey:@"uuid"
                                                 withValues:self.recipe.oilsUsed
                                             withCompletion:^(NSArray<PFOil *> *objects, NSError *error) {
                                                 if (!error) {
                                                     self.oilsUsed = objects;
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [self.tableView reloadData];
                                                     });
                                                 }
                                             }];
    #endif
        
#ifdef DOTERRA
        
#endif
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    IPAAnalyticsEvent *event = [IPAAnalyticsEvent eventWithName:AnalyticsViewedRecipe];
    [event setValue:[NSString stringWithFormat:@"%@", self.recipe[@"name"]]
       forAttribute:AnalyticsNameAttribute];
    [[IPAAnalyticsManager sharedInstance] reportEvent:event];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Query core data to see if a note has been created
    NSLog(@"object.uuid = %@", self.recipe.uuid);
    self.note = [[CoreDataManager sharedManager] getNoteForID:self.recipe.uuid];
    
    // Query core data to see if the recipe has been added to favorites
    self.favorite = [[CoreDataManager sharedManager] getFavoriteById:self.recipe.uuid];
    
    // Query for updated reviews.
    [self queryReviewsWithCompletion:^{}];
}

- (void)reloadUserReviewCell {
#ifdef AB
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
#endif
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)markFavoriteWithCompletion:(void (^)(void))completion {
    if (self.favorite) {
        [[CoreDataManager sharedManager] removeFavorite:self.favorite withCompletion:^(BOOL didDelete, NSError *error) {
            if (didDelete) {
                self.favorite = nil;
            }
            completion();
        }];
    } else {
        [[CoreDataManager sharedManager] addFavorite:self.recipe withCompletion:^(BOOL didSave, NSError *error) {
            if (didSave) {
                self.favorite = [[CoreDataManager sharedManager] getFavoriteById:self.recipe.uuid];
            }
            completion();
        }];
        
        
        IPAAnalyticsEvent *event = [IPAAnalyticsEvent eventWithName:AnalyticsFavorited];
        [event setValue:[NSString stringWithFormat:@"%@", self.recipe[@"name"]]
           forAttribute:AnalyticsNameAttribute];
        [[IPAAnalyticsManager sharedInstance] reportEvent:event];
    }
}

- (IBAction)addNote:(id)sender {
    AddNoteViewController *vc = [[AddNoteViewController alloc] initForEntity:self.recipe withNote:self.note];
    [self.navigationController showViewController:vc sender:self];
}

- (void)queryReviewsWithCompletion:(void(^)(void))completion {
    // Query for reviews
    [[[ReviewManager alloc] init] getReviewsForParentObjectID:self.recipe.uuid
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
                }
                
                // Remove the user's own review from the list of reviews since it will always be displayed at the top.
                NSMutableArray *mutableReviews = [self.reviews mutableCopy];
                [mutableReviews removeObject:self.userReview];
                self.reviews = [mutableReviews copy];
            }
        }];
        
        // Calculate star average for reviews.
        double total = 0.0;
        for (Review *r in reviews) {
            total += [r.starValue doubleValue];
        }
        
        NSLog(@"total = %.1f, count = %lu, average = %.2f", total, reviews.count, total/(double)reviews.count);
        
        // Call delegate for review average
        if ([self respondsToSelector:@selector(reviewProcessingDidFinishWithRatingAverage:)]) {
            [self reviewProcessingDidFinishWithRatingAverage:total/(double)reviews.count];
        }
        
        completion();
    }];
}

@end
