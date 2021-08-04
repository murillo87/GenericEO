////////////////////////////////////////////////////////////////////////////////
//  Generic EO
/// @file       CoreDataManager.m
/// @author     Lynette Sesodia
/// @date       6/16/18
//
//  Copyright © 2018 Essentl LLC. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

///-----------------------------------------
///  File Inclusion
///-----------------------------------------

#import "CoreDataManager.h"

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
///  Static Data
///-----------------------------------------

///-----------------------------------------
///  Object Declarations
///-----------------------------------------

@interface CoreDataManager()

@end

///-----------------------------------------
///  Object Definitions
///-----------------------------------------

@implementation CoreDataManager

+ (instancetype)sharedManager {
    static CoreDataManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[CoreDataManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - My Oils

- (NSArray<MyOils *> *)getOils {
    return [MyOils MR_findAllSortedBy:@"name" ascending:YES];
}

- (NSArray<MyOils *> *)getInventoryOils {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inInventory == YES"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    return [[MyOils MR_findAllWithPredicate:predicate] sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSArray<MyOils *> *)getShoppingListOils {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toBuy == YES"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    return [[MyOils MR_findAllWithPredicate:predicate] sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (MyOils *)getOilById:(NSString *)identifier {
    return [MyOils MR_findFirstByAttribute:@"uuid" withValue:identifier];
}

- (void)saveOil:(PFObject *)oil
    toInventory:(BOOL)inInventory
 toShoppingList:(BOOL)inShoppingList
 withCompletion:(void (^)(BOOL, NSError *))completion {
    
    // Verify the oil has not already been added
    MyOils *existingOil = [self getOilById:oil[@"uuid"]];
    if (!existingOil) {
        
        // Save new oil
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            MyOils *myOil = [MyOils MR_createEntityInContext:localContext];
            myOil.name = [oil valueForKey:@"name"];
            myOil.uuid = [oil valueForKey:@"uuid"];
            myOil.dateAdded = [NSDate date];
            myOil.inInventory = inInventory;
            myOil.toBuy = inShoppingList;
            myOil.amount = 1;
            
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            completion(contextDidSave, error);
        }];
    } else {
        if (inInventory == YES) {
            [self changeOil:existingOil inventoryStatus:YES withCompletion:^(BOOL didUpdate, NSError *error) {
                completion(didUpdate, error);
            }];
        }
        
        if (inShoppingList == YES) {
            [self changeOil:existingOil shoppingListStatus:YES withCompletion:^(BOOL didUpdate, NSError *error) {
                completion(didUpdate, error);
            }];
        }
    }
}

- (void)changeOil:(MyOils *)oil shoppingListStatus:(BOOL)toBuy withCompletion:(void(^)(BOOL didUpdate, NSError *error))completion {
    oil.toBuy = toBuy;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        completion(contextDidSave, error);
    }];
}

- (void)changeOil:(MyOils *)oil inventoryStatus:(BOOL)inInventory withCompletion:(void(^)(BOOL didUpdate, NSError *error))completion {
    oil.inInventory = inInventory;
    
    if (inInventory == YES) {
        if (oil.amount < 1) {
            oil.amount = 1;
        }
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        completion(contextDidSave, error);
    }];
}

- (void)changeOil:(MyOils *)oil identifier:(NSString *)identifier withCompletion:(void (^)(BOOL, NSError *))completion {
    oil.uuid = identifier;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        completion(contextDidSave, error);
    }];
}

- (void)changeOil:(MyOils *)oil inventoryAmount:(double)amount withCompletion:(void(^)(BOOL success, NSError *error))completion {
    oil.amount = amount;

    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        completion(contextDidSave, error);
    }];
}

- (void)removeOil:(MyOils *)oil fromInventory:(BOOL)inventory fromShoppingList:(BOOL)shoppingList withCompletion:(void (^)(BOOL, NSError *))completion {
    
    // Remove from inventory if selected
    if (inventory == YES) {
        oil.inInventory = NO;
    }
    
    // Remove from shopping list if selected
    if (shoppingList == YES) {
        oil.toBuy = NO;
    }

    // Determine if the oil will still remain in either the inventory or shopping list
    // If it no longer remains, remove from my oils
    if (oil.inInventory == NO && oil.toBuy == NO) {
        [oil MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                completion(contextDidSave, error);
            }];
        });
    } else {
        // If it remains in one, save updates
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            completion(contextDidSave, error);
        }];
    }
}

#pragma mark - MyNotes

- (NSArray<MyNotes *> *)getNotes {
    return [MyNotes MR_findAllSortedBy:@"name" ascending:YES];
}

- (NSArray<MyNotes *> *)getOilNotes {
#ifdef GENERIC
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"-10-"];
#elif DOTERRA
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"MyEO-DT-10-"];
#elif YOUNGLIVING
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"MyEO-YL-10-"];
#endif
    return [MyNotes MR_findAllWithPredicate:predicate];
}

- (NSArray<MyNotes *> *)getGuideNotes {
#ifdef GENERIC
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"-01-"];
#elif DOTERRA
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"MyEO-DT-01-"];
#elif YOUNGLIVING
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"MyEO-YL-01-"];
#endif
    return [MyNotes MR_findAllWithPredicate:predicate];
}

- (NSArray<MyNotes *> *)getRecipeNotes {
#ifdef GENERIC
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"-02-"];
#elif DOTERRA
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"MyEO-DT-02-"];
#elif YOUNGLIVING
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"MyEO-YL-02-"];
#endif
    return [MyNotes MR_findAllWithPredicate:predicate];
}

- (MyNotes *)getNoteForID:(NSString *)identifier {
    return [MyNotes MR_findFirstByAttribute:@"uuid" withValue:identifier];
}

- (void)saveNoteWithText:(NSString *)noteText forObject:(PFObject *)object withCompetion:(void(^)(BOOL didSave, NSError *error))completion {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        MyNotes *note = [MyNotes MR_createEntityInContext:localContext];
        note.text = noteText;
        note.dateAdded = [NSDate date];
        note.name = object[@"name"];
        note.uuid = object[@"uuid"];
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        completion(contextDidSave, error);
    }];
    
}

- (void)updateNote:(MyNotes *)note withText:(NSString *)text completion:(void (^)(BOOL, NSError *))completion {
    note.text = text;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            completion(contextDidSave, error);
        }];
    });
}

- (void)updateNote:(MyNotes *)note withParentID:(NSString *)identifier completion:(void(^)(BOOL success, NSError *error))completion {
    note.uuid = identifier;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            completion(contextDidSave, error);
        }];
    });
}

- (void)deleteNote:(MyNotes *)note withCompletion:(void(^)(BOOL didDelete, NSError *error))completion {
    [note MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            completion(contextDidSave, error);
        }];
    });
}

#pragma mark - Favorites

- (NSArray<Favorites *> *)getAllFavorites {
    return [Favorites MR_findAllSortedBy:@"name" ascending:YES];
}

- (NSArray<Favorites *> *)getFavoriteOils {
#ifdef GENERIC
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"-10-"];
#elif DOTERRA
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"MyEO-DT-10-"];
#elif AB_DOTERRA
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"MyEO-DT-10-"];
#elif YOUNGLIVING
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"MyEO-YL-10-"];
#endif
    return [Favorites MR_findAllWithPredicate:predicate];
}

- (NSArray<Favorites *> *)getFavoriteGuides {
#ifdef GENERIC
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"-01-"];
#elif DOTERRA
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"MyEO-DT-01-"];
#elif YOUNGLIVING
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"MyEO-YL-01-"];
#endif
    return [Favorites MR_findAllWithPredicate:predicate];
}

- (NSArray<Favorites *> *)getFavoriteRecipes {
#ifdef GENERIC
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"-02-"];
#elif DOTERRA
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"MyEO-DT-02-"];
#elif YOUNGLIVING
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid CONTAINS[cd] %@", @"MyEO-YL-02-"];
#endif
    return [Favorites MR_findAllWithPredicate:predicate];
}

- (Favorites *)getFavoriteById:(NSString *)identifier {
    return [Favorites MR_findFirstByAttribute:@"uuid" withValue:identifier];
}

- (void)addFavorite:(PFObject *)obj withCompletion:(void (^)(BOOL, NSError *))completion {
    if (![self getFavoriteById:obj[@"uuid"]]) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            Favorites *fav = [Favorites MR_createEntityInContext:localContext];
            fav.name = [obj valueForKey:@"name"];
            fav.uuid = [obj valueForKey:@"uuid"];
            fav.dateAdded = [NSDate date];
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            completion(contextDidSave, error);
        }];
    }
}

- (void)removeFavorite:(Favorites *)fav withCompletion:(void (^)(BOOL, NSError *))completion {
    [fav MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            completion(contextDidSave, error);
        }];
    });
}


@end
