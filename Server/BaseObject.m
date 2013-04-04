//
//  BaseObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "BaseObject.h"
#define MAX_NUMBER_ITEMS 4
#import "BaseObject+Protected.h"


@implementation BaseObject

#pragma mark - Initialization Methods
#pragma mark-
-(id)init
{
    self = [super init];
    if (self) {
        cloudAPI = [[CloudService alloc]init];
        databaseObject = [super CreateANewObjectFromClass:COMMONDATABASE isTemporary:YES];
    }
    return self;
}
-(id)initAndMakeNewDatabaseObject
{
    self = [super init];
    if (self) {
        cloudAPI = [[CloudService alloc]init];
        databaseObject = [super CreateANewObjectFromClass:COMMONDATABASE isTemporary:NO];
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
        NSString* objectID = [dic objectForKey:COMMONID];
        [self loadObjectForID:objectID];
        if (dic) {
            NSError* success = [self setValueToDictionaryValues:dic];
            
            return (!success)?self:nil;
        }
    }
    return self;
}

#pragma mark - Convenience Methods
#pragma mark-


-(void)ServerCommand:(NSDictionary *)dataToBeRecieved withOnComplete:(ServerCommand)response{
    commandPattern = response;
}

-(NSError*)setValueToDictionaryValues:(NSDictionary*)values{
    NSMutableArray* badValues = [[NSMutableArray alloc]initWithCapacity:values.count];
    

        for (NSString* key in values.allKeys) {
            @try{
            if (![[values objectForKey:key]isKindOfClass:[NSNull class]]) {
                
                id obj = [values objectForKey:key];
                
                if (!obj) {
                    continue;
                }
                
                [databaseObject setValue:([obj isKindOfClass:[NSDate class]])?[obj convertNSDateToSeconds]:obj forKey:key];
            }
            }@catch (NSException *exception) {
                NSString* badObject = [NSString stringWithFormat:@"Key: %@ Value: %@",key, [[values objectForKey:key] description]];
                
                [badValues addObject:badObject];
                
                NSLog(@"Error: Bad Key-Value pair: %@ in %@",badObject,COMMONDATABASE);

            }
        }
   
    if (badValues.count > 0) {
        NSString* msg = [NSString stringWithFormat:@"The database could not handle the following Key-Value Pair: %@",badValues.description];
        
        return [self createErrorWithDescription:msg andErrorCodeNumber:kErrorObjectMisconfiguration inDomain:COMMONDATABASE];
    }
    
    return nil;
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
    for (NSString* key in databaseObject.entity.attributesByName.allKeys) {
        [dict setValue:[databaseObject valueForKey:key] forKey:key];
    }
    return dict;
}



#pragma mark- DATA RETRIEVAL & TELEPORTION Methods
#pragma mark-




#pragma mark- SAVE Methods
#pragma mark-

// MARK: Saves the current databaseObject without duplicating it
-(void)saveObject:(ObjectResponse)eventResponse{
    
    // get the UID of the object
    id objID = [databaseObject valueForKey:COMMONID];
    
    if(!objID)
        eventResponse(nil,[self createErrorWithDescription:@"Object does not have a primary key ID" andErrorCodeNumber:kErrorObjectMisconfiguration inDomain:COMMONDATABASE]);
    
    // Find if object already exists
    NSManagedObject* obj = [self loadObjectWithID:objID];
    
    // update the object we found in the database
    [obj setValuesForKeysWithDictionary:self.getDictionaryValuesFromManagedObject];
    
    // if there is was something to save
    if (obj){
        // save it
        [self SaveCurrentObjectToDatabase:obj];
        
    }else{
        
        obj = [self CreateANewObjectFromClass:COMMONDATABASE isTemporary:NO];
        
        [obj setValuesForKeysWithDictionary:self.getDictionaryValuesFromManagedObject];
        
        [self SaveCurrentObjectToDatabase:obj];
        
    }
    
    if (eventResponse) {
        eventResponse(self, nil);
    }
}

-(NSDictionary *)consolidateForTransmitting{
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithCapacity:1];
    [consolidate setValue:[databaseObject dictionaryWithValuesForKeys:databaseObject.entity.attributeKeys] forKey:DATABASEOBJECT];
    return consolidate;
}

-(BOOL)deleteCurrentlyHeldObjectFromDatabase{
   return [self deleteNSManagedObject:databaseObject];
}

-(BOOL)deleteDatabaseDictionaryObject:(NSDictionary *)object{
    return [self deleteObjectsFromDatabase:COMMONDATABASE withDefiningAttribute:[object objectForKey:COMMONID] forKey:COMMONID];
}
@end
