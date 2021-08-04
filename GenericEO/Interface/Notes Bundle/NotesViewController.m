////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       NotesViewController.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "NotesViewController.h"
#import "ABNotesViewController.h"
#import "ESTLNotesViewController.h"

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

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@interface NotesViewController () 

@end

@implementation NotesViewController

- (id)initForTarget {
#ifdef AB
    self = [[ABNotesViewController alloc] init];
#else
    self = [[ESTLNotesViewController alloc] init];
#endif
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    self.savedOilNotes = [[CoreDataManager sharedManager] getOilNotes];
    self.savedGuideNotes = [[CoreDataManager sharedManager] getGuideNotes];
    self.savedRecipeNotes = [[CoreDataManager sharedManager] getRecipeNotes];
    
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

#pragma mark - DataTableViewControllerDelegate

- (void)searchControllerDidSelecteObject:(PFObject *)object {
    [self.navigationController popViewControllerAnimated:YES];
    
    AddNoteViewController *vc = [[AddNoteViewController alloc] initForEntity:object withNote:nil];
    [self.navigationController showViewController:vc sender:self];
}

@end
