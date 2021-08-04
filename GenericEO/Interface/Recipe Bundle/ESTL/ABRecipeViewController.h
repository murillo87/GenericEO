////////////////////////////////////////////////////////////////////////////////
//  Essential Oils
/// @file       ABRecipeViewController.h
/// @author     Lynette Sesodia
/// @date       7/16/20
//
//  Copyright © 2020 Lynette Sesodia. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"

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

@interface ABRecipeViewController : RecipeViewController <UITableViewDelegate, UITableViewDataSource>

- (void)reviewProcessingDidFinishWithRatingAverage:(double)average;

@end

NS_ASSUME_NONNULL_END
