////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       ABGuideViewController.m
/// @author     Lynette Sesodia
/// @date       5/5/20
//
//  Copyright © 2020 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ABGuideViewController.h"

#import "GuideTableViewCell.h"
#import "SuggestedOilsTableCell.h"
#import "NoteCell.h"
#import "ABEmptyTableViewCell.h"

#import "LUNSegmentedControl.h"

#import "OilViewController.h"
#import "RecipeViewController.h"
#import "AddNoteViewController.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kGuideCell @"GuideTableViewCell"
#define kSuggestedOilsCell @"SuggestedOilsTableCell"
#define kNoteCell @"NoteCell"
#define kEmptyCell @"ABEmptyTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

static NSString * const HeaderKeyDescription = @"Description";
static NSString * const HeaderKeyOils = @"Oils";
static NSString * const HeaderKeyUsage = @"Usage";
static NSString * const HeaderKeyRecipes = @"Recipes";

static NSInteger oilsTableViewTag = 100;
static NSInteger recipesTableViewTag = 200;

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ABGuideViewController () <UITableViewDelegate, UITableViewDataSource>

/// Segmented control for the controller.
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ABGuideViewController

- (id)initWithObject:(PFObject *)object {
    self = [super init];
    if (self) {
        self.object = object;
        
        self.tableViewDictionary = [[NSMutableDictionary alloc] init];
        
        [self.tableViewDictionary setValue:[object valueForKey:GuideParseKeyDescription] forKey:HeaderKeyDescription];
        [self.tableViewDictionary setValue:[object valueForKey:GuideParseKeyOils] forKey:HeaderKeyOils];
        [self.tableViewDictionary setValue:[object valueForKey:GuideParseKeyUsage] forKey:HeaderKeyUsage];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backButton.tintColor = [UIColor targetAccentColor];
    self.nameLabel.text = [self.object valueForKey:GuideParseKeyName];
    self.nameLabel.font = [UIFont font:[UIFont titleFont] ofSize:19.0];
    
    // Format button
//    self.addNoteButton.layer.cornerRadius = 8;
//    self.addNoteButton.layer.borderWidth = 1;
//    self.addNoteButton.layer.borderColor = [UIColor blackColor].CGColor;
//    self.addNoteButton.backgroundColor = [UIColor whiteColor];
    
    // Segmented Control setup
    [self configureSegmentedControl];
    
    // Tableview setup
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        [self displayPaywallIfNeeded];
    }
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.tableView.alpha = 1.0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI

- (void)configureSegmentedControl {
    self.segmentedControl.backgroundColor = [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1.0];
    self.segmentedControl.selectedSegmentTintColor = [UIColor targetAccentColor];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}
                                         forState:UIControlStateSelected];
    [self.segmentedControl setTitle:NSLocalizedString(@"About", nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"Recipes", nil) forSegmentAtIndex:1];
    [self.segmentedControl setTitle:NSLocalizedString(@"Notes", nil) forSegmentAtIndex:2];
    
    [self.segmentedControl addTarget:self action:@selector(segmentedControlSelectedSegmentDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)configureTableView {
    self.tableView.alpha = 0.0;
    [self.tableView registerNib:[UINib nibWithNibName:kGuideCell bundle:nil] forCellReuseIdentifier:kGuideCell];
    [self.tableView registerNib:[UINib nibWithNibName:kSuggestedOilsCell bundle:nil] forCellReuseIdentifier:kSuggestedOilsCell];
    [self.tableView registerNib:[UINib nibWithNibName:kNoteCell bundle:nil] forCellReuseIdentifier:kNoteCell];
    [self.tableView registerNib:[UINib nibWithNibName:kEmptyCell bundle:nil] forCellReuseIdentifier:kEmptyCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark Actions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentedControlSelectedSegmentDidChange:(UISegmentedControl *)sender {
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        [self displayPaywallIfNeeded];
    } else {
        [self hidePaywall];
    }
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.segmentedControl.selectedSegmentIndex) {
            
        case 1: { // Recipes Section
            PFRecipe *recipe = (PFRecipe *)[self.tableViewDictionary valueForKey:HeaderKeyRecipes][indexPath.row];
            RecipeViewController *vc = [[RecipeViewController alloc] initWithRecipe:recipe];
            [self.navigationController showViewController:vc sender:self];
        } break;
            
        case 2: { // MyNotes
            AddNoteViewController *vc = [[AddNoteViewController alloc] initForEntity:self.object withNote:nil];
            [self.navigationController showViewController:vc sender:self];
        } break;
            
        default:
            // No actions for about tab
            break;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // About
        case 1: // Recipes
        case 2: // My Notes
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGuideCell];
    cell.name.font = [UIFont titleFont];
    cell.name.textColor = [UIColor targetAccentColor];
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: { // About
            switch (indexPath.row) {
                case 0: { // Description
                    cell.name.text = NSLocalizedString(HeaderKeyDescription, nil);
                    cell.subtitle.text = [self.tableViewDictionary valueForKey:HeaderKeyDescription];
                } break;
                    
                default:
                    break;
            }
        } break;
            
        case 1: { // Recipes
            NSArray *recipes = [self.tableViewDictionary valueForKey:HeaderKeyRecipes];
            SuggestedOilsTableCell *suggestionCell = [tableView dequeueReusableCellWithIdentifier:kSuggestedOilsCell];
            suggestionCell.titleLabel.text = NSLocalizedString(HeaderKeyRecipes, nil);
            suggestionCell.titleLabel.textColor = [UIColor targetAccentColor];
            [suggestionCell shouldDisplayHeaderInBar:NO];
            suggestionCell.cellIconWidth = 0.0;
            suggestionCell.tableView.tag = recipesTableViewTag;
            suggestionCell.tableView.delegate = self;
            suggestionCell.tableViewHeight.constant = (recipes.count * SuggestedOilsCellChildTableViewCellRowHeight);
            [suggestionCell setObjectsForTableView:recipes shouldFetchData:YES];
            return suggestionCell;
        } break;
            
        case 2: { // MyNotes
            MyNotes *note = [[CoreDataManager sharedManager] getNoteForID:self.object[@"uuid"]];
            
            if (note != nil) {
                // Display note cell if a note exists
                NoteCell *noteCell = [tableView dequeueReusableCellWithIdentifier:kNoteCell];
                noteCell.noteNameLabel.text = NSLocalizedString(@"Added Note", nil);
                noteCell.noteTextLabel.text = note.text;
                noteCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                noteCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return noteCell;
            } else {
                ABEmptyTableViewCell *addNoteCell = [tableView dequeueReusableCellWithIdentifier:kEmptyCell];
                addNoteCell.iconImageView.image = [UIImage imageNamed:@"empty.icon.note"];
                addNoteCell.titleLabel.text = NSLocalizedString(@"No note", nil);
                addNoteCell.subtitleLabel.text = NSLocalizedString(@"Tap to add a new note", nil);
                addNoteCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return addNoteCell;
            }
        } break;
            
        default:
            break;
    }
    
    return cell;
}

@end
