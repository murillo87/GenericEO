////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       CoreDataManager.h
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import <Parse/Parse.h>

#import "MyOils+CoreDataClass.h"
#import "MyNotes+CoreDataClass.h"
#import "Favorites+CoreDataClass.h"

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

@interface CoreDataManager : NSObject

+ (instancetype)sharedManager;

#pragma mark - MyOils

/**
 Returns array of my oils saved in core data.
 */
- (NSArray<MyOils *> *)getOils;

/**
 Returns array of myOils in the user's inventory.
 */
- (NSArray<MyOils *> *)getInventoryOils;

/**
 Returns array of myOils for the shopping list.
 */
- (NSArray<MyOils *> *)getShoppingListOils;

/**
 Returns the saved oil object if oil has been previously saved to MyOils in core data.
 @param identifier The string object id for the oil object. Follows format: ParseClassName-ParseObjectID
 */
- (MyOils *)getOilById:(NSString *)identifier;

/**
 Saves a new oil to Core Data store.
 @param oil PFObject for the oil being saved.
 @param inInventory Boolean value indicating if the oil should be saved to the user inventory.
 @param inShoppingList Boolean value indicating if the oil should be saved to the user's shopping list.
 */
- (void)saveOil:(PFObject *)oil
    toInventory:(BOOL)inInventory
 toShoppingList:(BOOL)inShoppingList
 withCompletion:(void(^)(BOOL didSave, NSError *error))completion;

/**
 Updates the inventory status for a saved MyOil object.
 @param inInventory Boolean value indicating if the oil should be included in inventory.
 */
- (void)changeOil:(MyOils *)oil inventoryStatus:(BOOL)inInventory withCompletion:(void(^)(BOOL didUpdate, NSError *error))completion;

/**
 Updates the shopping list value for a saved MyOil object.
 @param toBuy Boolean value indicating if the oil should be included on the shopping list.
 */
- (void)changeOil:(MyOils *)oil shoppingListStatus:(BOOL)toBuy withCompletion:(void(^)(BOOL didUpdate, NSError *error))completion;

/**
 Updates the inventory amount for a saved MyOil object.
 @param oil MyOil object to be updated.
 @param amount The new amount for the quantity left.
 */
- (void)changeOil:(MyOils *)oil inventoryAmount:(double)amount withCompletion:(void(^)(BOOL success, NSError *error))completion;

/**
 Updates the identifier for a saved MyOil object.
 @param oil MyOil object to be updated.
 @param identifier The new identifier for the parseObjectID.
 */
- (void)changeOil:(MyOils *)oil identifier:(NSString *)identifier withCompletion:(void (^)(BOOL, NSError *))completion;

/**
 Removes the given oil from the inventory or shopping list. If the oil is no longer in either, it is removed form the core data store.
 @param oil Core Data object being removed.
 @param inventory Boolean value indicating if the oil object should be removed from Inventory.
 @param shoppingList Boolean value indicating if the oil object should be removed from the Shopping List.
 */
- (void)removeOil:(MyOils *)oil
    fromInventory:(BOOL)inventory
 fromShoppingList:(BOOL)shoppingList
   withCompletion:(void (^)(BOOL, NSError *))completion;

#pragma mark - MyNotes

/**
 Saves a new note to Core Data store.
 @param noteText Complete text string for note.
 @param object The parse object that the note is for.
 */
- (void)saveNoteWithText:(NSString *)noteText forObject:(PFObject *)object withCompetion:(void(^)(BOOL didSave, NSError *error))completion;

/**
 Updates an existing note with new text.
 @param note The existing note object.
 @param text The new note text.
 */
- (void)updateNote:(MyNotes *)note withText:(NSString *)text completion:(void(^)(BOOL didUpdate, NSError *error))completion;

/**
 Updates an existing note with new parent object identifier.
 @param note The existing note object.
 @param identifier The new parent object identifier for the note.
 */
- (void)updateNote:(MyNotes *)note withParentID:(NSString *)identifier completion:(void(^)(BOOL success, NSError *error))completion;

/**
 Removes the given note from the Core Data store.
 @param note The saved Core Data object to be removed.
 */
- (void)deleteNote:(MyNotes *)note withCompletion:(void(^)(BOOL didDelete, NSError *error))completion;

/**
 Returns array of all saved notes.
 */
- (NSArray<MyNotes *> *)getNotes;

/**
 Returns array of all notes for oil objects.
 */
- (NSArray<MyNotes *> *)getOilNotes;

/**
 Returns array of all notes for usage guide objects.
 */
- (NSArray<MyNotes *> *)getGuideNotes;

/**
 Returns array of all notes for recipe objects.
 */
- (NSArray<MyNotes *> *)getRecipeNotes;

/**
 Returns note for the object if it exists.
 @param identifier The string object id for the note's parent object. Follows format: ParseClassName-ParseObjectID
 */
- (MyNotes *)getNoteForID:(NSString *)identifier;

#pragma mark - Favorites

/**
 Returns array of all favorites objects.
 */
- (NSArray<Favorites *> *)getAllFavorites;

/**
 Returns array of all favorite oil objects.
 */
- (NSArray<Favorites *> *)getFavoriteOils;

/**
 Returns array of all favorite guide objects.
 */
- (NSArray<Favorites *> *)getFavoriteGuides;

/**
 Returns array of all favorite recipe objects.
 */
- (NSArray<Favorites *> *)getFavoriteRecipes;

/**
 Returns the favorite object if oil has been previously saved to Favorites in core data.
 @param identifier The string uuid for the object.
 */
- (Favorites *)getFavoriteById:(NSString *)identifier;

/**
 Saves a new favorite to Core Data store.
 @param obj PFObject for the object being saved.
 */
- (void)addFavorite:(PFObject *)obj withCompletion:(void(^)(BOOL didSave, NSError *error))completion;
/**
 Removes the given favorite from the Core Data Store.
 @param fav Core Data object being removed.
 */
- (void)removeFavorite:(Favorites *)fav withCompletion:(void(^)(BOOL didDelete, NSError *error))completion;


@end
