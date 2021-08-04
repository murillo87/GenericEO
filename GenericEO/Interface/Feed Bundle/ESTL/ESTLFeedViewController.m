////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ESTLFeedViewController.m
/// @author     Lynette Sesodia
/// @date       6/17/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ESTLFeedViewController.h"

#import "iCarousel.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

#import "FeedTableViewCell.h"
#import "TitleImageTableViewCell.h"
#import "ImageTextCollectionViewCell.h"

#import "Constants.h"
#import "CoreDataManager.h"
#import "FeedManager.h"

#import "FavoritesViewController.h"
#import "NotesViewController.h"
#import "InventoryViewController.h"
#import "UserProfileViewController.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kFeedCell @"FeedTableViewCell"
#define kTitleImgCell @"TitleImageTableViewCell"
#define kImageTextCell @"ImageTextCollectionViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

static CGFloat cellHeight = 44.0;

#ifdef YOUNGLIVING
static NSString * const CDNPrefix = @"https://geofeed2.b-cdn.net/YL-Pinterest-Diffuser-Recipes/";
#else
static NSString * const CDNPrefix = @"https://geofeed2.b-cdn.net/doTERRA-Pintrest-Images/";
#endif
///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ESTLFeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource, iCarouselDataSource, iCarouselDelegate>

/// Top color view.
@property (nonatomic, strong) IBOutlet UIView *topColorView;

/// Label displaying the name controller's object
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/// Button to navigate to the user profile view controller.
@property (nonatomic, strong) IBOutlet UIButton *profileButton;

/// View containing the tableview and segmented control.
@property (nonatomic, strong) IBOutlet UIView *mainView;

/// Main tableview for the controller.
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

/// Height constraint for the tableview.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

/// Progress indicator
@property (nonatomic, strong) MBProgressHUD *progressHUD;

/// Carousel view.
@property (nonatomic, strong) IBOutlet iCarousel *carouselView;

/// Array of carousel objects for the feed images to be displayed in the carousel view.
@property (nonatomic, strong) NSArray<PFObject *> *feedObjects;

/// Array of imageStrings for the feed images in the youngliving feed.
@property (nonatomic, strong) NSMutableArray<NSString *> *YLFeedStrings;

#pragma mark - Unused

/// Array of JSON for the facebook posts to be displayed in the carousel view.
@property (nonatomic, strong) NSArray *carouselJSON;

/// User facing string name of FB page the feed is pulled from.
@property (nonatomic, strong) NSString *fbPageName;

/// Image data for the facebook page's profile picture/
@property (nonatomic, strong) NSDictionary *fbPageProfilePictureJSON;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ESTLFeedViewController

- (id)init {
    self = [super init];
    if (self) {
//        [[FBManager sharedManager] refreshPageInfoWithCompletion:^(NSArray *pageJSON, NSError *error) {
//            self.fbPageName = [pageJSON valueForKey:@"name"];
//            self.fbPageProfilePictureJSON = [pageJSON valueForKey:@"picture"];
//        }];
//
//        [[FBManager sharedManager] refreshFeedWithCompletion:^(NSArray *feedJSON, NSError *error) {
//            self.carouselJSON = feedJSON;
//            [self.carouselView reloadData];
//        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = NSLocalizedString(@"Home", nil);
    self.titleLabel.font = [UIFont headerFont];
    
    // Configure views
    self.topColorView.backgroundColor = [UIColor colorForType:EODataTypeSingleOil];
    self.mainView.layer.cornerRadius = 22.;
    self.mainView.layer.masksToBounds = YES;
    
    // Configure Carousel
    self.carouselView.delegate = self;
    self.carouselView.dataSource = self;
    self.carouselView.type = iCarouselTypeCoverFlow;
    
    // Configure tableview
    [self.collectionView registerNib:[UINib nibWithNibName:kImageTextCell bundle:nil] forCellWithReuseIdentifier:kImageTextCell];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Display HUD
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    [self.progressHUD showAnimated:YES];
    
#ifdef YOUNGLIVING
    /**
     First images start on 2/7/19.
     Display 3 images per day.
     Display the next 9 images from the date.
     */
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 2;
    components.day = 6;
    components.year = 2019;
    NSDate *originalStart = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDate *today = [NSDate date];
    
    // Determine the number of days that have passed since the start date.
    NSInteger daysElapsed = [self daysBetweenDate:originalStart andDate:today];
    
    // Num is daysElapsed * 3 images per day;
    int num = (int)daysElapsed * 3;
    
    // Create fileNames for the next 9 images (3 days worth).
    self.YLFeedStrings = [[NSMutableArray alloc] init];
    for (int i=0; i<9; i++) {
        int idx = num + i;
        if (idx > 483) {
            idx -=483;
        }
        NSString *fileName = [NSString stringWithFormat:@"young_living_diffuser_recipes_%d.jpg", idx];
        [self.YLFeedStrings addObject:fileName];
    }
    
    [self.progressHUD hideAnimated:YES];
    [self.carouselView reloadData];
#else
    FeedManager *manager = [[FeedManager alloc] init];
    [manager queryNewFeedObjectsWithCompletion:^(NSArray<PFObject *> *objects, NSError *error) {
        [self.progressHUD hideAnimated:YES];
        self.feedObjects = objects;
        [self.carouselView reloadData];
    }];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)showProfile:(id)sender {
    UserProfileViewController *vc = [[UserProfileViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:^{}];
}

#pragma mark - iCarouselDelegate

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"Selected carousel index is %ld", (long)index);
    
    // Pop a view to display FB post info

    
}

#pragma mark - iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
#ifdef YOUNGLIVING
    return self.YLFeedStrings.count;
#else
    return self.feedObjects.count;
#endif
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    // Calculate size of carousel view
    // height = screen - navBar - tabBar - tableView;
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width-40;
    CGFloat margin = 4.0;
    
    // Create new view if no view is available for recycling
    if (view == nil) {
        if (carousel.frame.size.height < maxWidth) {
            maxWidth = carousel.frame.size.height - 50;
        }
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxWidth, maxWidth+40)];
        view.contentMode = UIViewContentModeTop;
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, maxWidth, maxWidth)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 1;
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin, maxWidth, maxWidth-margin*2, 40)];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
        label.tag = 2;
        [view addSubview:label];
    }
    
    UIImageView *imgView = [view viewWithTag:1];
    UILabel *descriptionLabel = [view viewWithTag:2];
    
#ifdef YOUNGLIVING
    descriptionLabel.text = @"";
    NSString *fileName = self.YLFeedStrings[index];
    
#else
    PFObject *feedObject = self.feedObjects[index];
    descriptionLabel.text = feedObject[@"caption"];
    
    // Extension swap
    NSString *fileName = feedObject[@"fileName"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
#endif
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", CDNPrefix, fileName];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __weak UIImageView *weakImageView = imgView;
    [weakImageView setImageWithURLRequest:request
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           weakImageView.image = image;
                                           [weakImageView setNeedsLayout];
                                       } failure:nil];
    

    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionSpacing) {
        return value * 1.1;
    }
    return value;
}

- (CGSize)scaleCarouselImageWithWidth:(CGFloat)width andHeight:(CGFloat)height {
    
    CGFloat maxWidth = 280.;
    CGFloat maxHeight = 280.;
    
    // Determine if image is wider or taller
    if (width >= height) {
        double scale = maxWidth / width;
        return CGSizeMake(scale*width, scale*height);
    } else {
        double scale = maxHeight / height;
        return CGSizeMake(scale*width, scale*height);
    }
}

#pragma mark - Helpers

- (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime {
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

#pragma mark - UITableViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.item) {
        case 0: { // Favorites
            FavoritesViewController *vc = [[FavoritesViewController alloc] initForTarget];
            [self.navigationController showViewController:vc sender:self];
        } break;
            
        case 1: { // Inventory
            InventoryViewController *vc = [[InventoryViewController alloc] initForTarget];
            [self.navigationController showViewController:vc sender:self];
        } break;
            
        case 2: { // My Notes
            NotesViewController *vc = [[NotesViewController alloc] initForTarget];
            [self.navigationController showViewController:vc sender:self];
        } break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ImageTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageTextCell forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0: // Favorites
            cell.titleLabel.text = NSLocalizedString(@"Favorites", nil);
            cell.iconImageView.image = [UIImage imageNamed:@"icon-favorite"];
            break;
            
        case 1: // Inventory
            cell.titleLabel.text = NSLocalizedString(@"Inventory", nil);
            cell.iconImageView.image = [UIImage imageNamed:@"icon-inventory"];
            break;
            
        case 2: // Notes
            cell.titleLabel.text = NSLocalizedString(@"My Notes", nil);
            cell.iconImageView.image = [UIImage imageNamed:@"icon-notes"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

@end
