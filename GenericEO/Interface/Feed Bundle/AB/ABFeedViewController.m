////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABFeedViewController.m
/// @author     Lynette Sesodia
/// @date       5/27/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ABFeedViewController.h"
#import "Constants.h"

#import "FeedManager.h"

#import "MBProgressHUD.h"
#import "ABSmallIconTableViewCell.h"
#import "ABRecipeOfDayTableViewCell.h"
#import "ABOilOfDayTableViewCell.h"

#import "InventoryViewController.h"
#import "FavoritesViewController.h"
#import "NotesViewController.h"
#import "UserProfileViewController.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kIconCell @"ABSmallIconTableViewCell"
#define kImageOfDayCell @"ABRecipeOfDayTableViewCell"
#define kOilOfDayCell @"ABOilOfDayTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ABFeedViewController () <UITableViewDelegate, UITableViewDataSource>

/// Button to navigate to the user profile view controller.
@property (nonatomic, strong) IBOutlet UIButton *profileButton;

/// Title label for the controller.
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Table view for the controller
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/// Progress indicator
@property (nonatomic, strong) MBProgressHUD *progressHUD;

/// Oil object for oil of the day.
@property (nonatomic, strong) DailyFeed *dailyFeed;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ABFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = NSLocalizedString(@"Aromabyte", nil);
    self.titleLabel.font = [UIFont brandFont];
    self.titleLabel.textColor = [UIColor targetAccentColor];
    
    // Get oil and recipe of the day objects
    [self getDailyObjects];
    
    // Configure table view
    [self.tableView registerNib:[UINib nibWithNibName:kIconCell bundle:nil] forCellReuseIdentifier:kIconCell];
    [self.tableView registerNib:[UINib nibWithNibName:kImageOfDayCell bundle:nil] forCellReuseIdentifier:kImageOfDayCell];
    [self.tableView registerNib:[UINib nibWithNibName:kOilOfDayCell bundle:nil] forCellReuseIdentifier:kOilOfDayCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)getDailyObjects {
    
    FeedManager *manager = [[FeedManager alloc] init];
    [manager getDailyFeedObjectWithCompletion:^(DailyFeed *dailyObj, NSError *error) {
        self.dailyFeed = dailyObj;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
}

#pragma mark - Actions

- (IBAction)showProfile:(id)sender {
    UserManager *userManager = [[UserManager alloc] init];
    [userManager getCurrentUserWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {
        if (!error && user != nil) {
            UserProfileViewController *vc = [[UserProfileViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.navigationBar.hidden = YES;
            [self presentViewController:nav animated:YES completion:^{}];
        } else {
            LoginViewController *vc = [[LoginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.navigationBar.hidden = YES;
            [self presentViewController:nav animated:YES completion:^{}];
        }
    }];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0: { // Recipe of the day
            [self shareRecipe];
        } break;
            
        case 1: { // Oil of the day
#if defined (DOTERRA)
            PFDoterraOil *oil = (PFDoterraOil *)self.dailyFeed.oil;
            if (oil != nil) {
                OilViewController *vc = [[OilViewController alloc] initWithDoterraOil:oil];
                [self.navigationController showViewController:vc sender:self];
            }
#else
            PFYoungLivingOil *oil = (PFYoungLivingOil *)self.dailyFeed.oil;
            if (oil != nil) {
                OilViewController *vc = [[OilViewController alloc] initWithYoungLivingOil:oil];
                [self.navigationController showViewController:vc sender:self];
            }
#endif
        } break;
            
        case 2: {
            switch (indexPath.row) {
                case 0: { // Inventory
                    InventoryViewController *vc = [[InventoryViewController alloc] initForTarget];
                    [self.navigationController showViewController:vc sender:self];
                } break;
                    
                case 1: { // Favorites
                    FavoritesViewController *vc = [[FavoritesViewController alloc] initForTarget];
                    [self.navigationController showViewController:vc sender:self];
                } break;
                
                case 2: { // Notes
                    NotesViewController *vc = [[NotesViewController alloc] initForTarget];
                    [self.navigationController showViewController:vc sender:self];
                } break;
            }
        } break;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 2:
            return 3;
            break;
            
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: // Blend of day
            return UITableViewAutomaticDimension;
            break;
            
        case 1: // Oil of day
            return 100;
            break;
            
        default: // Inventory/Favorites/Notes
            return 51.0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"Diffuser Blend of the Day", nil);
            break;
            
        case 1:
            return NSLocalizedString(@"Oil of the Day", nil);
            break;
            
        default:
            return NSLocalizedString(@"Navigation", nil);
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ABSmallIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIconCell];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor systemGroupedBackgroundColor];
    
    switch (indexPath.section) {
        case 0: { // Recipe of day
            ABRecipeOfDayTableViewCell *dayCell = [tableView dequeueReusableCellWithIdentifier:kImageOfDayCell];
            dayCell.backgroundColor = [UIColor systemGroupedBackgroundColor];
            
            dayCell.largeImage.image = [self.dailyFeed blendImage];
            dayCell.descriptionLabel.text = self.dailyFeed.blendImageDescription;
            return dayCell;
        } break;
            
        case 1: { // Oil of day
            ABOilOfDayTableViewCell *oilCell = [tableView dequeueReusableCellWithIdentifier:kOilOfDayCell];
            oilCell.backgroundColor = [UIColor systemGroupedBackgroundColor];
            
            oilCell.oilNameLabel.text = self.dailyFeed.oil.name;
            oilCell.oilDescriptionLabel.text = self.dailyFeed.oil.summaryDescription;
            oilCell.oilIconImageView.layer.cornerRadius = oilCell.oilIconImageView.frame.size.height/2;
            oilCell.oilIconImageView.layer.masksToBounds = YES;
            
#ifdef DOTERRA
            if ([self.dailyFeed.oil[@"type"] containsString:@"Oil"]) {
                oilCell.oilIconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
            } else if ([self.dailyFeed.oil[@"type"] containsString:@"RollOn"]) {
                oilCell.oilIconImageView.image = [UIImage imageNamed:@"bottle-doterra-touch"];
            } else {
                oilCell.oilIconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
            }
#elif YOUNGLIVING
            if ([self.dailyFeed.oil[@"type"] isEqualToString:@"Oil-Light"]) {
                oilCell.oilIconImageView.image = [UIImage imageNamed:@"bottle-youngliving-light"];
            } else if ([self.dailyFeed.oil[@"type"] isEqualToString:@"Roll-On"]) {
                oilCell.oilIconImageView.image = [UIImage imageNamed:@"bottle-youngliving-rollon"];
            } else {
                oilCell.oilIconImageView.image = [UIImage imageNamed:@"bottle-youngliving"];
            }
#endif
            
            oilCell.oilIconImageView.backgroundColor = [UIColor colorWithHexString:self.dailyFeed.oil[@"color"]];
            oilCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return oilCell;
        } break;
            
        case 2: {
            switch (indexPath.row) {
                case 0: // Inventory
                    cell.iconImageView.image = [UIImage imageNamed:@"line.icon.list"];
                    cell.titleLabel.text = NSLocalizedString(@"Inventory", nil);
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                    
                case 1: //  Favorites
                    cell.iconImageView.image = [UIImage imageNamed:@"line.icon.heart"];
                    cell.titleLabel.text = NSLocalizedString(@"Favorites", nil);
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                    
                case 2: // Notes
                    cell.iconImageView.image = [UIImage imageNamed:@"empty.icon.note"];
                    cell.titleLabel.text = NSLocalizedString(@"Notes", nil);
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                    
                default:
                    break;
            }
        }
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark Social Sharing

- (void)shareRecipe {
    
    if (self.dailyFeed.blendImageURLString != nil) {
        // Get image data from daily object to share
        UIImage *shareImage = [self.dailyFeed blendImage];
        NSString *shareText = NSLocalizedString(@"Check out this diffuser blend I found on Aromabyte! #BlendsByAromabyte", nil);
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[shareText, shareImage]
                                                                                 applicationActivities:nil];
        
        NSArray *excludedActivities = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo];
        activityVC.excludedActivityTypes = excludedActivities;
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

@end
