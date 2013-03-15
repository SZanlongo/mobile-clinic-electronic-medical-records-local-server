//
//  BaseObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "BaseObject.h"
#define MAX_NUMBER_ITEMS 4
#import "StatusObject.h"
#import "CloudService.h"


@implementation BaseObject
@synthesize databaseObject;
#pragma mark - Initialization Methods
#pragma mark-
-(id)init
{
    self = [super init];
    if (self) {
        cloudAPI = [[CloudService alloc]init];
        self.databaseObject = [super CreateANewObjectFromClass:self.COMMONDATABASE isTemporary:YES];
    }
    return self;
}
-(id)initAndMakeNewDatabaseObject
{
    self = [super init];
    if (self) {
        cloudAPI = [[CloudService alloc]init];
        self.databaseObject = [super CreateANewObjectFromClass:self.COMMONDATABASE isTemporary:NO];
    }
    return self;
}
- (id)initAndFillWithNewObject:(NSDictionary *)info
{
    self = [self init];
    if (self) {
        cloudAPI = [[CloudService alloc]init];
        [self unpackageFileForUser:info];
    }
    return self;
}
-(id)initWithCachedObjectWithUpdatedObject:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        cloudAPI = [[CloudService alloc]init];
        NSString* objectID = [dic objectForKey:self.COMMONID];
        [self loadObjectForID:objectID];
        if (dic) {
            [self setValueToDictionaryValues:dic];
        }
    }
    return self;
}

#pragma mark - Convenience Methods
#pragma mark-
-(NSDictionary *)consolidateForTransmitting{
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithCapacity:1];    
    [consolidate setValue:[databaseObject dictionaryWithValuesForKeys:databaseObject.entity.attributeKeys] forKey:DATABASEOBJECT];
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    self.commands = [[data objectForKey:OBJECTCOMMAND]intValue];
    
    self.isLockedBy = [data objectForKey:ISLOCKEDBY];
    
    self.databaseObject = [self CreateANewObjectFromClass:self.COMMONDATABASE isTemporary:YES];
    
    [self setValueToDictionaryValues:[data objectForKey:DATABASEOBJECT]];
}

-(void)ServerCommand:(NSDictionary *)dataToBeRecieved withOnComplete:(ServerCommand)response{
    commandPattern = response;
}

-(void)setValueToDictionaryValues:(NSDictionary*)values{
    
    for (NSString* key in values.allKeys) {
        if (![[values objectForKey:key]isKindOfClass:[NSNull class]]) {
            [self.databaseObject setValue:[values objectForKey:key] forKey:key];
        }
    }
}

-(NSMutableDictionary*)getDictionaryValuesFromManagedObject:(NSManagedObject*)object{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    for (NSString* key in object.entity.attributesByName.allKeys) {
        [dict setValue:[object valueForKey:key] forKey:key];
    }
    return dict;
}

-(NSMutableDictionary*)getDictionaryValuesFromManagedObject{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    for (NSString* key in self.databaseObject.entity.attributesByName.allKeys) {
        [dict setValue:[self.databaseObject valueForKey:key] forKey:key];
    }
    return dict;
}

-(void)copyDictionaryValues:(NSDictionary*)dictionary intoManagedObject:(NSManagedObject*)mObject{
    for (NSString* key in dictionary.allKeys) {
        [mObject setValue:[dictionary objectForKey:key] forKey:key];
    }
}

-(void)CommonExecution{
    
}

-(void)setObject:(id)object withAttribute:(NSString *)attribute{
    [super setObject:object withAttribute:attribute inDatabaseObject:databaseObject];
}

-(id)getObjectForAttribute:(NSString *)attribute{
    return [super getObjectForAttribute:attribute inDatabaseObject:databaseObject];
}

-(void)setDBObject:(NSManagedObject *)DatabaseObject{
    databaseObject = DatabaseObject;
}

-(BOOL)isObject:(id)obj UniqueForKey:(NSString*)key
{
    // Check if it exists in database
    if ([self FindObjectInTable:self.COMMONDATABASE withName:obj forAttribute:key].count > 0) {
        return NO;
    }
    return YES;
}

#pragma mark- DATA RETRIEVAL & TELEPORTION Methods
#pragma mark-
// MARK: Converts and array of NSManagedObjects to an array of dictionaries
-(NSMutableArray*)convertListOfManagedObjectsToListOfDictionaries:(NSArray*)managedObjects{
    
    NSMutableArray* arrayWithDictionaries = [[NSMutableArray alloc]initWithCapacity:managedObjects.count];
    
    for (NSManagedObject* objs in managedObjects) {
        self.databaseObject = objs;
        [arrayWithDictionaries addObject:self.getDictionaryValuesFromManagedObject];
    }
    return arrayWithDictionaries;
}

// MARK: Send and array of dictionaries to the client
-(void)sendSearchResults:(NSArray*)results{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    [dict setValue:[NSNumber numberWithInteger:self.CLASSTYPE] forKey:OBJECTTYPE];
    
    [dict setValue:results forKey:ALLITEMS];
    
    [self sendInformation:dict toClientWithStatus:kSuccess andMessage:@"Server search completed"];
}

// MARK: Loads objects to an instantiated databaseObject
-(BOOL)loadObjectForID:(NSString *)objectID{
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:self.COMMONDATABASE withName:objectID forAttribute:self.COMMONID];
    
    if (arr.count == 1) {
        self.databaseObject = [arr objectAtIndex:0];
        return  YES;
    }
    return  NO;
}

-(NSManagedObject*)loadObjectWithID:(NSString *)objectID{
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:self.COMMONDATABASE withName:objectID forAttribute:self.COMMONID];
    if (arr.count > 0) {
        return [arr objectAtIndex:0];
    }
    return nil;
}

// MARK: Sends a Dictionary to the client
-(void)sendInformation:(id)data toClientWithStatus:(int)kStatus andMessage:(NSString*)message{
    if (!status) {
        status =[[StatusObject alloc]init];
    }
    // set data
    [status setData:data];
    
    // Set message
    [status setErrorMessage:message];
    
    // set status
    [status setStatus:kStatus];
    
    commandPattern([status consolidateForTransmitting]);
}

#pragma mark- SAVE Methods
#pragma mark-

// MARK: Saves the current databaseObject without duplicating it
-(void)saveObject:(ObjectResponse)eventResponse{
    
    id objID = [self.databaseObject valueForKey:self.COMMONID];
    
    NSManagedObject* obj = [self loadObjectWithID:objID];
    
    [obj setValuesForKeysWithDictionary:self.getDictionaryValuesFromManagedObject];
    
    if (obj){
        
        if (!self.databaseObject.managedObjectContext) {
            [self SaveCurrentObjectToDatabase:obj];
        }else{
            [self SaveCurrentObjectToDatabase:self.databaseObject];
        }
    }else{
        
        if (self.databaseObject.managedObjectContext) {
            [self SaveCurrentObjectToDatabase:self.databaseObject];
        }else{
            
            obj = [self CreateANewObjectFromClass:self.COMMONDATABASE isTemporary:NO];
            
            [obj setValuesForKeysWithDictionary:self.getDictionaryValuesFromManagedObject];
            
            [self SaveCurrentObjectToDatabase:obj];
        }
    }
    eventResponse(self, nil);
}

// MARK: Updates the object and sends the info to the client
-(void)UpdateObjectAndSendToClient{
    // Load old patient in global object and save new patient in variable
   NSManagedObject* oldValue = [self loadObjectWithID:[self.databaseObject valueForKey:self.COMMONID]];

    NSString* lockedByOlduser = [oldValue valueForKey:ISLOCKEDBY] ;
    
    BOOL isNotLockedUp = (!oldValue || [lockedByOlduser isEqualToString:self.isLockedBy] || lockedByOlduser.length == 0);
    
    if (isNotLockedUp) {
        // save to local database
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            if (!data) {
                [self sendInformation:nil toClientWithStatus:kError andMessage:error.localizedDescription];
            }else{
                [self sendInformation:[data getDictionaryValuesFromManagedObject] toClientWithStatus:kSuccess andMessage:@"Succesfully updated & synced"];
            }
        }];
    }else{
        [self sendInformation:nil toClientWithStatus:kError andMessage:[NSString stringWithFormat:@"This currently being used by %@",lockedByOlduser]];
    }

}

// MARK: Saves an array of Dictionaries
-(void)SaveListOfObjectsFromDictionary:(NSDictionary*)List
{
    // get all the users returned from server
    NSArray* arr = [List objectForKey:ALLITEMS];
    
    // Go through all users in array
    for (NSDictionary* dict in arr) {
        
        // Try and find previously existing value
        if(![self loadObjectForID:[dict objectForKey:self.COMMONID]]){
            self.databaseObject = [self CreateANewObjectFromClass:self.COMMONDATABASE isTemporary:NO];
        }
        [self setValueToDictionaryValues:dict];
        // Try and save while handling duplication control
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            
        }];
    }
}


@end
