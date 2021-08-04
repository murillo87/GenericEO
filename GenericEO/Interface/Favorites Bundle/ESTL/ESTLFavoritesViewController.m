////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ESTLFavoritesViewController.m
/// @author     Lynette Sesodia
/// @date       5/20/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ESTLFavoritesViewController.h"
#import "LUNSegmentedControl.h"

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

@interface ESTLFavoritesViewController () <UITableViewDelegate, UITableViewDataSource, LUNSegmentedControlDataSource, LUNSegmentedControlDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/// Top color view.
@property (nonatomic, strong) IBOutlet UIView *topColorView;

/// View containing the tableview and segmented control.
@property (nonatomic, strong) IBOutlet UIView *mainView;

/// Segmented control for the tableview.
@property (nonatomic, strong) IBOutlet LUNSegmentedControl *segmentedControl;

/// Label displaying the number of oils favorites.
@property (nonatomic, strong) IBOutlet UILabel *oilsCountLabel;

/// Label displaying the user facing string subtitle for the oils count label.
@property (nonatomic, strong) IBOutlet UILabel *oilsCountSubtitleLabel;

/// Label displaying the number of guide favorites.
@property (nonatomic, strong) IBOutlet UILabel *guideCountLabel;

/// Label displaying the user facing string subtitle for the guide count label.
@property (nonatomic, strong) IBOutlet UILabel *guideCountSubtitleLabel;

/// Label displaying the number of recipe favorites.
@property (nonatomic, strong) IBOutlet UILabel *recipesCountLabel;

/// Label displaying the user facing string subtitle for the recipe count label.
@property (nonatomic, strong) IBOutlet UILabel *recipesCountSubtitleLabel;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ESTLFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure the views
    self.topColorView.backgroundColor = [UIColor colorForType:EODataTypeSingleOil];
    self.mainView.layer.cornerRadius = 22.;
    self.mainView.layer.masksToBounds = YES;
    
    // Segmented Control setup
    self.segmentedControl.selectorViewColor = [UIColor clearColor];
    self.segmentedControl.shadowsEnabled = NO;
    self.segmentedControl.applyCornerRadiusToSelectorView = YES;
    self.segmentedControl.cornerRadius = 22;
    self.segmentedControl.delegate = self;
    self.segmentedControl.dataSource = self;
    
    // Configure table view
    [self.tableView registerNib:[UINib nibWithNibName:kCell bundle:nil] forCellReuseIdentifier:kCell];
    [self.tableView registerNib:[UINib nibWithNibName:kTitleCell bundle:nil] forCellReuseIdentifier:kTitleCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 51.0;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

#pragma mark Data

- (void)refreshData {
    [super refreshData];
    
    self.oilsCountLabel.text = [NSString stringWithFormat:@"%lu", self.favoriteOils.count];
    self.guideCountLabel.text = [NSString stringWithFormat:@"%lu", self.favoriteGuides.count];
    self.recipesCountLabel.text = [NSString stringWithFormat:@"%lu", self.favoriteRecipes.count];
}

- (NSArray *)arrayForSegmentedControlIndex:(NSInteger)index {
    switch (index) {
        case 0: // Oils
            return self.favoriteOils;
            break;
            
        case 1:
            return self.favoriteGuides;
            break;
            
        default:
            return self.favoriteRecipes;
            break;
    }
}

#pragma mark IBActions

- (IBAction)add:(id)sender {
    switch (self.segmentedControl.currentState) {
        case 0: // Single Oils
            [self showAddOptionsForType:EODataTypeSearchSingle];
            break;
            
        case 1:
            [self showAddOptionsForType:EODataTypeSearchGuide];
            break;
            
        default:
            [self showAddOptionsForType:EODataTypeSearchRecipe];
            break;
    }
}

#pragma mark LUNSegmentedControlDelegate

- (void)segmentedControl:(LUNSegmentedControl *)segmentedControl didChangeStateFromStateAtIndex:(NSInteger)fromIndex toStateAtIndex:(NSInteger)toIndex {
    [self.tableView reloadData];
}

#pragma mark LUNSegmentedControlDatasource

- (NSArray<UIColor *> *)segmentedControl:(LUNSegmentedControl *)segmentedControl gradientColorsForStateAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @[[UIColor colorWithRed:78/255.0 green:252/255.0 blue:208/255.0 alpha:1.0],
                     [UIColor colorWithRed:51/255.0 green:199/255.0 blue:244/255.0 alpha:1.0]];
            break;
            
        case 1:
            return @[[UIColor colorWithRed:160/255.0 green:223/255.0 blue:56/255.0 alpha:1.0],
                     [UIColor colorWithRed:177/255.0 green:255/255.0 blue:0/255.0 alpha:1.0]];
            break;
            
        default:
            return @[[UIColor colorWithRed:178/255.0 green:0/255.0 blue:235/255.0 alpha:1.0],
                     [UIColor colorWithRed:233/255.0 green:0/255.0 blue:147/255.0 alpha:1.0]];
            break;
    }
    return nil;
}

- (NSInteger)numberOfStatesInSegmentedControl:(LUNSegmentedControl *)segmentedControl {
    return 3;
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForStateAtIndex:(NSInteger)index {
    NSArray *titles = @[NSLocalizedString(@"Oils", nil),
                        NSLocalizedString(@"Usage Guide", nil),
                        NSLocalizedString(@"Recipes", nil)];
    return [[NSAttributedString alloc] initWithString:titles[index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]}];
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForSelectedStateAtIndex:(NSInteger)index {
    NSArray *titles = @[NSLocalizedString(@"Oils", nil),
                        NSLocalizedString(@"Usage Guide", nil),
                        NSLocalizedString(@"Recipes", nil)];
    return [[NSAttributedString alloc] initWithString:titles[index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]}];
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Favorites *fav;
    
    // Pop loading indicator
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    switch (self.segmentedControl.currentState) {
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
            
        case 1: { // Guide
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
            
        default: { // Recipes
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
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *array = [self arrayForSegmentedControlIndex:self.segmentedControl.currentState];
        Favorites *fav = array[indexPath.row];
        [[CoreDataManager sharedManager] removeFavorite:fav withCompletion:^(BOOL didDelete, NSError *error) {
            [self refreshData];
        }];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self arrayForSegmentedControlIndex:self.segmentedControl.currentState];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleCell];
    
    NSArray *array = [self arrayForSegmentedControlIndex:self.segmentedControl.currentState];
    Favorites *fav = array[indexPath.row];
    cell.titleLabel.text = fav.name.capitalizedString;
    return cell;
}

#pragma mark DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    switch (self.segmentedControl.currentState) {
        case 0: // Oils
            return [UIImage imageNamed:@""];
            break;
            
        case 1: // Guide
            return [UIImage imageNamed:@""];
            break;
            
        default: // Recipes
            return [UIImage imageNamed:@""];
            break;
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableAttributedString *str;
    NSString *first, *last;
    
    switch (self.segmentedControl.currentState) {
        case 0: // Oils
            first = NSLocalizedString(@"No Favorite Oils", nil).uppercaseString;
            last = NSLocalizedString(@"Favorite an oil to see it here.", nil);
            break;
            
        case 1: // Guide
            first = NSLocalizedString(@"No Favorite Usage Guides", nil).uppercaseString;
            last = NSLocalizedString(@"Favorite a usage guide ailment to see it here.", nil);
            break;
            
        default: // Recipes
            first = NSLocalizedString(@"No Favorite Recipes", nil).uppercaseString;
            last = NSLocalizedString(@"Favorite any recipe to see it here.", nil);
            break;
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

#pragma mark DZNEmptySetDelegate

/**
 Determines if empty data set should allow user interactions.
 */
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return NO;
}
@end
