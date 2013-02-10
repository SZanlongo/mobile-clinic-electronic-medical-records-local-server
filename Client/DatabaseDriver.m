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
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetch setSortDescriptors:sortDescriptors];
    
    return [self fetchElementsUsingFetchRequest:fetch withTable:table];

}

-(BOOL)CreateANewObjectFromClass:(NSString *)name{
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:appDelegate.managedObjectContext];
    databaseObject =[[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:appDelegate.managedObjectContext];
    return [self doesDatabaseObjectExists];
}

-(void)SaveCurrentObjectToDatabase{
    [appDelegate saveContext];
}

-(NSArray *)FindObjectInTable:(NSString *)table withCustomPredicate:(NSString *)predicateString andSortByAttribute:(NSString*)attribute{

    
    if (predicateString.length > 0) {
      
        NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
        
        [fetch setSortDescriptors:sortDescriptors];

        NSPredicate *sort = [NSPredicate predicateWithFormat:predicateString];
        
        [fetch setPredicate:sort];
       
        return [self fetchElementsUsingFetchRequest:fetch withTable:table];
    }
    return nil;
}


-(NSArray*)fetchElementsUsingFetchRequest:(NSFetchRequest*)request withTable:(NSString*)tableName{
    
     NSManagedObjectContext* ctx = appDelegate.managedObjectContext;
    
    if (ctx) {
        NSEntityDescription* semesterEntity = [NSEntityDescription entityForName:tableName inManagedObjectContext: ctx];

        [request setEntity:semesterEntity];
        
        [request setFetchBatchSize:15];
        
        NSError *error  = nil;
        
        NSArray*  temp = [NSArray arrayWithArray: [ctx executeFetchRequest:request error:&error]];
        
        if (error) {
            NSLog(@"ERROR: DATAMODEL COULD NOT FETCH");
            return nil;
        }
        return temp;
    }
    return nil;
}
@end
