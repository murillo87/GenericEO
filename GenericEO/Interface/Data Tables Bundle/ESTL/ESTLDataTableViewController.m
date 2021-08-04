////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ESTLDataTableViewController.m
/// @author     Lynette Sesodia
/// @date       4/30/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ESTLDataTableViewController.h"

#import "TitleTableViewCell.h"
#import "MyOilCell.h"
#import "GeneralOilTableViewCell.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kTitleCell @"TitleTableViewCell"
#define kMyOilCell @"MyOilCell"
#define kGeneralOilCell @"GeneralOilTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ESTLDataTableViewController () <UITableViewDelegate, UITableViewDataSource>

#pragma mark - Interface Elements

/// Top color view.
@property (nonatomic, strong) IBOutlet UIView *topColorView;

/// Main view containing the table view.
@property (nonatomic, strong) IBOutlet UIView *mainView;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------


@implementation ESTLDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    BOOL isSearch = YES;
    
    switch (self.type) {
        case EODataTypeUsageGuide:
            isSearch = NO;
        case EODataTypeSearchGuide:
            self.titleLabel.text = @"Usage Guide";
            break;
            
        case EODataTypeApplicationCharts:
            isSearch = NO;
            self.titleLabel.text = @"Charts";
            break;
            
        case EODataTypeSingleOil:
            isSearch = NO;
        case EODataTypeSearchSingle:
            self.titleLabel.text = @"Oils";
            break;
            
        case EODataTypeBlendedOil:
            isSearch = NO;
        case EODataTypeSearchBlend:
            self.titleLabel.text = @"Oil Blends";
            break;
            
        case EODataTypeRecipe:
            isSearch = NO;
        case EODataTypeSearchRecipe:
            self.titleLabel.text = @"Recipes";
            break;
            
        default:
            break;
    }
    
    if (!isSearch) {
        self.backButton.hidden = YES;
    }
    
    // Configure title label
    self.titleLabel.font = [UIFont headerFont];
    
    // Configure views
    UIColor *accentColor = [UIColor colorForType:self.type];
    self.topColorView.backgroundColor = accentColor;
    self.mainView.layer.cornerRadius = 22.0;
    self.mainView.layer.masksToBounds = YES;
    
    // Configure table view
    [self.tableView registerNib:[UINib nibWithNibName:kTitleCell bundle:nil] forCellReuseIdentifier:kTitleCell];
    [self.tableView registerNib:[UINib nibWithNibName:kMyOilCell bundle:nil] forCellReuseIdentifier:kMyOilCell];
    [self.tableView registerNib:[UINib nibWithNibName:kGeneralOilCell bundle:nil] forCellReuseIdentifier:kGeneralOilCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    
    // Configure search bar
    self.searchBar.delegate = self;
    self.searchBar.layer.borderColor = accentColor.CGColor;
    self.searchBar.layer.borderWidth = 1.0;
    self.searchBar.barTintColor = accentColor;
    
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

#pragma mark - UITableView Delegate

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
            OilViewController *vc = [[OilViewController alloc] initWithOil:oil andSources:sourceObj];
            
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

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.isActiveSearch) ? 1 : self.objectsDict.allKeys.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.isActiveSearch) {
        return nil;
    } else {
        NSArray *keys = [self.objectsDict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        return keys[section];
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
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return titleCell;
        } break;
            
        case EODataTypeApplicationCharts : {
            TitleTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kTitleCell];
            titleCell.titleLabel.text = [self camelCaseStringFromString:[object valueForKey:@"name"]];
            titleCell.titleLabel.textColor = [UIColor darkGrayColor];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return titleCell;
        } break;
            
        case EODataTypeRecipe:
        case EODataTypeSearchRecipe: {
            TitleTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kTitleCell];
            titleCell.titleLabel.text = [self camelCaseStringFromString:[object valueForKey:@"name"]];
            titleCell.titleLabel.textColor = [UIColor darkGrayColor];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return titleCell;
        } break;
            
        default: { // Oil Cells
            GeneralOilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGeneralOilCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = [object valueForKey:@"name"];
            cell.titleLabel.textColor = [UIColor darkGrayColor];
        
            cell.brandImageView1.image = nil;
            cell.brandImageView2.image = nil;
            cell.brandImageView3.image = nil;
            
#ifdef GENERIC
            NSString *imgStr = [NSString stringWithFormat:@"%@.png", object[@"uuid"]];
            cell.iconImageView.image = [UIImage imageNamed:imgStr];
            
            // Determine sources available
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@", object[@"uuid"]];
            NSArray *sources = [self.oilSourceObjects filteredArrayUsingPredicate:predicate];
            
            if (sources != nil && sources.count > 0) {
                PFObject *sourceObj = [sources firstObject];
                NSArray *brands = sourceObj[@"brands"];
                
                // Loop through brands and display logo on cell
                if ([brands containsObject:@"doterra"]) {
                    cell.brandImageView1.image = [UIImage imageNamed:@"logo-dt"];
                }
                
                if ([brands containsObject:@"youngliving"]) {
                    cell.brandImageView2.image = [UIImage imageNamed:@"logo-yl"];
                }
                
                if ([brands containsObject:@"rockymountain"]) {
                    cell.brandImageView3.image = [UIImage imageNamed:@"logo-rm"];
                }
            }
            
#else
            // Display if oil is a single oil or blend
            if ([object[@"type"] containsString:@"single"]) {
                cell.brandImageView1.image = [UIImage imageNamed:@"logo-single"];
            } else {
                cell.brandImageView1.image = [UIImage imageNamed:@"logo-blend"];
            }
#endif
            
#if DOTERRA
            if ([object[@"type"] containsString:@"Oil"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
            } else if ([object[@"type"] containsString:@"RollOn"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra-touch"];
            } else {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
            }
            
            cell.iconImageView.backgroundColor = [UIColor colorWithHexString:object[@"color"]];
#elif YOUNGLIVING
            if ([object[@"type"] isEqualToString:@"Oil-Light"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-light"];
            } else if ([object[@"type"] isEqualToString:@"Roll-On"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-rollon"];
            } else {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving"];
            }
            
            cell.iconImageView.backgroundColor = [UIColor colorWithHexString:object[@"color"]];
#endif
            
            return cell;
        } break;
    }
}

@end
