////////////////////////////////////////////////////////////////////////////////
//  SleepSoundsPro
/// @file       MenuCollectionView.m
/// @author     Lynette Sesodia
/// @date       3/26/20
//
//  Copyright © 2020 Cloforce LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "MenuCollectionView.h"
#import "MenuCollectionViewCell.h"

///-----------------------------------------
///  Macro Definitions
///-----------------------------------------

///-----------------------------------------
///  Type Definitions
///-----------------------------------------

#define kMenuCell @"MenuCollectionViewCell"

///-----------------------------------------
///  Global Data
///-----------------------------------------

///-----------------------------------------
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface MenuCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource>

/// Collection view for the menu.
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

/// The menu items displayed in the collection view.
@property (nonatomic, strong) NSArray *collectionViewItems;

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation MenuCollectionView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self loadNib];
        [self configureCollectionView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadNib];
        [self configureCollectionView];
    }
    return self;
}

#pragma mark UI

- (void)loadNib {
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"MenuCollectionView" owner:self options:nil] firstObject];
    [self addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": view}]];

    [self layoutIfNeeded];
}

- (void)configureCollectionView {
    // Create the collection view layout
    self.backgroundColor = [UIColor clearColor];
    CGFloat margin = 8.0;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = margin;
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
    flowLayout.estimatedItemSize = CGSizeMake(60, 33);

    [self.collectionView registerNib:[UINib nibWithNibName:kMenuCell bundle:nil] forCellWithReuseIdentifier:kMenuCell];
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

#pragma mark Public Setup

- (void)setMenuItems:(NSArray *)items {
    self.collectionViewItems = items;
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.selected == YES) {
        //[cell setSelected:NO];
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [self.delegate menuCollectionView:self didDeSelectItem:self.collectionViewItems[indexPath.row] atIndexPath:indexPath];
    } else {
        //[cell setSelected:YES];
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self.delegate menuCollectionView:self didSelectItem:self.collectionViewItems[indexPath.row] atIndexPath:indexPath];
    }
    
    return false;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionViewItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMenuCell forIndexPath:indexPath];
    cell.titleLabel.text = self.collectionViewItems[indexPath.row];
    cell.tintColor = self.tintColor;
    return cell;
}


@end
