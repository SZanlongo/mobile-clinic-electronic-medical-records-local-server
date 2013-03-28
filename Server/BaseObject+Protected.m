//
//  BaseObject+Protected.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/26/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "BaseObject+Protected.h"

@implementation BaseObject (Protected)

-(void)makeCloudCallWithCommand:(NSString *)command withObject:(id)object onComplete:(CloudCallback)onComplete{
    
    [[CloudService cloud] query:command parameters:object  completion:^(NSError *error, NSDictionary *result) {
        //TODO: Create progress bar
        onComplete(result,error);
        NSLog(@"BASEOBJECT LOG: %@",result);
    }];
    
}


-(void)copyDictionaryValues:(NSDictionary*)dictionary intoManagedObject:(NSManagedObject*)mObject{
    for (NSString* key in dictionary.allKeys) {
        [mObject setValue:[dictionary objectForKey:key] forKey:key];
    }
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

-(BOOL)isObject:(id)obj UniqueForKey:(NSString*)key
{
    // Check if it exists in database
    if ([self FindObjectInTable:self->COMMONDATABASE withName:obj forAttribute:key].count > 0) {
        return NO;
    }
    return YES;
}

// MARK: Loads objects to an instantiated databaseObject
-(BOOL)loadObjectForID:(NSString *)objectID{
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:self->COMMONDATABASE withName:objectID forAttribute:self->COMMONID];
    
    if (arr.count == 1) {
        self->databaseObject = [arr objectAtIndex:0];
        return  YES;
    }
    return  NO;
}

-(NSManagedObject*)loadObjectWithID:(NSString *)objectID{
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:self->COMMONDATABASE withName:objectID forAttribute:self->COMMONID];
    if (arr.count > 0) {
        return [arr objectAtIndex:0];
    }
    return nil;
}

// MARK: Converts and array of NSManagedObjects to an array of dictionaries
-(NSMutableArray*)convertListOfManagedObjectsToListOfDictionaries:(NSArray*)managedObjects{
    
    NSMutableArray* arrayWithDictionaries = [[NSMutableArray alloc]initWithCapacity:managedObjects.count];
    
    for (NSManagedObject* objs in managedObjects) {
        self->databaseObject = objs;
        [arrayWithDictionaries addObject:self.getDictionaryValuesFromManagedObject];
    }
    return arrayWithDictionaries;
}

// MARK: Send and array of dictionaries to the client
-(void)sendSearchResults:(NSArray*)results{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    [dict setValue:[NSNumber numberWithInteger:self->CLASSTYPE] forKey:OBJECTTYPE];
    
    [dict setValue:results forKey:ALLITEMS];
    
    [self sendInformation:dict toClientWithStatus:kSuccess andMessage:@"Server search completed"];
}

-(void)setObject:(id)object withAttribute:(NSString *)attribute{
    [super setObject:object withAttribute:attribute inDatabaseObject:self->databaseObject];
}

-(id)getObjectForAttribute:(NSString *)attribute{
    return [super getObjectForAttribute:attribute inDatabaseObject:self->databaseObject];
}


// MARK: Updates the object and sends the info to the client
-(void)UpdateObjectAndSendToClient{
    // Load old patient in global object and save new patient in variable
    NSManagedObject* oldValue = [self loadObjectWithID:[self->databaseObject valueForKey:self->COMMONID]];
    
    NSString* lockedByOlduser = [oldValue valueForKey:ISLOCKEDBY] ;
    
    BOOL isNotLockedUp = (!oldValue || [lockedByOlduser isEqualToString:self->isLockedBy] || lockedByOlduser.length == 0);
    
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

-(void)CommonExecution{
    
}



-(void)unpackageFileForUser:(NSDictionary *)data{
    self->commands = [[data objectForKey:OBJECTCOMMAND]intValue];
    
    self->isLockedBy = [data objectForKey:ISLOCKEDBY];
    
    self->databaseObject = [self CreateANewObjectFromClass:self->COMMONDATABASE isTemporary:YES];
    
    BOOL success = [self setValueToDictionaryValues:[data objectForKey:DATABASEOBJECT]];
   
    if (!success) {
        [self sendInformation:nil toClientWithStatus:kErrorObjectMisconfiguration andMessage:@"The object sent was not configured properly"];
        [NSException exceptionWithName:@"MCObjectMisconfiguration" reason:@"The object sent was not configured properly" userInfo:nil];
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
        if(![self loadObjectForID:[dict objectForKey:self->COMMONID]]){
            self->databaseObject = [self CreateANewObjectFromClass:self->COMMONDATABASE isTemporary:NO];
        }
        [self setValueToDictionaryValues:dict];
        // Try and save while handling duplication control
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            
        }];
    }
}
@end
