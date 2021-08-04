////////////////////////////////////////////////////////////////////////////////
//  Essential Oils
/// @file       CLFSuggestedOilsCell.m
/// @author     Lynette Sesodia
/// @date       4/11/16
//
//  Copyright © 2016 Cloforce LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "SuggestedOilsTableCell.h"
#import "MyOilCell.h"
#import "PFOil.h"
#import "UIImageView+AFNetworking.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kOilsCell @"MyOilCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface SuggestedOilsTableCell()

/**
 Boolean value indicating if the objects in the objectsArray are PFObjects AND if they should be fetched by default.
 @note By default shouldFetch is set to NO.
 */
@property (nonatomic) BOOL shouldFetch;

/// Array of PFObjects that are displayed in the cell's tableview.
@property (nonatomic, strong) NSArray *objectsArray;

@property (nonatomic, strong) IBOutlet UIView *headerBar;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation SuggestedOilsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellIconWidth = 42.5;
    
    [self.tableView registerNib:[UINib nibWithNibName:kOilsCell bundle:nil] forCellReuseIdentifier:kOilsCell];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = SuggestedOilsCellChildTableViewCellRowHeight;
    
    self.shouldFetch = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public

- (void)setObjectsForTableView:(NSArray *)objects shouldFetchData:(BOOL)shouldFetch {
    self.shouldFetch = shouldFetch;
    self.objectsArray = objects;
    self.tableViewHeight.constant = SuggestedOilsCellChildTableViewCellRowHeight * objects.count;
    [self.tableView reloadData];
    [self layoutIfNeeded];
}

- (void)shouldDisplayHeaderInBar:(BOOL)headerBar {
    if (headerBar == YES) {
        self.titleLabel.font = [UIFont titleFont];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor blackColor];
        self.headerBar.hidden = NO;
    } else {
        self.titleLabel.font = [UIFont titleFont];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor targetAccentColor];
        self.headerBar.hidden = YES;
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objectsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return SuggestedOilsCellChildTableViewCellRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOilCell *cell = [tableView dequeueReusableCellWithIdentifier:kOilsCell];
    cell.quantitySegmentedControl.hidden = YES;
    cell.iconImageViewWidthConstraint.constant = self.cellIconWidth;
    
    // Grab pointer object data if needed
    if (self.shouldFetch) {
        PFObject *obj = self.objectsArray[indexPath.row];
        [obj fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            NSString *name = obj[@"name"];
            cell.titleLabel.text = name.capitalizedString;
            cell.titleLabel.font = [UIFont textFont];
            
#ifdef DOTERRA
            if ([object[@"type"]  isEqualToString:@"RollOn"] || [object[@"type"] isEqualToString:@"RollOn-Light"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra-touch"];
            } else {
                cell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
            }
            cell.iconImageView.backgroundColor = [UIColor colorWithHexString:object[@"color"]];
#elif YOUNGLIVING
            cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving"];
            cell.iconImageView.backgroundColor = [UIColor colorWithHexString:object[@"color"]];
#else
            cell.iconImageView.image = [UIImage imageNamed:obj[@"uuid"]];
#endif
            
        }];
    } else {
        NSString *str = self.objectsArray[indexPath.row];
        cell.titleLabel.text = str.capitalizedString;

#ifdef DOTERRA
        PFObject *oil = self.objectsArray[indexPath.row];
        cell.iconImageView.image = [UIImage imageNamed:@"bottle-doterra"];
        cell.iconImageView.backgroundColor = [UIColor colorWithHexString:oil[@"color"]];
#elif YOUNGLIVING
        PFObject *oil = self.objectsArray[indexPath.row];
        cell.iconImageView.image = [UIImage imageNamed:@"bottle-youngliving"];
        cell.iconImageView.backgroundColor = [UIColor colorWithHexString:oil[@"color"]];
#endif
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
