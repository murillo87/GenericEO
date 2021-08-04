////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       UserProfileViewController.m
/// @author     Lynette Sesodia
/// @date       2/19/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "UserProfileViewController.h"
#import "ProfileFieldTableViewCell.h"
#import "UserManager.h"
#import "UIImageView+AFNetworking.h"
#import "UserStatsView.h"
#import "ReviewManager.h"
#import "EditUserProfileViewController.h"
#import "ReviewTableViewCell.h"
#import "MBProgressHUD.h"
#import "WriteReviewViewController.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kReviewCell @"ReviewTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------
@interface UserProfileViewController () <UITableViewDelegate, UITableViewDataSource, ReviewTableViewCellDelegate>

/// Back button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *closeButton;

/// Imageview displaying the users profile image.
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;

/// User stats view for the controller.
@property (nonatomic, strong) IBOutlet UserStatsView *userStatsView;

/// Label displaying the user's public username.
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;

/// Top edit button for the controller.
@property (nonatomic, strong) IBOutlet UIButton *editButton;

/// Tableview displaying user reviews.
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/// The current user to display the profile for.
@property (nonatomic, strong) User *currentUser;

/// Reference to user manager.
@property (nonatomic, strong) UserManager *userManager;

/// Progress indicator for the controller.
@property (nonatomic, strong) MBProgressHUD *progressHUD;

/// The review for the user.
@property (nonatomic, strong) NSArray *userReviews;

@end


@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.progressHUD = [MBProgressHUD HUDForView:self.view];
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    [self.progressHUD showAnimated:YES];
    
    self.closeButton.tintColor = [UIColor targetAccentColor];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.layer.masksToBounds = YES;
    [self.editButton setTitle:NSLocalizedString(@"User Settings", nil) forState:UIControlStateNormal];
    self.editButton.layer.cornerRadius = 5.0;
    //self.editButton.layer.borderColor = [UIColor accentPurple].CGColor;
    //self.editButton.layer.borderWidth = 0.75;
    self.editButton.backgroundColor = [UIColor targetAccentColor];
    self.editButton.tintColor = [UIColor whiteColor];
    self.usernameLabel.font = [UIFont boldTextFont];
    
    [self.tableView registerNib:[UINib nibWithNibName:kReviewCell bundle:nil] forCellReuseIdentifier:kReviewCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.userManager == nil) {
        self.userManager = [[UserManager alloc] init];
    }
    
    [self.userManager getCurrentUserWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {
        if (user != nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentUser = user;
                self.usernameLabel.text = user.username;
                [self reloadProfileImage];
                [self.userStatsView setUser:self.currentUser];
                
                if (self.userReviews == nil) {
                    [self reloadReviews];
                    [self.progressHUD hideAnimated:YES];
                }
            });
        }
    }];
}

- (void)reloadProfileImage {
    
    /**
     To avoid race conditions with caching purges on the CDN, we will first check for locally saved images.
     NSUserDefaults dictionary "profilePic" = {@"image":imgData, @"dateAdded":NSDate}
     Check the date added and if it was added less than 24 hrs ago, use the cached image. If not request the image from the CDN.
     */
    NSDictionary *profileDict = [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultsProfileImageDictionaryKey];
    if (profileDict != nil) {
        NSDate *date = [profileDict valueForKey:@"dateAdded"];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = -1;
        NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
        
        if ([date compare:yesterday] == NSOrderedAscending) {
            // If the date was before yesterday, refresh profile image
            [self requestProfileImageWithCompletion:^(UIImage *image) {}];
        } else {
            // Use the saved image in NSUserDefaults
            NSData *imgData = [profileDict objectForKey:@"image"];
            if (imgData != nil) {
                UIImage *image = [UIImage imageWithData:imgData];
                self.profileImageView.image = image;
            } else {
                self.profileImageView.image = [UIImage imageNamed:@"icon-user"];
            }
        }
    } else {
        [self requestProfileImageWithCompletion:^(UIImage *image) {}];
    }
}

- (void)requestProfileImageWithCompletion:(void (^)(UIImage *image))completion  {
    NSURLRequest *request = [NSURLRequest requestWithURL:[self.userManager getProfileImageURLForUserUUID:self.currentUser.uuid]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
        
    __weak UIImageView *weakImage = self.profileImageView;
    [weakImage setImageWithURLRequest:request
                              placeholderImage:[UIImage imageNamed:@"icon-user"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakImage.image = image;
        [weakImage setNeedsLayout];
        
        if (image != nil) {
            // Update the data in NSUserDefaults
            NSData *imgData = UIImagePNGRepresentation(image);
            NSMutableDictionary *profileDict = [[NSMutableDictionary alloc] init];
            [profileDict setValue:imgData forKey:@"image"];
            [profileDict setValue:[NSDate date] forKey:@"dateAdded"];
            [[NSUserDefaults standardUserDefaults] setObject:profileDict forKey:UserDefaultsProfileImageDictionaryKey];
        }
        completion(image);
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        completion(nil);
    }];
}

- (void)reloadReviews {
    [self.progressHUD showAnimated:YES];
    
    [[[ReviewManager alloc] init] getReviewsForUser:self.currentUser withCompletion:^(NSArray<Review *> * _Nullable reviews, NSError * _Nullable error) {
        [[[ReviewManager alloc] init] getReviewsForUser:self.currentUser withCompletion:^(NSArray<Review *> * _Nullable reviews, NSError * _Nullable error) {
            if (reviews != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.userReviews = reviews;
                    [self.userStatsView setReviewCount:reviews.count];
                    [self.tableView reloadData];
                    [self.progressHUD hideAnimated:YES];
                });
            }
        }];
    }];
}

#pragma mark - IBActions

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)editProfile:(id)sender {
    EditUserProfileViewController *vc = [[EditUserProfileViewController alloc] initForUser:self.currentUser withProfileImage:self.profileImageView.image];
    [self showViewController:vc sender:self];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Allow the user to edit their reviews
    Review *review = self.userReviews[indexPath.row];
    WriteReviewViewController *vc = [[WriteReviewViewController alloc] initForParentObject:nil withExistingReview:review];
    [self.navigationController showViewController:vc sender:self];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userReviews.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"My Reviews", nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReviewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell configureCellForUser:self.currentUser review:self.userReviews[indexPath.row]];
    
    return cell;
}

#pragma mark - ReviewTableViewCellDelegate

- (void)shouldUpvoteReviewForCell:(ReviewTableViewCell *)cell {
    [[[ReviewManager alloc] init] upVoteReview:cell.review withCompletion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.userStatsView setUser:self.currentUser];
        }
    }];
}

- (void)shouldDownvoteReviewForCell:(ReviewTableViewCell *)cell {
    [[[ReviewManager alloc] init] downVoteReview:cell.review withCompletion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.userStatsView setUser:self.currentUser];
        }
    }];
}

@end
