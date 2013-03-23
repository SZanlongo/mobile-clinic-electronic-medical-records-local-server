//
//  Database.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/18/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "DatabaseProtocol.h"
#import <Foundation/Foundation.h>

@interface Database : NSObject<DatabaseProtocol>

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;



@end
