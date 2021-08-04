////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       PFRecipe.h
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Parse/Parse.h>
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

@interface PFRecipe : PFObject <PFSubclassing>

/// User facing name of the recipe.
@property (nonatomic, strong) NSString *name;

/// Unique identifier for the recipe.
@property (nonatomic, strong) NSString *uuid;

/// User facing string for the servings amount the recipe makes.
@property (nonatomic, strong) NSString *amount;

/// String category of the recipe.
@property (nonatomic, strong) NSString *category;

/// Array of oils objects used in the recipe.
@property (nonatomic, strong) NSArray *oilsUsed;

/// Description of the recipe.
@property (nonatomic, strong) NSString *summaryDescription;

/// Array containing strings for each ingredient and its quantity.
@property (nonatomic, strong) NSArray *ingredients;

/// Array of strings for each recipe step.
@property (nonatomic, strong) NSArray *steps;

/// The parent ailment's UUID.
@property (nonatomic, strong) NSString *usedFor;

/// Any additional notes about the recipe.
@property (nonatomic, strong) NSString *note;

/// String URL for the picture source.
@property (nonatomic, strong) NSString *pictureURLString;

+ (NSString *)parseClassName;

/*
 Returns the url for the recipe picture.
 */
- (NSURL *)pictureURL;

@end
