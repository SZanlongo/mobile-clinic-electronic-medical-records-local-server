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

@implementation BaseObject
@synthesize databaseObject;

- (id)initWithDatabase:(NSString*)database
{
    self = [super init];
    if (self) {
        self.databaseObject = [super CreateANewObjectFromClass:database isTemporary:YES];
    }
    return self;
}
-(id)initWithNewDatabaseObject:(NSString*)database{
    self = [super init];
    if (self) {
        self.databaseObject = [super CreateANewObjectFromClass:database isTemporary:NO];
    }
    return self;
}
- (id)initAndFillWithNewObject:(NSDictionary *)info andRelatedDatabase:(NSString*)database
{
    self = [self initWithDatabase:database];
    if (self) {
        [self unpackageFileForUser:info];
        
    }
    return self;
}
- (id)initWithCachedObject:(NSString*)objectID inDatabase:(NSString*)database forAttribute:(NSString*)attrib withUpdatedObject:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        [self loadObjectForID:objectID inDatabase:database forAttribute:attrib];
        
        if (dic) {
             [self setValueToDictionaryValues:dic];
        }
    }
    return self;
}

-(NSDictionary *)consolidateForTransmitting{
    /* 
     * Setup some of variables that are common to all the
     * the object that inherit from this base class
     */
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithCapacity:MAX_NUMBER_ITEMS];

    [consolidate setValue:[self.databaseObject dictionaryWithValuesForKeys:self.databaseObject.entity.attributesByName.allKeys] forKey:DATABASEOBJECT];
    [consolidate setValue:self.appDelegate.currentUserName forKey:ISLOCKEDBY];
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    /* Setup some of variables that are common to all the
     * the object that inherit from this base class
     */
    self.commands = [[data objectForKey:OBJECTCOMMAND]intValue];
}


-(void)saveObject:(ObjectResponse)eventResponse inDatabase:(NSString*)DBName forAttribute:(NSString*)attrib{
    
    id objID = [self.databaseObject valueForKey:attrib];
    
    NSManagedObject* obj = [self loadObjectWithID:objID inDatabase:DBName forAttribute:attrib];
    
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
            
            obj = [self CreateANewObjectFromClass:DBName isTemporary:NO];
            
            [obj setValuesForKeysWithDictionary:self.getDictionaryValuesFromManagedObject];
            
            [self SaveAndRefreshObjectToDatabase:obj];
        }
    }
    eventResponse(self, nil);
}

-(void)CommonExecution{
    
}

-(NSMutableArray*)convertListOfManagedObjectsToListOfDictionaries:(NSArray*)managedObjects{
    
    NSMutableArray* arrayWithDictionaries = [[NSMutableArray alloc]initWithCapacity:managedObjects.count];
    
    for (NSManagedObject* objs in managedObjects) {
        self.databaseObject = objs;
        [arrayWithDictionaries addObject:self.getDictionaryValuesFromManagedObject];
    }
    return arrayWithDictionaries;
}

-(NSManagedObject*)loadObjectWithID:(NSString *)objectID inDatabase:(NSString*)database forAttribute:(NSString*)attribute{
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:database withName:objectID forAttribute:attribute];
    if (arr.count > 0) {
        return [arr objectAtIndex:0];
    }
    return nil;
}

-(void)tryAndSendData:(NSDictionary*)data withErrorToFire:(ObjectResponse)negativeResponse andWithPositiveResponse:(ServerCallback)posResponse{
    
    if ([self.appDelegate.ServerManager isClientConntectToServer]) {
        // Sending information to the server
        [self.appDelegate.ServerManager sendData:data withOnComplete:posResponse];
    }else{
        negativeResponse(nil,[self createErrorWithDescription:@"Server is Down, Please contact you Application Administrator" andErrorCodeNumber:10 inDomain:@"BaseObject"]);
    }
}

-(void)setValueToDictionaryValues:(NSDictionary*)values{
    
    for (NSString* key in values.allKeys) {
        if (![[values objectForKey:key]isKindOfClass:[NSNull class]]) {
            [self.databaseObject setValue:[values objectForKey:key] forKey:key];
        }
    }
}

-(NSMutableDictionary*)getDictionaryValuesFromManagedObject{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    for (NSString* key in self.databaseObject.entity.attributesByName.allKeys) {
        [dict setValue:[self.databaseObject valueForKey:key] forKey:key];
    }
    return dict;
}

-(void)setDBObject:(NSManagedObject *)DatabaseObject{
    databaseObject = DatabaseObject;
}

-(void)setObject:(id)object withAttribute:(NSString *)attribute{
    [super setObject:object withAttribute:attribute inDatabaseObject:databaseObject];
}

-(id)getObjectForAttribute:(NSString *)attribute{
   return [super getObjectForAttribute:attribute inDatabaseObject:databaseObject];
}

-(void)UpdateObject:(ObjectResponse)response andSendObjects:(NSDictionary*)DataToSend forDatabase:(NSString*)database withAttribute:(NSString*)attrib{
    
    [self tryAndSendData:DataToSend withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
             response(data,error);
        } inDatabase:database forAttribute:attrib];
        
    } andWithPositiveResponse:^(id PosData) {
        // Save Returned Values
        StatusObject* status = PosData;

        [self setValueToDictionaryValues:status.data];
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            response(self,[self createErrorWithDescription:status.errorMessage andErrorCodeNumber:[[DataToSend objectForKey:OBJECTCOMMAND]integerValue] inDomain:@"BaseObject"]);
        } inDatabase:database forAttribute:attrib];
    }];
}


-(BOOL)loadObjectForID:(NSString *)objectID inDatabase:(NSString*)database forAttribute:(NSString*)attribute{
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:database withName:objectID forAttribute:attribute];
    
    if (arr.count == 1) {
        self.databaseObject = [arr objectAtIndex:0];
        return  YES;
    }
    return  NO;
}
@end
