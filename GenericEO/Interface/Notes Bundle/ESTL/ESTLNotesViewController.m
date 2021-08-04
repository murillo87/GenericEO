////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ESTLNotesViewController.m
/// @author     Lynette Sesodia
/// @date       5/26/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ESTLNotesViewController.h"
#import "LUNSegmentedControl.h"

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

@interface ESTLNotesViewController () <UITableViewDelegate, UITableViewDataSource, DataTableViewControllerSearchDelegate,
                                    DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, LUNSegmentedControlDelegate, LUNSegmentedControlDataSource>

/// Top color view.
@property (nonatomic, strong) IBOutlet UIView *topColorView;

/// Label displaying the number of oils notes.
@property (nonatomic, strong) IBOutlet UILabel *oilsNotesCountLabel;

/// Label displaying the user facing string subtitle for the oils notes count label.
@property (nonatomic, strong) IBOutlet UILabel *oilsNotesCountSubtitleLabel;

/// Label displaying the number of guide notes
@property (nonatomic, strong) IBOutlet UILabel *guideNotesCountLabel;

/// Label displaying the user facing string subtitle for the guide notes count label.
@property (nonatomic, strong) IBOutlet UILabel *guideNotesCountSubtitleLabel;

/// Label displaying the number of recipe notes
@property (nonatomic, strong) IBOutlet UILabel *recipesNotesCountLabel;

/// Label displaying the user facing string subtitle for the recipe notes count label.
@property (nonatomic, strong) IBOutlet UILabel *recipesNotesCountSubtitleLabel;

/// View containing the tableview and segmented control.
@property (nonatomic, strong) IBOutlet UIView *mainView;

/// Segmented control to change what information is displayed by the tableview.
@property (nonatomic, strong) IBOutlet LUNSegmentedControl *segmentedControl;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ESTLNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = NSLocalizedString(@"Saved Notes", nil);
    self.titleLabel.font = [UIFont headerFont];
    
    // Configure the views
    self.topColorView.backgroundColor = [UIColor colorForType:EODataTypeSingleOil];
    self.mainView.layer.cornerRadius = 22.;
    self.mainView.layer.masksToBounds = YES;
    
    // Configure labels
    self.oilsNotesCountSubtitleLabel.text = NSLocalizedString(@"Oils", nil);
    self.guideNotesCountSubtitleLabel.text = NSLocalizedString(@"Usage Guide", nil);
    self.recipesNotesCountSubtitleLabel.text = NSLocalizedString(@"Recipes", nil);
    
    // Configure Segmented Control
    //self.segmentedControl.shapeStyle = LUNSegmentedControlShapeStyleRoundedRect;
    self.segmentedControl.selectorViewColor = [UIColor clearColor];
    self.segmentedControl.shadowsEnabled = NO;
    self.segmentedControl.applyCornerRadiusToSelectorView = YES;
    self.segmentedControl.cornerRadius = self.segmentedControl.frame.size.height/2;
    self.segmentedControl.delegate = self;
    self.segmentedControl.dataSource = self;
    
    // Configure table view
    [self.tableView registerNib:[UINib nibWithNibName:kNoteCell bundle:nil] forCellReuseIdentifier:kNoteCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70.0;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    
    // Create an add button for adding oils to inventory
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = addBtn;
}

#pragma mark - Data

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.oilsNotesCountLabel.text = [NSString stringWithFormat:@"%lu", self.savedOilNotes.count];
    self.guideNotesCountLabel.text = [NSString stringWithFormat:@"%lu", self.savedGuideNotes.count];
    self.recipesNotesCountLabel.text = [NSString stringWithFormat:@"%lu", self.savedRecipeNotes.count];
}

#pragma mark - IBActions

- (IBAction)add:(UIButton *)sender {
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

#pragma mark - LUNSegmentedControlDelegate

- (void)segmentedControl:(LUNSegmentedControl *)segmentedControl didChangeStateFromStateAtIndex:(NSInteger)fromIndex toStateAtIndex:(NSInteger)toIndex {
    [self.tableView reloadData];
}

#pragma mark - LUNSegmentedControlDatasource

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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyNotes *note;
    
    switch (self.segmentedControl.currentState) {
        case 0: // Oils
            note = self.savedOilNotes[indexPath.row];
            break;
            
        case 1: // Guide
            note = self.savedGuideNotes[indexPath.row];
            break;
            
        default: // Recipes
            note = self.savedRecipeNotes[indexPath.row];
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
        switch (self.segmentedControl.currentState) {
            case 0: // Oils
                note = self.savedOilNotes[indexPath.row];
                break;
                
            case 1: // Guide
                note = self.savedGuideNotes[indexPath.row];
                break;
                
            default: // Recipes
                note = self.savedRecipeNotes[indexPath.row];
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
    switch (self.segmentedControl.currentState) {
        case 0: // Oils
            return self.savedOilNotes.count;
            break;
            
        case 1: // Guide
            return self.savedGuideNotes.count;
            break;
            
        default: // Recipes
            return self.savedRecipeNotes.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoteCell];
    
    MyNotes *note;
    switch (self.segmentedControl.currentState) {
        case 0: // Oils
            note = self.savedOilNotes[indexPath.row];
            break;
            
        case 1: // Guide
            note = self.savedGuideNotes[indexPath.row];
            break;
            
        default: // Recipes
            note = self.savedRecipeNotes[indexPath.row];
            break;
    }
    
    cell.noteNameLabel.text = note.name.capitalizedString;
    cell.noteTextLabel.text = note.text;
    return cell;
}

#pragma mark - DZNEmptyDataSetSource

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
            first = NSLocalizedString(@"No Oils Notes", nil).uppercaseString;
            last = NSLocalizedString(@"Add a note to any oil to see it here.", nil);
            break;
            
        case 1: // Guide
            first = NSLocalizedString(@"No Usage Guide Notes", nil).uppercaseString;
            last = NSLocalizedString(@"Add a note to any usage guide ailment to see it here.", nil);
            break;
            
        default: // Recipes
            first = NSLocalizedString(@"No Recipes Notes", nil).uppercaseString;
            last = NSLocalizedString(@"Add a note to any recipe to see it here.", nil);
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

#pragma mark - DZNEmptySetDelegate

/**
 Determines if empty data set should allow user interactions.
 */
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return NO;
}

@end
