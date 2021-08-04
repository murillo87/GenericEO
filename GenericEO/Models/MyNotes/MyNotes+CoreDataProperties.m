//
//  MyNotes+CoreDataProperties.m
//  GenericEO
//
//  Created by Lynette Sesodia on 6/16/18.
//  Copyright © 2018 Lynette Sesodia. All rights reserved.
//
//

#import "MyNotes+CoreDataProperties.h"

@implementation MyNotes (CoreDataProperties)

+ (NSFetchRequest<MyNotes *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"MyNotes"];
}

@dynamic dateAdded;
@dynamic uuid;
@dynamic text;
@dynamic name;

@end
