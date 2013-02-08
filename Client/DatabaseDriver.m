//
//  DatabaseDriver.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/1/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "DatabaseDriver.h"

@implementation DatabaseDriver
@synthesize appDelegate;
-(id)init{
    if (self = [super init]) {
        appDelegate = (FIUAppDelegate*)[[UIApplication sharedApplication]delegate];
    }
return self;
}

-(void)addObjectToDatabaseObject:(id)obj forKey:(NSString*)key{
    [databaseObject setValue:obj forKey:key];
}
-(id)getValueForKey:(NSString *)key{
   return [databaseObject valueForKey:key];
}
-(id)getValueForKey:(NSString *)key fromObject:(NSManagedObject *)obj{
    return [obj valueForKey:key];
}
-(BOOL)doesDatabaseObjectExists{
    if (databaseObject) {
        return YES;
    }
    return NO;
}



-(NSArray*)FindObjectInTable:(NSString*)table withName:(id)name forAttribute:(NSString*)attribute{
    
    NSManagedObjectContext* ctx = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:table inManagedObjectContext:ctx];
    
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    //Narrows down list to classes in current semester
    if (name && attribute.length > 0) {
        NSPredicate *sort = [NSPredicate predicateWithFormat:@"%K == %@",attribute, name];
        [fetchRequest setPredicate:sort];
    }
    
    // Edit the sort key as appropriate.
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
	NSError *error = nil;
    
    NSArray* array = [ctx executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        return array;
    }
    //Address Error
    return nil;
}

-(BOOL)CreateANewObjectFromClass:(NSString *)name{
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:appDelegate.managedObjectContext];
    databaseObject =[[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:appDelegate.managedObjectContext];
    return [self doesDatabaseObjectExists];
}

-(void)SaveCurrentObjectToDatabase{
    [appDelegate saveContext];
}



-(NSArray*)getListFromTable:(NSString*)tableName sortByAttr:(NSString*)sortAttr
{
    NSManagedObjectContext* ctx = appDelegate.managedObjectContext;
    
    if (ctx) {
        NSEntityDescription* semesterEntity = [NSEntityDescription entityForName:tableName inManagedObjectContext: ctx];
        
        NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
        [fetch setEntity:semesterEntity];
        [fetch setFetchBatchSize:15];
        
        //Creates a method to sort information
        NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortAttr ascending:NO];
        NSArray* sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
        
        [fetch setSortDescriptors:sortDescriptors];
        
        NSError *error  = nil;
        NSArray*  temp = [NSArray arrayWithArray: [ctx executeFetchRequest:fetch error:&error]];
        
        if (error) {
            NSLog(@"ERROR: DATAMODEL COULD NOT FETCH %@ MANAGE OBJECT",tableName);
            return nil;
        }
        
        NSLog(@"Number of items from table %@: %i",tableName,temp.count);
        
        return temp;

    }
    return nil;
}
@end
