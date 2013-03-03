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

-(NSArray*)FindObjectInTable:(NSString*)table withName:(NSString*)name forAttribute:(NSString*)attribute{
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetch setSortDescriptors:sortDescriptors];
    
    
    if (name.length > 0) {
        NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",attribute,name];
        [fetch setPredicate:pred];
    }
    
    return [self fetchElementsUsingFetchRequest:fetch withTable:table];

}

-(NSManagedObject*)CreateANewObjectFromClass:(NSString *)name isTemporary:(BOOL)temporary{
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:appDelegate.managedObjectContext];
    return [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:(temporary)?nil:appDelegate.managedObjectContext];
}

-(void)SaveCurrentObjectToDatabase{
    [appDelegate saveContext];
}
-(void)SaveAndRefreshObjectToDatabase:(NSManagedObject *)object{
    [self SaveCurrentObjectToDatabase];
    [appDelegate.managedObjectContext refreshObject:object mergeChanges:YES];
}
-(NSArray *)FindObjectInTable:(NSString *)table withCustomPredicate:(NSPredicate *)predicateString andSortByAttribute:(NSString*)attribute{

    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetch setSortDescriptors:sortDescriptors];
   
    if (predicateString) {
        [fetch setPredicate:predicateString];
    }
    
    return [self fetchElementsUsingFetchRequest:fetch withTable:table];
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

-(void)setObject:(id)object withAttribute:(NSString*)attribute inDatabaseObject:(NSManagedObject*)DBObject{
    [DBObject setValue:object forKey:attribute];
}
-(id)getObjectForAttribute:(NSString*)attribute inDatabaseObject:(NSManagedObject*)DBObject{
   return [DBObject valueForKey:attribute];
}
@end
