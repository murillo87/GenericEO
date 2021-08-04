////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       InventoryViewController.m
/// @author     Lynette Sesodia
/// @date       5/26/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "InventoryViewController.h"
#import "ABInventoryViewController.h"
#import "ESTLInventoryViewController.h"

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

@interface InventoryViewController ()

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation InventoryViewController

- (id)initForTarget {
#ifdef AB
    self = [[ABInventoryViewController alloc] init];
#else
    self = [[ESTLInventoryViewController alloc] init];
#endif
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshData];
}

#pragma mark Data

/**
 Queries core data for most up to data data, refreshes table view and data labels.
 */
- (void)refreshData {
    self.inventoryOils = [[CoreDataManager sharedManager] getInventoryOils];
    self.shoppingListOils = [[CoreDataManager sharedManager] getShoppingListOils];
    
#ifdef GENERIC
    [self.tableView reloadData];
#else
    // Get UUIDs from inventory and shopping list oils
    // Query for those objects
    NSArray *inventoryUUIDs = [self uuidsFromArray:self.inventoryOils];
    if (inventoryUUIDs.count > 0) {
        [[NetworkManager sharedManager] queryProductsForKey:@"uuid"
                                                 withValues:inventoryUUIDs
                                             withCompletion:^(NSArray<PFObject<OilModel> *> *objects, NSError *error) {
                                                 NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                                                 self.inventoryOilObjects = [objects sortedArrayUsingDescriptors:@[sort]];
                                                 [self.tableView reloadData];
                                            }];
    }

    NSArray *shoppingListUUIDs = [self uuidsFromArray:self.shoppingListOils];
    if (shoppingListUUIDs.count > 0) {
        [[NetworkManager sharedManager] queryProductsForKey:@"uuid"
                                                 withValues:shoppingListUUIDs
                                             withCompletion:^(NSArray<PFObject<OilModel> *> *objects, NSError *error) {
                                                 NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                                                 self.shoppingListOilObjects = [objects sortedArrayUsingDescriptors:@[sort]];
                                                [self.tableView reloadData];
                                            }];
    }
#endif
}

- (NSArray<NSString *> *)uuidsFromArray:(NSArray<MyOils *> *)array {
    NSMutableArray *uuids = [[NSMutableArray alloc] init];
    for (MyOils *oil in array) {
        [uuids addObject:oil.uuid];
    }
    return [uuids copy];
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

@end
