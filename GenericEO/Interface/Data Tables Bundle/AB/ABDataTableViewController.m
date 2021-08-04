////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABDataTableViewController.m
/// @author     Lynette Sesodia
/// @date       4/30/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ABDataTableViewController.h"
#import "TitleTableViewCell.h"
#import "MyOilCell.h"
#import "ABSmallIconTableViewCell.h"
#import "ABOilTableViewCell.h"

#import "MenuCollectionView.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kTitleCell @"TitleTableViewCell"
#define kMyOilCell @"MyOilCell"
#define kOilCell @"ABOilTableViewCell"
#define kSmallIconCell @"ABSmallIconTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ABDataTableViewController () <UITableViewDataSource, UITableViewDelegate, MenuCollectionViewDelegate>

#pragma mark - Interface Elements

/// Top view displaying image.
@property (nonatomic, strong) IBOutlet UIImageView *topBackgroundImageView;

/// Filter menu collection view.
@property (nonatomic, strong) IBOutlet MenuCollectionView *filterMenuView;

/// Height constraint for the filter menu view.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *filterMenuViewHeightConstraint;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------


@implementation ABDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
       
    BOOL isSearch = (self.type == EODataTypeSearchGuide || self.type == EODataTypeSearchRecipe ||
                     self.type == EODataTypeSearchSingle || self.type == EODataTypeSearchBlend) ? YES : NO;
    self.backButton.hidden = (isSearch) ? NO : YES;
    
    self.titleLabel.font = [UIFont headerFont];
    
    switch (self.type) {
        case EODataTypeUsageGuide:
        case EODataTypeSearchGuide:
            self.titleLabel.text = @"Usage Guide";
            break;
            
        case EODataTypeApplicationCharts:
            self.titleLabel.text = @"Charts";
            break;
            
        case EODataTypeSingleOil:
        case EODataTypeSearchSingle:
            self.titleLabel.text = @"Oils";
            break;
            
        case EODataTypeBlendedOil:
        case EODataTypeSearchBlend:
            self.titleLabel.text = @"Oil Blends";
            break;
            
        case EODataTypeRecipe:
        case EODataTypeSearchRecipe:
            self.titleLabel.text = @"Recipes";
            break;
            
        default:
            break;
    }
    
    // Configure title label
    self.titleLabel.font = [UIFont headerFont];
        
    [self configureMenu];
    
    // Configure table view
    [self.tableView registerNib:[UINib nibWithNibName:kTitleCell bundle:nil] forCellReuseIdentifier:kTitleCell];
    [self.tableView registerNib:[UINib nibWithNibName:kMyOilCell bundle:nil] forCellReuseIdentifier:kMyOilCell];
    [self.tableView registerNib:[UINib nibWithNibName:kOilCell bundle:nil] forCellReuseIdentifier:kOilCell];
    [self.tableView registerNib:[UINib nibWithNibName:kSmallIconCell bundle:nil] forCellReuseIdentifier:kSmallIconCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.tableView.estimatedRowHeight = 80;
    
    // Configure search bar
    self.searchBar.delegate = self;
    //self.searchBar.layer.borderColor = accentColor.CGColor;
    //self.searchBar.layer.borderWidth = 1.0;
    //self.searchBar.barTintColor = accentColor;
    
    UITextField *txtSearchField;
    if (@available(iOS 13, *)) {
        txtSearchField = self.searchBar.searchTextField;
        txtSearchField.backgroundColor = [UIColor whiteColor];
    } else {
        txtSearchField = [self.searchBar valueForKey:@"_searchField"];
    }
    
    txtSearchField.frame = CGRectMake(8, 10, self.searchBar.frame.size.width-16, 44);
    txtSearchField.layer.cornerRadius = 18.0f;
    txtSearchField.layer.masksToBounds = YES;

    
}

#pragma mark UI

- (void)configureMenu {
    if (self.type != EODataTypeSingleOil && self.type != EODataTypeSearchSingle) {
        self.filterMenuViewHeightConstraint.constant = 0.0;
        
    } else {
        self.filterMenuView.delegate = self;
        [self.filterMenuView setMenuItems:@[@"Single Oils", @"Blends"]];
        self.filterMenuView.tintColor = [UIColor targetAccentColor];
    }
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array;
    
    if (self.isActiveSearch) {
        array = self.searchObjects;
    } else {
        NSArray *keys = [self.objectsDict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        array = [self.objectsDict valueForKey:keys[indexPath.section]];
    }
    
    switch (self.type) {
        case EODataTypeUsageGuide: {
            GuideViewController *vc = [[GuideViewController alloc] initWithObject:array[indexPath.row]];
            [self.navigationController showViewController:vc sender:self];
        } break;
            
        case EODataTypeApplicationCharts: {
            ChartsViewController *vc = [[ChartsViewController alloc] initWithObject:array[indexPath.row]];
            [self.navigationController showViewController:vc sender:self];
        } break;
            
        case EODataTypeRecipe: {
            RecipeViewController *vc = [[RecipeViewController alloc] initWithRecipe:array[indexPath.row]];
            [self.navigationController showViewController:vc sender:self];
        } break;
            
        case EODataTypeSingleOil:
        case EODataTypeBlendedOil:
        case EODataTypeOilSources: {
            
#ifdef GENERIC
            PFOil *oil = (PFOil *)array[indexPath.row];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@", oil.uuid];
            NSArray *sources = [self.oilSourceObjects filteredArrayUsingPredicate:predicate];
            PFObject *sourceObj = [sources firstObject];
            OilViewController *vc = [[OilViewController alloc] initWithOil:oil andSources:sources];
            
#elif DOTERRA
            PFDoterraOil *oil = (PFDoterraOil *)array[indexPath.row];
            OilViewController *vc = [[OilViewController alloc] initWithDoterraOil:oil];
            
#elif YOUNGLIVING
            PFYoungLivingOil *oil = (PFYoungLivingOil *)array[indexPath.row];
            OilViewController *vc = [[OilViewController alloc] initWithYoungLivingOil:oil];
#endif
            
            [self.navigationController showViewController:vc sender:self];
        } break;
            
        default: {
            // Handle all search types returning the objects
            [self.searchDelegate searchControllerDidSelecteObject:array[indexPath.row]];
        } break;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.isActiveSearch) ? 1 : self.objectsDict.allKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isActiveSearch || self.type == EODataTypeApplicationCharts) {
        return 0;
    } else {
        return 33.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isActiveSearch || self.type == EODataTypeApplicationCharts) {
        return nil;
    } else {
        NSArray *keys = [self.objectsDict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 33.0)];
        
        if (self.type == EODataTypeSingleOil || self.type == EODataTypeSearchSingle) {
            view.backgroundColor = [UIColor whiteColor];
        } else {
            view.backgroundColor = [UIColor whiteColor];
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 6, view.frame.size.width-32, 21.0)];
        label.text = keys[section];
        label.font = [UIFont titleFont];
        [view addSubview:label];
        
        return view;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isActiveSearch) {
        return self.searchObjects.count;
    } else {
        NSArray *keys = [self.objectsDict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray *array = [self.objectsDict valueForKey:keys[section]];
        return array.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.type) {
        case EODataTypeSingleOil:
        case EODataTypeSearchSingle:
        case EODataTypeBlendedOil:
        case EODataTypeSearchBlend:
            return 50.0;
            break;
            
        default:
            return UITableViewAutomaticDimension;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *object;
    if (self.isActiveSearch) {
        object = self.searchObjects[indexPath.row];
    } else {
        NSArray *keys = [self.objectsDict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray *array = [self.objectsDict valueForKey:keys[indexPath.section]];
        object = array[indexPath.row];
    }
    
    switch (self.type) {
        case EODataTypeUsageGuide :
        case EODataTypeSearchGuide: {
            TitleTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kTitleCell];
            titleCell.titleLabel.text = [self camelCaseStringFromString:[object valueForKey:@"name"]];
            titleCell.titleLabel.textColor = [UIColor darkGrayColor];
            titleCell.titleLabel.font = [UIFont cellFont];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return titleCell;
        } break;
            
        case EODataTypeApplicationCharts : {
            ABSmallIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSmallIconCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = [self camelCaseStringFromString:[object valueForKey:@"name"]];
            cell.titleLabel.textColor = [UIColor darkGrayColor];
            cell.titleLabel.font = [UIFont cellFont];
            cell.iconImageView.image = [UIImage imageNamed:[object valueForKey:@"icon"]];
            return cell;
        } break;
            
        case EODataTypeRecipe:
        case EODataTypeSearchRecipe: {
            TitleTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kTitleCell];
            titleCell.titleLabel.text = [self camelCaseStringFromString:[object valueForKey:@"name"]];
            titleCell.titleLabel.textColor = [UIColor darkGrayColor];
            titleCell.titleLabel.font = [UIFont cellFont];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return titleCell;
        } break;
            
        default: { // Oil Cells
            ABOilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOilCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = [object valueForKey:@"name"];
            cell.titleLabel.textColor = [UIColor darkGrayColor];
                
#ifdef DOTERRA
            if ([object[@"type"] containsString:@"Oil"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
            } else if ([object[@"type"] containsString:@"RollOn"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra-touch"];
            } else {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
            }
            
#elif YOUNGLIVING
            if ([object[@"type"] isEqualToString:@"Oil-Light"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-light"];
            } else if ([object[@"type"] isEqualToString:@"Roll-On"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-rollon"];
            } else {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving"];
            }
#endif
            
            cell.iconImageView.backgroundColor = [UIColor colorWithHexString:object[@"color"]];
            
            return cell;
        } break;
    }
}

#pragma mark MenuCollectionViewDelegate

- (void)menuCollectionView:(MenuCollectionView *)view didSelectItem:(NSString *)item atIndexPath:(NSIndexPath *)indexPath {
    // Set active filters (only used on oil data type controllers)
    
    if (self.type == EODataTypeSingleOil || self.type == EODataTypeSearchSingle) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        
        self.isActiveSearch = YES;
        
        if (indexPath.item == 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category CONTAINS[cd] %@", @"Single"];
            self.searchObjects = [self.allObjects filteredArrayUsingPredicate:predicate];
        } else {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category CONTAINS[cd] %@", @"Blend"];
            self.searchObjects = [self.allObjects filteredArrayUsingPredicate:predicate];
        }
        
        [self.tableView reloadData];
        [hud hideAnimated:YES];
    }
}

- (void)menuCollectionView:(MenuCollectionView *)view didDeSelectItem:(NSString *)item atIndexPath:(NSIndexPath *)indexPath {
    // Remove filter from active filters (only used on oil data type controllers)
    if (self.type == EODataTypeSingleOil || self.type == EODataTypeSearchSingle) {
        self.isActiveSearch = false;
        self.searchObjects = nil;
        [self.tableView reloadData];
    }
}


@end
