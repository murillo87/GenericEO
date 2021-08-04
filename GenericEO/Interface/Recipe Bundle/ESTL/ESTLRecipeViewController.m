////////////////////////////////////////////////////////////////////////////////
//  Essential Oils
/// @file       RecipeViewController.m
/// @author     Lynette Sesodia
/// @date       3/16/18
//
//  Copyright © 2018 Cloforce LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "ESTLRecipeViewController.h"

#import "RecipeImageTableViewCell.h"
#import "RecipeTextTableViewCell.h"
#import "SuggestedOilsTableCell.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kRecipeImageCell @"RecipeImageTableViewCell"
#define kRecipeTextCell @"RecipeTextTableViewCell"
#define kSuggestedOilsCell @"SuggestedOilsTableCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface ESTLRecipeViewController () 

#pragma mark - Interface

/// Top color view.
@property (nonatomic, strong) IBOutlet UIView *topColorView;

/// View containing the tableview and segmented control.
@property (nonatomic, strong) IBOutlet UIView *mainView;

/// Button to share the recipe.
@property (nonatomic, strong) IBOutlet UIButton *shareButton;

/// Breadcrumb label displaying the recipe category.
@property (nonatomic, strong) IBOutlet UILabel *categoryLabel;

/// Top space constraint for the main tableview.
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tableViewTopSpaceConstraint;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation ESTLRecipeViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Configure the views
    self.topColorView.backgroundColor = [UIColor colorForType:EODataTypeRecipe];
    self.mainView.layer.cornerRadius = 22.;
    self.mainView.layer.masksToBounds = YES;
    
    self.titleLabel.text = self.recipe.name.capitalizedString;
    self.categoryLabel.text = self.recipe.category.uppercaseString;
    
    self.shareButton.layer.cornerRadius = 20.0;
    self.favoriteButton.layer.cornerRadius = 20.0;
    self.addNoteButton.layer.cornerRadius = 20.0;
    
    // Verify all data points are valid before displaying to prevent empty table view cells
    self.tableViewKeys = [[NSMutableArray alloc] init];
    if (self.recipe.summaryDescription.length > 0) [self.tableViewKeys addObject:DescriptionKey];
    if (self.recipe.oilsUsed.count > 0) [self.tableViewKeys addObject:OilsUsedKey];
    if (self.recipe.ingredients.count > 0) [self.tableViewKeys addObject:IngredientsKey];
    if (self.recipe.steps.count > 0) [self.tableViewKeys addObject:StepsKey];
    if (self.recipe.amount.length > 0) [self.tableViewKeys addObject:AmountKey];
    
    // Setup tableview
    [self.tableView registerNib:[UINib nibWithNibName:kRecipeImageCell bundle:nil] forCellReuseIdentifier:kRecipeImageCell];
    [self.tableView registerNib:[UINib nibWithNibName:kRecipeTextCell bundle:nil] forCellReuseIdentifier:kRecipeTextCell];
    [self.tableView registerNib:[UINib nibWithNibName:kSuggestedOilsCell bundle:nil] forCellReuseIdentifier:kSuggestedOilsCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateNoteButtonIfNoteExists:(self.note != nil) ? YES : NO];
    [self updateFavoriteButton:(self.favorite != nil) ? YES : NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)updateNoteButtonIfNoteExists:(BOOL)hasNote {
    UIImage *img = [UIImage imageNamed:@"note-outline"];
    UIImage *sImg = [UIImage imageNamed:@"note-fill-white"];
    [self.addNoteButton setImage:(hasNote) ? sImg : img forState:UIControlStateNormal];
    [self updateButton:self.addNoteButton withSelectedColor:[UIColor recipeLightPurple] isSelected:(hasNote) ? YES : NO];
}

- (void)updateFavoriteButton:(BOOL)isFav {
    UIImage *img = [UIImage imageNamed:@"heart-outline"];
    UIImage *sImg = [UIImage imageNamed:@"heart-fill"];
    [self.favoriteButton setImage:(isFav) ? sImg : img forState:UIControlStateNormal];
    [self updateButton:self.favoriteButton withSelectedColor:[UIColor accentRed] isSelected:isFav];
}

- (void)updateButton:(UIButton *)button withSelectedColor:(UIColor *)sColor isSelected:(BOOL)selected {
    UIColor *tint = (selected) ? [UIColor whiteColor] : [UIColor blackColor];
    UIColor *background = (selected) ? sColor : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    CGColorRef border = (selected) ? sColor.CGColor : [UIColor blackColor].CGColor;
    
    button.tintColor = tint;
    button.backgroundColor = background;
    button.layer.borderColor = border;
}

#pragma mark - Actions

- (IBAction)favorite:(id)sender {
    [super markFavoriteWithCompletion:^{
        [self updateFavoriteButton:(self.favorite != nil) ? YES : NO];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // No action unless suggestion oil tableview
    if (tableView.tag == OilsUsedTableViewTag) {
#ifdef GENERIC
        PFOil *oil = (PFOil *)self.oilsUsed[indexPath.row];
        OilViewController *vc = [[OilViewController alloc] initWithOil:oil andSources:nil];
#elif DOTERRA
        PFDoterraOil *oil = (PFDoterraOil *)self.oilsUsed[indexPath.row];
        OilViewController *vc = [[OilViewController alloc] initWithDoterraOil:oil];
#elif YOUNGLIVING
        PFYoungLivingOil *oil = (PFYoungLivingOil *)self.oilsUsed[indexPath.row];
        OilViewController *vc = [[OilViewController alloc] initWithYoungLivingOil:oil];
#endif
        [self showViewController:vc sender:self];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == OilsUsedTableViewTag) {
        return 0.0;
    }
    
    switch (section) {
        case 1:
        case 2:
        case 3:
        case 4:
            return 40.0;
            break;
            
        default:
            return 0.0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == OilsUsedTableViewTag) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.0)];
    view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0];
    
    UILabel *title = [[UILabel alloc] initWithFrame:view.frame];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    
    switch (section) {
        default: {
            NSString *str = self.tableViewKeys[section];
            if ([str isEqualToString:DescriptionKey]) {
                str = @"Description";
            }
            title.text = NSLocalizedString([NSString addSpacesBeforeCapitalLettersInString:str].capitalizedString, nil);
        } break;
    }
    
    [view addSubview:title];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == OilsUsedTableViewTag) {
        return UITableViewAutomaticDimension;
    }
    
    NSString *str = self.tableViewKeys[indexPath.row];
    if ([str isEqualToString:OilsUsedKey]) {
        return 33 + (SuggestedOilsCellChildTableViewCellRowHeight * self.oilsUsed.count);
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeTextTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:kRecipeTextCell];
    textCell.selectionStyle = UITableViewCellSelectionStyleNone;
    textCell.titleLabel.textColor = [UIColor targetAccentColor];
    
    NSString *key = self.tableViewKeys[indexPath.row];
    
    // Display Description
    if ([key isEqualToString:DescriptionKey]) {
        textCell.titleLabel.text = NSLocalizedString(@"Description", nil);
        textCell.secondaryLabel.text = self.recipe.summaryDescription;
        textCell.secondaryLabel.textColor = [UIColor darkGrayColor];
        textCell.secondaryLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    }
    
    // Display Oils Used
    // Tableview within cell with pointers to single oil objects and pushes to their pages
    if ([key isEqualToString:OilsUsedKey]) {
        SuggestedOilsTableCell *tableCell = [tableView dequeueReusableCellWithIdentifier:kSuggestedOilsCell];
        tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableCell.titleLabel.text = NSLocalizedString(@"Oils Used", nil);
        tableCell.tableView.tag = OilsUsedTableViewTag;
        tableCell.tableView.delegate = self;
        [tableCell shouldDisplayHeaderInBar:NO];
        [tableCell setObjectsForTableView:self.oilsUsed shouldFetchData:YES];
        return tableCell;
    }
    
    // Display servings amount
    if ([key isEqualToString:AmountKey]) {
        textCell.titleLabel.text = NSLocalizedString(@"Servings", nil);
        textCell.secondaryLabel.text = self.recipe.amount.capitalizedString;
        textCell.secondaryLabel.textColor = [UIColor darkGrayColor];
        textCell.secondaryLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    }
    
    // Attributes used in both ingredients and steps cells
    NSDictionary *lineAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:10.0] };
    NSDictionary *boldAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0],
                                      NSForegroundColorAttributeName : [UIColor darkGrayColor] };
    NSDictionary *normalAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16.0],
                                        NSForegroundColorAttributeName : [UIColor darkGrayColor] };
    
    //Display Ingredients
    if ([key isEqualToString:IngredientsKey]) {
        textCell.titleLabel.text = NSLocalizedString(@"Ingredients", nil);
        
        NSMutableAttributedString *ingredientsString = [[NSMutableAttributedString alloc] init];
       
        for (int i=0; i<self.recipe.ingredients.count; i++) {
            NSString *text = [NSString stringWithFormat:@"\u2022 %@", self.recipe.ingredients[i]];
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:text attributes:normalAttributes];
            NSAttributedString *br = [[NSAttributedString alloc] initWithString:@"\n" attributes:lineAttributes];
            
            [ingredientsString appendAttributedString:br];
            [ingredientsString appendAttributedString:str1];
            [ingredientsString appendAttributedString:br];
        }
        
        textCell.secondaryLabel.attributedText = ingredientsString;
    }
    
    // Display Steps
    if ([key isEqualToString:StepsKey]) {
        textCell.titleLabel.text = NSLocalizedString(@"Steps", nil);
        
        NSMutableAttributedString *stepsString = [[NSMutableAttributedString alloc] init];
        
        for (int i=0; i<self.recipe.steps.count; i++) {
            NSString *num = [NSString stringWithFormat:@"Step %d: ", i+1];
            NSString *text = [NSString stringWithFormat:@"%@", self.recipe.steps[i]];
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:num attributes:boldAttributes];
            NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:text attributes:normalAttributes];
            NSAttributedString *br = [[NSAttributedString alloc] initWithString:@"\n" attributes:lineAttributes];
            
            [stepsString appendAttributedString:br];
            [stepsString appendAttributedString:str1];
            [stepsString appendAttributedString:str2];
            [stepsString appendAttributedString:br];
        }
        
        textCell.secondaryLabel.attributedText = stepsString;
    }
    
    return textCell;
}

@end
