////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABInventoryViewController.m
/// @author     Lynette Sesodia
/// @date       5/26/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ABInventoryViewController.h"
#import "Constants.h"

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

@interface ABInventoryViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,
                                        InventoryTableViewCellDelegate, DataTableViewControllerSearchDelegate>

/// Segmented control to switch between favorite types.
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
 
@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ABInventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = NSLocalizedString(@"Inventory", nil);
    self.titleLabel.font = [UIFont headerFont];
    
    self.backButton.tintColor = [UIColor targetAccentColor];
    self.addButton.tintColor = [UIColor targetAccentColor];
    
    // Configure segmented control
    [self.segmentedControl setTitle:NSLocalizedString(@"Inventory", nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"Shopping List", nil) forSegmentAtIndex:1];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    // Configure table view
    [self.tableView registerNib:[UINib nibWithNibName:kShoppingListCell bundle:nil] forCellReuseIdentifier:kShoppingListCell];
    [self.tableView registerNib:[UINib nibWithNibName:kInventoryCell bundle:nil] forCellReuseIdentifier:kInventoryCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
    
}

#pragma mark Actions

- (void)segmentedControlValueDidChange:(UISegmentedControl *)sender {
    [self.tableView reloadData];
}

- (IBAction)add:(id)sender {
    [self showAddOptionsForType:EODataTypeSearchSingle];
}

#pragma mark - DataTableViewControllerDelegate

- (void)searchControllerDidSelecteObject:(PFObject *)object {
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        // Add oil to inventory
        [[CoreDataManager sharedManager] saveOil:object toInventory:YES toShoppingList:NO withCompletion:^(BOOL didSave, NSError *error) {
            [self refreshData];
        }];
    } else {
        // Add oil to shopping list
        [[CoreDataManager sharedManager] saveOil:object toInventory:NO toShoppingList:YES withCompletion:^(BOOL didSave, NSError *error) {
            [self refreshData];
        }];
    }
}

#pragma mark - InventoryTableViewCellDelegate

- (void)amountDidChange:(double)amount forCellAtIndex:(NSIndexPath *)indexPath {
    MyOils *oil = self.inventoryOils[indexPath.row];
    
    [[CoreDataManager sharedManager] changeOil:oil inventoryAmount:amount withCompletion:^(BOOL success, NSError *error) {
        
    }];
}

- (void)addOilToShoppingListAtIndex:(NSIndexPath *)indexPath {
    MyOils *oil = self.inventoryOils[indexPath.row];
    
    [[CoreDataManager sharedManager] changeOil:oil shoppingListStatus:YES withCompletion:^(BOOL didUpdate, NSError *error) {
        self.shoppingListOils = [[CoreDataManager sharedManager] getShoppingListOils];
        [self refreshData];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get id and class name from core data object
    MyOils *oil;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // Inventory
            oil = self.inventoryOils[indexPath.row];
            break;
            
        default: // Shopping List
            oil = self.shoppingListOils[indexPath.row];
            break;
    }
    
    // Pop loading indicator
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    // Query for object from parse
    [[NetworkManager sharedManager] queryProductsForKey:@"uuid"
                                             withValues:@[oil.uuid]
                                         withCompletion:^(NSArray<PFObject<OilModel> *> *objects, NSError *error) {
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
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Save reference to deleted index path
        
        switch (self.segmentedControl.selectedSegmentIndex) {
            case 0: { // Inventory
                [[CoreDataManager sharedManager] removeOil:self.inventoryOils[indexPath.row] fromInventory:YES fromShoppingList:NO withCompletion:^(BOOL didSucceed, NSError *error) {
                    self.inventoryOils = [[CoreDataManager sharedManager] getInventoryOils];
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                }];
            } break;
                
            default: { // Shopping List
                [[CoreDataManager sharedManager] removeOil:self.shoppingListOils[indexPath.row] fromInventory:NO fromShoppingList:YES withCompletion:^(BOOL didSucceed, NSError *error) {
                    self.shoppingListOils = [[CoreDataManager sharedManager] getShoppingListOils];
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                }];
            } break;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.segmentedControl.selectedSegmentIndex == 0) ? self.inventoryOils.count: self.shoppingListOils.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.segmentedControl.selectedSegmentIndex == 0) ? 75.0 : 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: { // Inventory
            MyOils *oil = self.inventoryOils[indexPath.row];
            InventoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInventoryCell];
            
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.nameLabel.text = oil.name.capitalizedString;
            [cell setStepperValue:oil.amount];
            
            if (oil.toBuy == YES) {
                [cell.shoppingListAddButton setImage:[UIImage imageNamed:@"icon-cart-fill"] forState:UIControlStateNormal];
            } else {
                [cell.shoppingListAddButton setImage:[UIImage imageNamed:@"icon-cart"] forState:UIControlStateNormal];
            }
            
#ifdef GENERIC
            cell.iconImageView.image = [UIImage imageNamed:oil.uuid];
#elif DOTERRA
            cell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
            if (self.inventoryOilObjects != nil && self.inventoryOilObjects.count > indexPath.row) {
                PFObject<OilModel> *oil = self.inventoryOilObjects[indexPath.row];
                cell.iconImageView.backgroundColor = [UIColor colorWithHexString:oil[@"color"]];
                
                NSString *type = oil[@"type"];
                if ([type.lowercaseString containsString:@"rollon"]) {
                    cell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra-touch"];
                }
            }

#elif YOUNGLIVING
            if (self.inventoryOilObjects != nil && self.inventoryOilObjects.count > indexPath.row) {
                PFObject<OilModel> *oil = self.inventoryOilObjects[indexPath.row];
                cell.iconImageView.backgroundColor = [UIColor colorWithHexString:oil[@"color"]];
                
                NSString *type = oil[@"type"];
                NSLog(@"Type: %@", type);
                if ([type isEqualToString:@"Oil-Light"]) {
                    cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-light"];
                } else if ([type isEqualToString:@"Roll-On"]) {
                    cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-rollon"];
                } else {
                    cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving"];
                }
            }
#endif
            
            
            return cell;
        } break;
            
        default: { // Shopping List
            MyOils *oil = self.shoppingListOils[indexPath.row];
            ShoppingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShoppingListCell];
            
            cell.indexPath = indexPath;
            cell.nameLabel.text = oil.name.capitalizedString;
            
#ifdef GENERIC
            cell.iconImageView.image = [UIImage imageNamed:oil.uuid];
#elif DOTERRA
            cell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
            if (self.shoppingListOilObjects != nil && self.shoppingListOilObjects.count > indexPath.row) {
                PFObject<OilModel> *oil = self.shoppingListOilObjects[indexPath.row];
                cell.iconImageView.backgroundColor = [UIColor colorWithHexString:oil[@"color"]];
                
                NSString *type = oil[@"type"];
                if ([type.lowercaseString containsString:@"rollon"]) {
                    cell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra-touch"];
                }
            }

#elif YOUNGLIVING
            if (self.shoppingListOilObjects != nil && self.shoppingListOilObjects.count > indexPath.row) {
                PFObject<OilModel> *oil = self.shoppingListOilObjects[indexPath.row];
                cell.iconImageView.backgroundColor = [UIColor colorWithHexString:oil[@"color"]];
            
                NSString *type = oil[@"type"];
                if ([type isEqualToString:@"Oil-Light"]) {
                    cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-light"];
                } else if ([type isEqualToString:@"Roll-On"]) {
                    cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving-rollon"];
                } else {
                    cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving"];
                }
            }
#endif
            
            return cell;
        } break;
    }
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // My Oils
            return [UIImage imageNamed:@"oil"];
            break;
            
        case 1: // My Notes
            return [UIImage imageNamed:@"pencil"];
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableAttributedString *str;
    NSString *first, *last;
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // My Oils
            first = NSLocalizedString(@"Empty Inventory", nil).uppercaseString;
            last = NSLocalizedString(@"Add a product to your Inventory to see it here.", nil);
            break;
            
        case 1: // My Notes
            first = NSLocalizedString(@"Empty Shopping List", nil).uppercaseString;
            last = NSLocalizedString(@"Add a product to your Shopping List to see it here.", nil);
            break;
            
        default:
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
