//
//  BaseObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#define MAX_NUMBER_ITEMS 4

#import "BaseObject+Protected.h"



@implementation BaseObject
@synthesize CLASSTYPE,COMMONDATABASE,COMMONID,client,commands,objectType,databaseObject;


#pragma mark- Init Methods
#pragma mark-
+(NSString *)getCurrenUserName{
    return [[NSUserDefaults standardUserDefaults] stringForKey:CURRENT_USER];
}
-(id)init
{
    self = [super init];
    if (self) {
        self.databaseObject = [super CreateANewObjectFromClass:self.COMMONDATABASE isTemporary:YES];
    }
    return self;
}
-(id)initAndMakeNewDatabaseObject
{
    self = [super init];
    if (self) {
        self.databaseObject = [super CreateANewObjectFromClass:self.COMMONDATABASE isTemporary:NO];
    }
    return self;
}
- (id)initAndFillWithNewObject:(NSDictionary *)info
{
    self = [self init];
    if (self) {
        [self unpackageFileForUser:info];
    }
    return self;
}
-(id)initWithCachedObjectWithUpdatedObject:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        NSString* objectID = [dic objectForKey:self.COMMONID];
        [self loadObjectForID:objectID];
        if (dic) {
             [self setValueToDictionaryValues:dic];
        }
    }
    return self;
}
#pragma mark- Init Methods
#pragma mark-

-(void)unpackageFileForUser:(NSDictionary *)data{
    /* Setup some of variables that are common to all the
     * the object that inherit from this base class
     */
    self.commands = [[data objectForKey:OBJECTCOMMAND]intValue];
    [self.databaseObject setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
}



-(void)CommonExecution{
    NSLog(@"Not Implemented");
}

-(NSManagedObject*)loadObjectWithID:(NSString *)objectID{
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:self.COMMONDATABASE withName:objectID forAttribute:self.COMMONID];
    if (arr.count > 0) {
        return [arr objectAtIndex:0];
    }
    return nil;
}

/**
 * Transforms the native database object into a dictionary
 */


-(NSMutableDictionary*)getDictionaryValuesFromManagedObject{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    for (NSString* key in self.databaseObject.entity.attributesByName.allKeys) {
        [dict setValue:[self.databaseObject valueForKey:key] forKey:key];
    }
    return dict;
}

-(void)setDBObject:(NSManagedObject *)DatabaseObject{
    self.databaseObject = DatabaseObject;
}

-(void)setObject:(id)object withAttribute:(NSString *)attribute{
    [super setObject:object withAttribute:attribute inDatabaseObject:self.databaseObject];
}

-(id)getObjectForAttribute:(NSString *)attribute{
   return [super getObjectForAttribute:attribute inDatabaseObject:self.databaseObject];
}

-(void)saveObject:(ObjectResponse)eventResponse{
    
    id objID = [self.databaseObject valueForKey:self.COMMONID];
    
    NSManagedObject* obj = [self loadObjectWithID:objID];
    
    [obj setValuesForKeysWithDictionary:self.getDictionaryValuesFromManagedObject];
    
    if (obj){
        
        if (!self.databaseObject.managedObjectContext) {
            [self SaveAndRefreshObjectToDatabase:obj];
        }else{
            [self SaveAndRefreshObjectToDatabase:self.databaseObject];
        }
    }else{
        
        if (self.databaseObject.managedObjectContext) {
            [self SaveAndRefreshObjectToDatabase:self.databaseObject];
        }else{
            
            obj = [self CreateANewObjectFromClass:self.COMMONDATABASE isTemporary:NO];
            
            [obj setValuesForKeysWithDictionary:self.getDictionaryValuesFromManagedObject];
            
            [self SaveAndRefreshObjectToDatabase:obj];
        }
    }
    eventResponse(self, nil);
}
-(void)setValueToDictionaryValues:(NSDictionary*)values{
    
    for (NSString* key in values.allKeys) {
        if (![[values objectForKey:key]isKindOfClass:[NSNull class]]) {
            [self.databaseObject setValue:[values objectForKey:key] forKey:key];
        }
    }
}

-(BOOL)deleteCurrentlyHeldObjectFromDatabase{
    return [self deleteNSManagedObject:self.databaseObject];
}

-(BOOL)deleteDatabaseDictionaryObject:(NSDictionary *)object{
    return [self deleteObjectFromDatabase:self.COMMONDATABASE withDefiningAttribute:[object objectForKey:self.COMMONID] forKey:self.COMMONID];
}

-(BOOL)loadObjectForID:(NSString *)objectID{
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:self.COMMONDATABASE withName:objectID forAttribute:self.COMMONID];
    
    if (arr.count > 0) {
        self.databaseObject = [arr objectAtIndex:0];
        return  YES;
    }
    return  NO;
}



@end
