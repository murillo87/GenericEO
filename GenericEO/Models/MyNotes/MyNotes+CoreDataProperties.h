//
//  MyNotes+CoreDataProperties.h
//  GenericEO
//
//  Created by Lynette Sesodia on 6/16/18.
//  Copyright © 2018 Lynette Sesodia. All rights reserved.
//
//

#import "MyNotes+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MyNotes (CoreDataProperties)

+ (NSFetchRequest<MyNotes *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *dateAdded;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *text;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
