////////////////////////////////////////////////////////////////////////////////
//  SleepSoundsPro
/// @file       MenuCollectionView.h
/// @author     Lynette Sesodia
/// @date       3/26/20
//
//  Copyright © 2020 Cloforce LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>

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
///  Object Declarations
///-----------------------------------------

NS_ASSUME_NONNULL_BEGIN

@protocol MenuCollectionViewDelegate;

@interface MenuCollectionView : UIView

/// The delegate for the MenuCollectionView to communicate user interactions with.
@property (nonatomic, weak) id<MenuCollectionViewDelegate> delegate;

/// Reloads the collection view with the given menu items.
- (void)setMenuItems:(NSArray *)items;

@end

/// Delegate for the MenuCollectionView.
@protocol MenuCollectionViewDelegate <NSObject>

@required

/**
 Informs the delegate that an item was selected in the menu.
 @param view The current MenuCollectionView.
 @param item The item that was selected.
 @param indexPath The index path that was selected.
 */
- (void)menuCollectionView:(MenuCollectionView *)view didSelectItem:(NSString *)item atIndexPath:(NSIndexPath *)indexPath;

/**
Informs the delegate that an item was selected in the menu.
@param view The current MenuCollectionView.
@param item The item that was selected.
@param indexPath The index path that was selected.
*/
- (void)menuCollectionView:(MenuCollectionView *)view didDeSelectItem:(NSString *)item atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
