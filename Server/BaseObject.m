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
            BOOL success = [self setValueToDictionaryValues:dic];
            
            return (success)?self:nil;
        }
    }
    return self;
}

#pragma mark - Convenience Methods
#pragma mark-


-(void)ServerCommand:(NSDictionary *)dataToBeRecieved withOnComplete:(ServerCommand)response{
    commandPattern = response;
}

-(BOOL)setValueToDictionaryValues:(NSDictionary*)values{
    @try{
        for (NSString* key in values.allKeys) {
            if (![[values objectForKey:key]isKindOfClass:[NSNull class]]) {
                [databaseObject setValue:[values objectForKey:key] forKey:key];
            }
        }
        return YES;
    }@catch (NSException *exception) {
        NSLog(@"Error: Cannot synthesize the file because it does not contain the right values for type  %@",COMMONDATABASE);
        databaseObject = nil;
        return NO;
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
    eventResponse(self, nil);
}

-(NSDictionary *)consolidateForTransmitting{
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithCapacity:1];
    [consolidate setValue:[databaseObject dictionaryWithValuesForKeys:databaseObject.entity.attributeKeys] forKey:DATABASEOBJECT];
    return consolidate;
}


@end
