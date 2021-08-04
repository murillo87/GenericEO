//
//  Favorites+CoreDataProperties.h
//  GenericEO
//
//  Created by Lynette Sesodia on 7/26/18.
//  Copyright © 2018 Lynette Sesodia. All rights reserved.
//
//

#import "Favorites+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Favorites (CoreDataProperties)

+ (NSFetchRequest<Favorites *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *dateAdded;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
