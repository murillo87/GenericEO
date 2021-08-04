////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       SingleColumnTableTableViewCell.m
/// @author     Lynette Sesodia
/// @date       7/24/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "SingleColumnTableTableViewCell.h"
#import "Constants.h"
#import "TitleTableViewCell.h"
#import "PFOil.h"
#import "UIImageView+AFNetworking.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kTitleCell @"TitleTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface SingleColumnTableTableViewCell()

@property (nonatomic, strong) NSArray<NSString *> *optionsArray;

@property (nonatomic, strong) IBOutlet UIView *headerBar;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation SingleColumnTableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.tableView registerNib:[UINib nibWithNibName:kTitleCell bundle:nil] forCellReuseIdentifier:kTitleCell];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = SingleColumnTableTableViewCellChildTableViewCellRowHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Public

- (void)setStringsForTableView:(NSArray<NSString *> *)strings {
    self.optionsArray = strings;
    self.tableViewHeight.constant = SingleColumnTableTableViewCellChildTableViewCellRowHeight * strings.count;
    [self layoutIfNeeded];
    [self.tableView reloadData];
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
    return self.optionsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return SingleColumnTableTableViewCellChildTableViewCellRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleCell];
    NSString *str = self.optionsArray[indexPath.row];
    cell.titleLabel.text = str;
    cell.titleLabel.font = [UIFont textFont];
    cell.titleLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
