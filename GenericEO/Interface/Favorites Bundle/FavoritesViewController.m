////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       MyOilsViewController.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "FavoritesViewController.h"
#import "ABFavoritesViewController.h"
#import "ESTLFavoritesViewController.h"
#import "Constants.h"

#import "RecipeViewController.h"
#import "OilViewController.h"
#import "GuideViewController.h"

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

@interface FavoritesViewController ()

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation FavoritesViewController

- (id)initForTarget {
#ifdef AB
    self = [[ABFavoritesViewController alloc] init];
#else
    self = [[ESTLFavoritesViewController alloc] init];
#endif
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = NSLocalizedString(@"Favorites", nil);
    self.titleLabel.font = [UIFont headerFont];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data

/**
 Queries core data for most up to data data, refreshes table view and data labels.
 */
- (void)refreshData {
    self.favoriteOils = [[CoreDataManager sharedManager] getFavoriteOils];
    self.favoriteGuides = [[CoreDataManager sharedManager] getFavoriteGuides];
    self.favoriteRecipes = [[CoreDataManager sharedManager] getFavoriteRecipes];
    
    [self.tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAddOptionsForType:(EODataType)type {
    DataTableViewController *vc = [[DataTableViewController alloc] initWithType:type];
    vc.searchDelegate = self;
    [self.navigationController showViewController:vc sender:self];
}

#pragma mark - DataTableViewControllerSearchDelegate

- (void)searchControllerDidSelecteObject:(PFObject *)object {
    [self.navigationController popViewControllerAnimated:YES];
    [[CoreDataManager sharedManager] addFavorite:object withCompletion:^(BOOL didSave, NSError *error) {
        [self refreshData];
    }];
}

@end
