//
//  MyOils+CoreDataProperties.h
//  GenericEO
//
//  Created by Lynette Sesodia on 6/16/18.
//  Copyright © 2018 Lynette Sesodia. All rights reserved.
//
//

#import "MyOils+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MyOils (CoreDataProperties)

+ (NSFetchRequest<MyOils *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *dateAdded;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *imageStr;
@property (nonatomic) BOOL inInventory;
@property (nonatomic) BOOL toBuy;
@property (nullable, nonatomic) NSNumber *amount;

@end

NS_ASSUME_NONNULL_END
