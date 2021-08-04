////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ESTLInventoryViewController.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ESTLInventoryViewController.h"
#import "Constants.h"

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

@interface ESTLInventoryViewController () <UITableViewDelegate, UITableViewDataSource, InventoryTableViewCellDelegate,
                                            DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, LUNSegmentedControlDelegate, LUNSegmentedControlDataSource>

/// Top color view.
@property (nonatomic, strong) IBOutlet UIView *topColorView;

/// View containing the tableview and segmented control.
@property (nonatomic, strong) IBOutlet UIView *mainView;

/// Label displaying the number of inventory oils.
@property (nonatomic, strong) IBOutlet UILabel *inventoryOilsCountLabel;

/// Label displaying the user facing string subtitle for the inventory oils count label.
@property (nonatomic, strong) IBOutlet UILabel *inventoryOilsCountSubtitleLabel;

/// Label displaying the number of shopping list oils.
@property (nonatomic, strong) IBOutlet UILabel *shoppingListOilsCountLabel;

/// Label displaying the user facing string subtitle for the shopping list oils count label.
@property (nonatomic, strong) IBOutlet UILabel *shoppingListOilsCountSubtitleLabel;

/// Segmented control to change what information is displayed by the tableview
@property (nonatomic, strong) IBOutlet LUNSegmentedControl *segmentedControl;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ESTLInventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = NSLocalizedString(@"My Oils", nil);
    self.titleLabel.font = [UIFont headerFont];
    
    // Configure the views
    self.topColorView.backgroundColor = [UIColor colorForType:EODataTypeSingleOil];
    self.mainView.layer.cornerRadius = 22.;
    self.mainView.layer.masksToBounds = YES;
    
    // Configure labels
    self.inventoryOilsCountSubtitleLabel.text = NSLocalizedString(@"Inventory", nil);
    self.shoppingListOilsCountSubtitleLabel.text = NSLocalizedString(@"Shopping List", nil);
    
    // Configure Segmented Control
    //self.segmentedControl.shapeStyle = LUNSegmentedControlShapeStyleRoundedRect;
    self.segmentedControl.selectorViewColor = [UIColor clearColor];
    self.segmentedControl.shadowsEnabled = NO;
    self.segmentedControl.applyCornerRadiusToSelectorView = YES;
    self.segmentedControl.cornerRadius = self.segmentedControl.frame.size.height/2;
    self.segmentedControl.delegate = self;
    self.segmentedControl.dataSource = self;
    
    // Configure table view
    [self.tableView registerNib:[UINib nibWithNibName:kShoppingListCell bundle:nil] forCellReuseIdentifier:kShoppingListCell];
    [self.tableView registerNib:[UINib nibWithNibName:kInventoryCell bundle:nil] forCellReuseIdentifier:kInventoryCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    // Create an add button for adding oils to inventory
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = addBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)add:(UIButton *)sender {
    [self showAddOptionsForType:EODataTypeSearchSingle];
}

#pragma mark - DataTableViewControllerDelegate

- (void)searchControllerDidSelecteObject:(PFObject *)object {
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.segmentedControl.currentState == 0) {
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

#pragma mark - LUNSegmentedControlDelegate

- (void)segmentedControl:(LUNSegmentedControl *)segmentedControl didChangeStateFromStateAtIndex:(NSInteger)fromIndex toStateAtIndex:(NSInteger)toIndex {
    [self.tableView reloadData];
}

#pragma mark - LUNSegmentedControlDatasource

- (NSArray<UIColor *> *)segmentedControl:(LUNSegmentedControl *)segmentedControl gradientColorsForStateAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @[[UIColor colorWithRed:160/255.0 green:223/255.0 blue:56/255.0 alpha:1.0],
                     [UIColor colorWithRed:177/255.0 green:255/255.0 blue:0/255.0 alpha:1.0]];
            break;
            
        case 1:
            return @[[UIColor colorWithRed:78/255.0 green:252/255.0 blue:208/255.0 alpha:1.0],
                     [UIColor colorWithRed:51/255.0 green:199/255.0 blue:244/255.0 alpha:1.0]];
            break;
            
        default:
            return @[[UIColor colorWithRed:178/255.0 green:0/255.0 blue:235/255.0 alpha:1.0],
                     [UIColor colorWithRed:233/255.0 green:0/255.0 blue:147/255.0 alpha:1.0]];
            break;
    }
    return nil;
}

- (NSInteger)numberOfStatesInSegmentedControl:(LUNSegmentedControl *)segmentedControl {
    return 2;
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForStateAtIndex:(NSInteger)index {
    NSArray *titles = @[NSLocalizedString(@"Inventory", nil),
                        NSLocalizedString(@"Shopping List", nil)];
    return [[NSAttributedString alloc] initWithString:titles[index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]}];
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForSelectedStateAtIndex:(NSInteger)index {
    NSArray *titles = @[NSLocalizedString(@"Inventory", nil),
                        NSLocalizedString(@"Shopping List", nil)];
    return [[NSAttributedString alloc] initWithString:titles[index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]}];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get id and class name from core data object
    MyOils *oil;
    switch (self.segmentedControl.currentState) {
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
        
        switch (self.segmentedControl.currentState) {
            case 0: { // Inventory
                [[CoreDataManager sharedManager] removeOil:self.inventoryOils[indexPath.row] fromInventory:YES fromShoppingList:NO withCompletion:^(BOOL didSucceed, NSError *error) {
                    self.inventoryOils = [[CoreDataManager sharedManager] getInventoryOils];
                    self.inventoryOilsCountLabel.text = [NSString stringWithFormat:@"%lu", self.inventoryOils.count];
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                }];
            } break;
                
            default: { // Shopping List
                [[CoreDataManager sharedManager] removeOil:self.shoppingListOils[indexPath.row] fromInventory:NO fromShoppingList:YES withCompletion:^(BOOL didSucceed, NSError *error) {
                    self.shoppingListOils = [[CoreDataManager sharedManager] getShoppingListOils];
                    self.shoppingListOilsCountLabel.text = [NSString stringWithFormat:@"%lu", self.shoppingListOils.count];
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
    return (self.segmentedControl.currentState == 0) ? self.inventoryOils.count: self.shoppingListOils.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.segmentedControl.currentState == 0) ? 75.0 : 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.segmentedControl.currentState) {
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
    switch (self.segmentedControl.currentState) {
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
    
    switch (self.segmentedControl.currentState) {
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
