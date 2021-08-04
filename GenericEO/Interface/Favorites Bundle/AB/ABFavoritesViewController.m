////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABFavoritesViewController.m
/// @author     Lynette Sesodia
/// @date       5/20/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ABFavoritesViewController.h"
#import "OilViewController.h"
#import "ABOilTableViewCell.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kOilCell @"ABOilTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ABFavoritesViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/// Segmented control to switch between favorite types.
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ABFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.backButton.tintColor = [UIColor targetAccentColor];
    self.addButton.tintColor = [UIColor targetAccentColor];
    
    // Configure segmented control
    [self.segmentedControl setTitle:NSLocalizedString(@"Oil", nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"Recipe", nil) forSegmentAtIndex:1];
    [self.segmentedControl setTitle:NSLocalizedString(@"Guide", nil) forSegmentAtIndex:2];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    // Configure table view
    [self.tableView registerNib:[UINib nibWithNibName:kCell bundle:nil] forCellReuseIdentifier:kCell];
    [self.tableView registerNib:[UINib nibWithNibName:kTitleCell bundle:nil] forCellReuseIdentifier:kTitleCell];
    [self.tableView registerNib:[UINib nibWithNibName:kOilCell bundle:nil] forCellReuseIdentifier:kOilCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 51.0;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new]; // A little trick for removing the cell separators.
}

#pragma mark Data

- (void)refreshData {
    [super refreshData];
}

- (NSArray *)arrayForSegmentedControlIndex:(NSInteger)index {
    switch (index) {
        case 0: // Oils
            return self.favoriteOils;
            break;
            
        case 1:
            return self.favoriteRecipes;
            break;
            
        default:
            return self.favoriteGuides;
            break;
    }
}

#pragma mark Actions

- (void)segmentedControlValueDidChange:(UISegmentedControl *)sender {
    [self.tableView reloadData];
}

- (IBAction)add:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // Single Oils
            [self showAddOptionsForType:EODataTypeSearchSingle];
            break;
            
        case 1:
            [self showAddOptionsForType:EODataTypeSearchRecipe];
            break;
            
        default:
            [self showAddOptionsForType:EODataTypeSearchGuide];
            break;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Favorites *fav;
    
    // Pop loading indicator
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: { // Oils
            fav = self.favoriteOils[indexPath.row];
            
            // Query for object from parse
            [[NetworkManager sharedManager] queryProductsForKey:@"uuid"
                                                     withValues:@[fav.uuid]
                                                 withCompletion:^(NSArray<PFOil *> *objects, NSError *error) {
                                                     [hud hideAnimated:YES];
                                                     
                                                     // Display object view controller
                                                     if (objects.count > 0) {
#ifdef GENERIC
                                                         PFOil *oil = (PFOil *)[objects firstObject];
                                                         
                                                         OilViewController *vc = [[OilViewController alloc] initWithOil:oil andSources:nil];
#elif DOTERRA
                                                         PFDoterraOil *oil = (PFDoterraOil *)[objects firstObject];
                                                         OilViewController *vc = [[OilViewController alloc] initWithDoterraOil:oil];
#elif YOUNGLIVING
                                                         PFYoungLivingOil *oil = (PFYoungLivingOil *)[objects firstObject];
                                                         OilViewController *vc = [[OilViewController alloc] initWithYoungLivingOil:oil];
#endif
                                                         [self.navigationController showViewController:vc sender:self];
                                                     }
                                                 }];
        } break;
            
        case 1: { // Recipes
            fav = self.favoriteRecipes[indexPath.row];
            
            // Query for object from parse
            [[NetworkManager sharedManager] queryRecipesWithUUIDs:@[fav.uuid] withCompletion:^(NSArray<PFRecipe *> *objects,
                                                                                               NSError *error) {
                [hud hideAnimated:YES];
                
                // Display object view controller
                if (objects.count > 0) {
                    PFRecipe *recipe = [objects firstObject];
                    RecipeViewController *vc = [[RecipeViewController alloc] initWithRecipe:recipe];
                    [self.navigationController showViewController:vc sender:self];
                }
            }];
        } break;
            
        default: { // Guide
            fav = self.favoriteGuides[indexPath.row];
            
            // Query for object from parse
            [[NetworkManager sharedManager] queryByClass:ParseClassNameUsageGuide forKey:@"uuid" withValues:@[fav.uuid] withCompletion:^(NSArray<PFObject *> *objects, NSError *error) {
                [hud hideAnimated:YES];
                
                // Display object view controller
                if (objects.count > 0) {
                    PFObject *guide = [objects firstObject];
                    GuideViewController *vc = [[GuideViewController alloc] initWithObject:guide];
                    [self.navigationController showViewController:vc sender:self];
                }
            }];
        } break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *array = [self arrayForSegmentedControlIndex:self.segmentedControl.selectedSegmentIndex];
        Favorites *fav = array[indexPath.row];
        [[CoreDataManager sharedManager] removeFavorite:fav withCompletion:^(BOOL didDelete, NSError *error) {
            [self refreshData];
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self arrayForSegmentedControlIndex:self.segmentedControl.selectedSegmentIndex];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleCell];
    NSArray *array = [self arrayForSegmentedControlIndex:self.segmentedControl.selectedSegmentIndex];
    Favorites *fav = array[indexPath.row];
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: {
            ABOilTableViewCell *oilCell = [tableView dequeueReusableCellWithIdentifier:kOilCell];
            oilCell.titleLabel.text = fav.name.capitalizedString;
            
            // Get oil object to populate
            [[NetworkManager sharedManager] queryProductsForKey:@"uuid"
                                                     withValues:@[fav.uuid]
                                                 withCompletion:^(NSArray<PFOil *> *objects, NSError *error) {
                
#ifdef DOTERRA
                PFDoterraOil *object = (PFDoterraOil *)[objects firstObject];
                oilCell.iconImageView.backgroundColor = [UIColor colorWithHexString:object.color];
                if ([object.type containsString:@"RollOn"]) {
                    oilCell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra-touch"];
                } else {
                    oilCell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
                }
                
#elif YOUNGLIVING
                PFYoungLivingOil *object = (PFYoungLivingOil *)[objects firstObject];
                oilCell.iconImageView.backgroundColor = [UIColor colorWithHexString:object.color];
                if ([object[@"type"] isEqualToString:@"Oil-Light"]) {
                    oilCell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-light"];
                } else if ([object[@"type"] isEqualToString:@"Roll-On"]) {
                    oilCell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-rollon"];
                } else {
                    oilCell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving"];
                }
#endif
                
            }];
            
            return oilCell;
        } break;
            
        default:
            cell.titleLabel.text = fav.name.capitalizedString;
            return cell;
            break;
    }
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // Oils
            return [UIImage imageNamed:@""];
            break;
            
        case 1: // Recipes
            return [UIImage imageNamed:@""];
            break;
            
        default: // Guide
            return [UIImage imageNamed:@""];
            break;
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableAttributedString *str;
    NSString *first, *last;
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // Oils
            first = NSLocalizedString(@"No Favorites", nil).uppercaseString;
            last = NSLocalizedString(@"Favorite an oil to see it here.", nil);
            break;
            
        case 1: // Recipes
            first = NSLocalizedString(@"No Favorites", nil).uppercaseString;
            last = NSLocalizedString(@"Favorite any recipe to see it here.", nil);
            break;
            
        default: // Guide
            first = NSLocalizedString(@"No Favorites", nil).uppercaseString;
            last = NSLocalizedString(@"Favorite a usage guide ailment to see it here.", nil);
            break;
    }
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    // Create attributed string
    NSString *temp = [NSString stringWithFormat:@"%@\n%@", first, last];
    str = [[NSMutableAttributedString alloc] initWithString:temp attributes:attributes];
    
    // Add string-specific attributes
    NSRange r1 = NSMakeRange(0, first.length);
    NSRange r2 = NSMakeRange(first.length, str.length-first.length);
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:17.0] range:r1];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0] range:r2];
    
    return str;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -60.0;
}

#pragma mark - DZNEmptySetDelegate

/**
 Determines if empty data set should allow user interactions.
 */
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return NO;
}

@end
