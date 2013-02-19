//
//  DatabaseDriver.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/1/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define OBJECTID          @"objectId"
#import <Foundation/Foundation.h>
#import "FIUAppDelegate.h"

@interface DatabaseDriver : NSObject 

@property(nonatomic, strong) FIUAppDelegate* appDelegate;



-(id)init;

-(NSManagedObject*)CreateANewObjectFromClass:(NSString *)name;
-(id)getValueForKey:(NSString *)key fromObject:(NSManagedObject*) obj;
-(void)SaveCurrentObjectToDatabase;


-(NSArray *)FindObjectInTable:(NSString *)table withCustomPredicate:(NSString *)predicateString andSortByAttribute:(NSString*)attribute;

-(NSArray*)FindObjectInTable:(NSString*)table withName:(id)name forAttribute:(NSString*)attribute;
@end
