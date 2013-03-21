//
//  BaseObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#define MAX_NUMBER_ITEMS 4

#import "BaseObject.h"
#import "ServerCore.h"
#import "StatusObject.h"

id<ServerProtocol> serverManager;

@implementation BaseObject
@synthesize databaseObject;


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

-(void)SendData:(NSDictionary *)data toServerWithErrorMessage:(NSString *)msg andResponse:(ObjectResponse)Response{
    
    [ self tryAndSendData:data withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {
        Response(nil, [self createErrorWithDescription:msg andErrorCodeNumber:kErrorDisconnected inDomain:@"BaseObject"]);
    } andWithPositiveResponse:^(id data) {
        StatusObject* status = data;
        
        [self SaveListOfObjectsFromDictionary:status.data];
        
        Response((status.status == kSuccess)?self:nil, [self createErrorWithDescription:status.errorMessage andErrorCodeNumber:status.status inDomain:self.COMMONDATABASE]);
    }];
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

-(void)CommonExecution{
    NSLog(@"Not Implemented");
}

-(NSMutableArray*)convertListOfManagedObjectsToListOfDictionaries:(NSArray*)managedObjects{
    
    NSMutableArray* arrayWithDictionaries = [[NSMutableArray alloc]initWithCapacity:managedObjects.count];
    
    for (NSManagedObject* objs in managedObjects) {
        self.databaseObject = objs;
        [arrayWithDictionaries addObject:self.getDictionaryValuesFromManagedObject];
    }
    return arrayWithDictionaries;
}

-(NSManagedObject*)loadObjectWithID:(NSString *)objectID{
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:self.COMMONDATABASE withName:objectID forAttribute:self.COMMONID];
    if (arr.count > 0) {
        return [arr objectAtIndex:0];
    }
    return nil;
}

-(void)tryAndSendData:(NSDictionary*)data withErrorToFire:(ObjectResponse)negativeResponse andWithPositiveResponse:(ServerCallback)posResponse{
    
    if (!serverManager) 
        serverManager = [ServerCore sharedInstance];
    
    if ([serverManager isClientConntectToServer]) {
        [serverManager sendData:data withOnComplete:posResponse];
    }else{
        negativeResponse(nil,[self createErrorWithDescription:@"This device is not connected with the server" andErrorCodeNumber:kErrorDisconnected inDomain:@"BaseObject"]);
    }
}

-(void)startSearchWithData:(NSDictionary*)data withsearchType:(RemoteCommands)rCommand andOnComplete:(ObjectResponse)response{
    
    NSMutableDictionary* dataToSend = [[NSMutableDictionary alloc]initWithCapacity:3
                                       ];
    [dataToSend setValue:data forKey:DATABASEOBJECT];
    
    [dataToSend setValue:[NSNumber numberWithInt:self.CLASSTYPE] forKey:OBJECTTYPE];
    [dataToSend setValue:[NSNumber numberWithInt:rCommand] forKey:OBJECTCOMMAND];
    
    [self SendData:dataToSend toServerWithErrorMessage:DATABASE_ERROR_MESSAGE andResponse:response];
}

-(void)setValueToDictionaryValues:(NSDictionary*)values{
    
    for (NSString* key in values.allKeys) {
        if (![[values objectForKey:key]isKindOfClass:[NSNull class]]) {
            [self.databaseObject setValue:[values objectForKey:key] forKey:key];
        }
    }
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
    databaseObject = DatabaseObject;
}

-(void)setObject:(id)object withAttribute:(NSString *)attribute{
    [super setObject:object withAttribute:attribute inDatabaseObject:databaseObject];
}

-(id)getObjectForAttribute:(NSString *)attribute{
   return [super getObjectForAttribute:attribute inDatabaseObject:databaseObject];
}

-(void)UpdateObject:(ObjectResponse)response shouldLock:(BOOL)shouldLock andSendObjects:(NSMutableDictionary*)dataToSend withInstruction:(NSInteger)instruction{
    
    // Set/Clear the lock on the object
    NSMutableDictionary* container = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSString* lock = (shouldLock)?[BaseObject getCurrenUserName]:@"";
    
    [container setValue:[BaseObject getCurrenUserName] forKey:ISLOCKEDBY];
    
    [dataToSend setValue:lock forKey:ISLOCKEDBY];

    // Place the DataObject inside a dictionary
    [container setValue:dataToSend forKey:DATABASEOBJECT];
    
    // Add instructions
    [container setValue:[NSNumber numberWithInteger:instruction] forKey:OBJECTCOMMAND];
    
    // Add the object Type
    [container setValue:[NSNumber numberWithInteger:self.CLASSTYPE] forKey:OBJECTTYPE];
    
    
    // Try to send information to the server
    [self tryAndSendData:container withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {
        
        // Make sure that the object is attached to this object
        [self setValueToDictionaryValues:dataToSend];
        
        // Save current information if cannot connect
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *noError) {
             response(data,error);
        }];
        
    } andWithPositiveResponse:^(id PosData) {
        // Cast Status Object
        StatusObject* status = PosData;
        
        if (status.status == kSuccess) {
            // Save object to this device
            [self setValueToDictionaryValues:status.data];
            
            [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
                response(self,[self createErrorWithDescription:status.errorMessage andErrorCodeNumber:kSuccess inDomain:@"BaseObject"]);
            }];
        }else{
            response(nil,[self createErrorWithDescription:status.errorMessage andErrorCodeNumber:status.status inDomain:@"BaseObject"]);
        }
        
    }];
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
    
    if (arr.count == 1) {
        self.databaseObject = [arr objectAtIndex:0];
        return  YES;
    }
    return  NO;
}

-(void)SaveListOfObjectsFromDictionary:(NSDictionary*)patientList
{
    // get all the users returned from server
    NSArray* arr = [patientList objectForKey:ALLITEMS];
    
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
