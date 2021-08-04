////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       TwoColumnTableTableViewCell.h
/// @author     Lynette Sesodia
/// @date       3/21/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "TwoColumnTableTableViewCell.h"
#import "TwoColumnTableViewCell.h"
#import "Constants.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kTwoColumnCell @"TwoColumnTableViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface TwoColumnTableTableViewCell()

@property (nonatomic, strong) NSArray<NSDictionary *> *optionsArray;

@property (nonatomic, strong) IBOutlet UIView *headerBar;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation TwoColumnTableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.tableView registerNib:[UINib nibWithNibName:kTwoColumnCell bundle:nil] forCellReuseIdentifier:kTwoColumnCell];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = TwoColumnTableTableViewCellChildTableViewCellRowHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public

- (void)setStringsForTableView:(NSArray<NSDictionary *> *)strings {
    self.optionsArray = strings;
    self.tableViewHeight.constant = TwoColumnTableTableViewCellChildTableViewCellRowHeight * strings.count;
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
    return TwoColumnTableTableViewCellChildTableViewCellRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TwoColumnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTwoColumnCell];
    NSDictionary *rowDict = self.optionsArray[indexPath.row];
    
    cell.leftLabel.text = [rowDict valueForKey:@"left"];
    cell.rightLabel.text = [rowDict valueForKey:@"right"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
