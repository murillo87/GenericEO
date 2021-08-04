//
//  Favorites+CoreDataProperties.m
//  GenericEO
//
//  Created by Lynette Sesodia on 7/26/18.
//  Copyright © 2018 Lynette Sesodia. All rights reserved.
//
//

#import "Favorites+CoreDataProperties.h"

@implementation Favorites (CoreDataProperties)

+ (NSFetchRequest<Favorites *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Favorites"];
}

@dynamic dateAdded;
@dynamic name;
@dynamic uuid;

@end
