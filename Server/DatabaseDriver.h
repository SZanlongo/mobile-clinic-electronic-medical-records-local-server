//
//  DatabaseDriver.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/1/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define OBJECTID          @"objectId"
#import <Foundation/Foundation.h>
#import "DatabaseDriverProtocol.h"
#import "FIUAppDelegate.h"

@interface DatabaseDriver : NSObject<DatabaseDriverProtocol>{
    FIUAppDelegate* appDelegate;
}

-(id)init;

-(id)getValueForKey:(NSString *)key FromObject:(NSManagedObject*)databaseObject;
-(NSManagedObject*)CreateANewObjectFromClass:(NSString *)name;
-(void)SaveCurrentObjectToDatabase:(NSManagedObject*)databaseObject;

-(NSArray *)FindObjectInTable:(NSString *)table withCustomPredicate:(NSPredicate *)predicateString andSortByAttribute:(NSString*)attribute;

-(NSArray*)FindObjectInTable:(NSString*)table withName:(id)name forAttribute:(NSString*)attribute;
@end
