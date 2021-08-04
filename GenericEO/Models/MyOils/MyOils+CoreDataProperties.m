//
//  MyOils+CoreDataProperties.m
//  GenericEO
//
//  Created by Lynette Sesodia on 6/16/18.
//  Copyright © 2018 Lynette Sesodia. All rights reserved.
//
//

#import "MyOils+CoreDataProperties.h"

@implementation MyOils (CoreDataProperties)

+ (NSFetchRequest<MyOils *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"MyOils"];
}

@dynamic dateAdded;
@dynamic name;
@dynamic uuid;
@dynamic imageStr;

@end
