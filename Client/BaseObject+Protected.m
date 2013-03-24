//
//  BaseObject+Protected.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/21/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "BaseObject+Protected.h"
#import "ServerCore.h"

id<ServerProtocol> serverManager;

@implementation BaseObject (Protected)

-(void)SendData:(NSDictionary *)data toServerWithErrorMessage:(NSString *)msg andResponse:(ObjectResponse)Response{
    
    [ self tryAndSendData:data withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {
        Response(nil, [self createErrorWithDescription:msg andErrorCodeNumber:kErrorDisconnected inDomain:@"BaseObject"]);
    } andWithPositiveResponse:^(id data) {
        StatusObject* status = data;
        
        [self SaveListOfObjectsFromDictionary:status.data];
        
        Response((status.status == kSuccess)?self:nil, [self createErrorWithDescription:status.errorMessage andErrorCodeNumber:status.status inDomain:self.COMMONDATABASE]);
    }];
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

-(NSMutableArray*)convertListOfManagedObjectsToListOfDictionaries:(NSArray*)managedObjects{
    
    NSMutableArray* arrayWithDictionaries = [[NSMutableArray alloc]initWithCapacity:managedObjects.count];
    
    for (NSManagedObject* objs in managedObjects) {
        self.databaseObject = objs;
        [arrayWithDictionaries addObject:self.getDictionaryValuesFromManagedObject];
    }
    return arrayWithDictionaries;
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
        // If
        if (status.status >= kError) {
            response(nil,[self createErrorWithDescription:status.errorMessage andErrorCodeNumber:status.status inDomain:@"BaseObject"]);
        } else if (status.status == kSuccess) {
            // Save object to this device
            [self setValueToDictionaryValues:status.data];
            
            [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
                response(self,[self createErrorWithDescription:status.errorMessage andErrorCodeNumber:kSuccess inDomain:@"BaseObject"]);
            }];
        }
    }];
}
@end
