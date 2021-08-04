////////////////////////////////////////////////////////////////////////////////
//  Essential Oils
/// @file       RecipesTableViewController.m
/// @author     Lynette Sesodia
/// @date       5/22/18
//
//  Copyright © 2018 Cloforce LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "RecipesTableViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "LUNSegmentedControl.h"

#import "RecipesListCollectionCell.h"
#import "RecipesListTableViewCell.h"
#import "GuideTableViewCell.h"
#import "TitleSubtitleImageTableViewCell.h"

#import "RecipeViewController.h"

#import "NetworkManager.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

#define kRed [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1.0]
#define kYellow [UIColor colorWithRed:241/255.0 green:196/255.0 blue:15/255.0 alpha:1.0]
#define kGreen [UIColor colorWithRed:39/255.0 green:174/255.0 blue:96/255.0 alpha:1.0]
#define kDarkBlue [UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1.0]

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kRecipesListCell @"RecipesListTableViewCell"
#define kRecipesListCollectionCell @"RecipesListCollectionCell"
#define kGuideCell @"EOGuideTableViewCell"
#define kTitleSubtileImageCell @"TitleSubtitleImageTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@interface RecipesTableViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,
                                          LUNSegmentedControlDelegate, LUNSegmentedControlDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

/// Tableview displaying data queried from parse.
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/// CollectionView displaying data queried from parse.
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

/// Search bar used to search through table view data.
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

/// Top space constraint for the search bar.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *searchBarTopSpaceConstraint;

/// Optional segmented button to filter the tableview contents.
@property (nonatomic, strong) IBOutlet LUNSegmentedControl *tableViewFilterSegmentedControl;

/// Height constraint for the segmented button.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tableViewFilterSegmentedButtonHeightConstraint;

/// Array of all objects queried from parse
@property (nonatomic, strong) NSArray *allObjects;

/// Objects displayed in table view
@property (nonatomic, strong) NSDictionary *objectsDict;

/// Objects displayed in table view during search
@property (nonatomic, strong) NSArray *searchObjects;

/// Boolean value indicating if a search is active
@property (nonatomic) BOOL isActiveSearch;

/// Dictionary of filter options for the tableview segmented button.
@property (nonatomic, strong) NSDictionary *filterOptions;

/// Boolean value indicating if a filter is active
@property (nonatomic) BOOL isActiveFilter;

/// Objects displayed in tableview during filter.
@property (nonatomic, strong) NSArray *filterObjects;

@end

@implementation RecipesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Recipes";
    
    [self.collectionView registerNib:[UINib nibWithNibName:kRecipesListCollectionCell bundle:nil] forCellWithReuseIdentifier:kRecipesListCollectionCell];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 0.0;
    NSInteger numberOfItemsPerRow = 3;
    CGFloat size = ([UIScreen mainScreen].bounds.size.width - (margin*(numberOfItemsPerRow+1)))/numberOfItemsPerRow;
    layout.itemSize = CGSizeMake(size, size);
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerNib:[UINib nibWithNibName:kGuideCell bundle:nil] forCellReuseIdentifier:kGuideCell];
    [self.tableView registerNib:[UINib nibWithNibName:kRecipesListCell bundle:nil] forCellReuseIdentifier:kRecipesListCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 208;
    
    self.searchBar.delegate = self;

    self.objectsDict = [[NSMutableDictionary alloc] init];
    
    
    
    self.filterOptions = @{@"Home":@"h",
                           @"Diffusion":@"d",
                           @"Cooking":@"c",
                           @"Beauty":@"b",
                           };
    
    self.tableViewFilterSegmentedControl.delegate = self;
    self.tableViewFilterSegmentedControl.dataSource = self;
    self.tableViewFilterSegmentedControl.tintColor = kGreen;
    self.tableViewFilterSegmentedControl.textColor = [UIColor darkGrayColor];

    [self queryParseWithCompletion:^{}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)configureHeaderBar {
    // Modify the top space constraint if the device is an iPhoneX
    CGFloat delta = (UIScreen.mainScreen.bounds.size.height == iPhoneXHeight) ? iPhoneXHeaderBarDelta : 0;
    self.searchBarTopSpaceConstraint.constant = DefaultHeaderBarHeight + delta;
}

#pragma mark - LUNSegmentedControlDatasource

- (NSInteger)numberOfStatesInSegmentedControl:(LUNSegmentedControl *)segmentedControl {
    return self.filterOptions.allKeys.count;
}

- (NSString *)segmentedControl:(LUNSegmentedControl *)segmentedControl titleForStateAtIndex:(NSInteger)index {
    NSArray *titles = [self.filterOptions.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return titles[index];
}

#pragma mark - Helpers

- (void)queryParseWithCompletion:(void(^)(void))completion {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [[NetworkManager sharedManager] queryByType:EODataTypeRecipe withCompletion:^(NSArray<PFObject *> *objects, NSError *error) {
        [hud hideAnimated:YES];
        if (!error) {
            self.allObjects = objects;
            self.objectsDict = [self dictionaryBySeparatingArrayAlphabetically:objects byKey:@"name"];
            
            completion();
        }
    }];
}

/**
 Sorts array into a dictionary with keys of the first character in the name.
 @param array Alphabetically sorted array of PFObjects
 @param key String key used to sort the objects by. This key should never have a nil value in any PFObject.
 */
- (NSMutableDictionary *)dictionaryBySeparatingArrayAlphabetically:(NSArray *)array byKey:(NSString *)key {
    // Do nothing if empty array
    if (array.count == 0) {
        return nil;
    }
    
    // Create final dictionary, temp array, and starting char to check for
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSString *c = [[array.firstObject valueForKey:key] substringToIndex:1];
    
    for (PFObject *object in array) {
        // If the starting chars match, add object to temp array
        if ([[[object valueForKey:key] substringToIndex:1] isEqualToString:c]) {
            [temp addObject:object];
        } else {
            // If the starting strings do not match, save temp array for the key and reset
            [dictionary setObject:temp forKey:c];
            
            temp = [[NSMutableArray alloc] initWithObjects:object, nil];
            c = [[object valueForKey:key] substringToIndex:1];
        }
        
        // Add last array to dictionary
        if ([object isEqual:[array lastObject]]) {
            [dictionary setObject:temp forKey:c];
        }
    }
    
    return dictionary;
}

#pragma mark - CLFSegmentedButtonDelegate

- (void)buttonSelectedAtIndex:(NSInteger)index {
    self.isActiveFilter = YES;
    
    // Get the key to filter array by
    NSArray *allKeys = [self.filterOptions.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *key = [NSString stringWithFormat:@"-%@-",self.filterOptions[allKeys[index]]];
    
    // Filter array
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier contains[c] %@", key];
    self.filterObjects = [self.allObjects filteredArrayUsingPredicate:predicate];
    
    //[self.tableView reloadData];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array;
    
    if (self.isActiveSearch) {
        array = self.searchObjects;
    } else if (self.isActiveFilter) {
        array = self.filterObjects;
    } else {
        NSArray *keys = [self.objectsDict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        array = [self.objectsDict valueForKey:keys[indexPath.section]];
    }
    
    RecipeViewController *vc = [[RecipeViewController alloc] initWithRecipe:array[indexPath.item]];
    [self.navigationController showViewController:vc sender:self];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array;
    
    if (self.isActiveSearch) {
        array = self.searchObjects;
    } else if (self.isActiveFilter) {
        array = self.filterObjects;
    } else {
        NSArray *keys = [self.objectsDict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        array = [self.objectsDict valueForKey:keys[indexPath.section]];
    }
    
    RecipeViewController *vc = [[RecipeViewController alloc] initWithRecipe:array[indexPath.row]];
    [self.navigationController showViewController:vc sender:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (self.isActiveSearch || self.isActiveFilter) ? 1 : self.objectsDict.allKeys.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isActiveSearch) {
        return self.searchObjects.count;
    } else if (self.isActiveFilter) {
        return self.filterObjects.count;
    } else {
        NSArray *keys = [self.objectsDict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray *array = [self.objectsDict valueForKey:keys[section]];
        return array.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RecipesListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecipesListCollectionCell forIndexPath:indexPath];
    
    PFObject *object;
    if (self.isActiveSearch) {
        object = self.searchObjects[indexPath.row];
    } else if (self.isActiveFilter) {
        object = self.filterObjects[indexPath.row];
    } else {
        NSArray *keys = [self.objectsDict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray *array = [self.objectsDict valueForKey:keys[indexPath.section]];
        object = array[indexPath.row];
    }
    
    
    cell.nameLabel.text = [object valueForKey:@"name"];
    cell.nameLabel.font = [UIFont titleFont];
    
    NSString *urlString = [object valueForKey:@"pictureURLString"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak RecipesListCollectionCell *weakCell = cell;
    [cell.mainImageView setImageWithURLRequest:request
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           weakCell.mainImageView.image = image;
                                           [weakCell setNeedsLayout];
                                           
                                       } failure:nil];
    return cell;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.isActiveSearch || self.isActiveFilter) ? 1 : self.objectsDict.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isActiveSearch) {
        return self.searchObjects.count;
    } else if (self.isActiveFilter) {
        return self.filterObjects.count;
    } else {
        NSArray *keys = [self.objectsDict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray *array = [self.objectsDict valueForKey:keys[section]];
        return array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipesListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipesListCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PFObject *object;
    if (self.isActiveSearch) {
        object = self.searchObjects[indexPath.row];
    } else if (self.isActiveFilter) {
        object = self.filterObjects[indexPath.row];
    } else {
        NSArray *keys = [self.objectsDict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray *array = [self.objectsDict valueForKey:keys[indexPath.section]];
        object = array[indexPath.row];
    }
    
    
    cell.nameLabel.text = [object valueForKey:@"name"];
    cell.nameLabel.font = [UIFont titleFont];
    
    NSString *urlString = [object valueForKey:@"pictureURLString"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak RecipesListTableViewCell *weakCell = cell;
    [cell.mainImageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakCell.mainImageView.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
    return cell;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.isActiveSearch = YES;
    [self.collectionView reloadData];
    //[self.tableView reloadData];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isActiveSearch = NO;
    } else {
        self.isActiveSearch = YES;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
        
        if (self.isActiveFilter) {
            self.searchObjects = [self.filterObjects filteredArrayUsingPredicate:predicate];
        } else {
            self.searchObjects = [self.allObjects filteredArrayUsingPredicate:predicate];
        }
    }
    [self.collectionView reloadData];
    //[self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isActiveSearch = NO;
}

@end
