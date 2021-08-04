////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABNotesViewController.m
/// @author     Lynette Sesodia
/// @date       5/26/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ABNotesViewController.h"

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kNoteCell @"NoteCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ABNotesViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/// Segmented control to switch between note types.
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ABNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = NSLocalizedString(@"Saved Notes", nil);
    self.titleLabel.font = [UIFont headerFont];
    
    self.backButton.tintColor = [UIColor targetAccentColor];
    self.addButton.tintColor = [UIColor targetAccentColor];
   
    // Configure segmented control
    [self.segmentedControl setTitle:NSLocalizedString(@"Oil", nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"Recipe", nil) forSegmentAtIndex:1];
    [self.segmentedControl setTitle:NSLocalizedString(@"Guide", nil) forSegmentAtIndex:2];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
   
    // Configure table view
    [self.tableView registerNib:[UINib nibWithNibName:kNoteCell bundle:nil] forCellReuseIdentifier:kNoteCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70.0;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new]; // A little trick for removing the cell separators.
}

#pragma mark Data

- (void)refreshData {
    [super refreshData];
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
    MyNotes *note;
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // Oils
            note = self.savedOilNotes[indexPath.row];
            break;
            
        case 1: // Guide
            note = self.savedRecipeNotes[indexPath.row];
            break;
            
        default: // Recipes
            note = self.savedGuideNotes[indexPath.row];
            break;
    }
    
    // Pop option to edit note
    AddNoteViewController *vc = [[AddNoteViewController alloc] initForEntity:nil withNote:note];
    [self.navigationController showViewController:vc sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MyNotes *note;
        switch (self.segmentedControl.selectedSegmentIndex) {
            case 0: // Oils
                note = self.savedOilNotes[indexPath.row];
                break;
                
            case 1: // Guide
                note = self.savedRecipeNotes[indexPath.row];
                break;
                
            default: // Recipes
                note = self.savedGuideNotes[indexPath.row];
                break;
        }
        
        [[CoreDataManager sharedManager] deleteNote:note withCompletion:^(BOOL didDelete, NSError *error) {
            if (didDelete) {
                [self refreshData];
            }
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // Oils
            return self.savedOilNotes.count;
            break;
            
        case 1: // Guide
            return self.savedRecipeNotes.count;
            break;
            
        default: // Recipes
            return self.savedGuideNotes.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoteCell];
    
    MyNotes *note;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // Oils
            note = self.savedOilNotes[indexPath.row];
            break;
            
        case 1: // Guide
            note = self.savedRecipeNotes[indexPath.row];
            break;
            
        default: // Recipes
            note = self.savedGuideNotes[indexPath.row];
            break;
    }
    
    cell.noteNameLabel.text = note.name.capitalizedString;
    cell.noteTextLabel.text = note.text;
    return cell;
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    switch (self.segmentedControl.selectedSegmentIndex) {
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
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // Oils
            first = NSLocalizedString(@"No Oils Notes", nil).uppercaseString;
            last = NSLocalizedString(@"Add a note to any oil to see it here.", nil);
            break;
            
        case 1: // Recipes
            first = NSLocalizedString(@"No Recipes Notes", nil).uppercaseString;
            last = NSLocalizedString(@"Add a note to any recipe to see it here.", nil);
            break;
                    
        default: // Guide
            first = NSLocalizedString(@"No Usage Guide Notes", nil).uppercaseString;
            last = NSLocalizedString(@"Add a note to any usage guide ailment to see it here.", nil);
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
