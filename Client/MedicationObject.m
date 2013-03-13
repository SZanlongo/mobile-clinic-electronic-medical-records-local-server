//
//  MedicationObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#define DATABASE    @"Medication"
#define ALLITEMS    @"ALL_ITEMS"
#import "MedicationObject.h"
#import "StatusObject.h"
@implementation MedicationObject

+(NSString *)DatabaseName{
    return DATABASE;
}

-(void)associateObjectToItsSuperParent:(NSString *)parentID{
    
}
// push to base
-(NSArray *)FindAllObjectsLocallyFromParentObject:(NSDictionary*)parentObject{
   
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",self.COMMONID,[parentObject objectForKey:self.COMMONID]];
    
    return [self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:self.COMMONID];
}
// Refactor and Pushed to base
-(void)FindAllObjectsOnServerFromParentObject:(NSDictionary*)parentObject OnCompletion:(ObjectResponse)eventResponse{
   
    respondToEvent = eventResponse;
    
    NSMutableDictionary* query = [[NSMutableDictionary alloc]initWithCapacity:4];
    
    [query setValue:[parentObject objectForKey:self.COMMONID] forKey:self.COMMONID];
    [query setValue:[NSNumber numberWithInt:self.CLASSTYPE] forKey:OBJECTTYPE];
    [query setValue:[NSNumber numberWithInt:kFindObject] forKey:OBJECTCOMMAND];
    
    [ self tryAndSendData:query withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {
        respondToEvent(nil,error);
    } andWithPositiveResponse:^(id data) {
        StatusObject* status = data;
        [self SaveListOfObjectsToTheDatabase:status.data];
        respondToEvent(self,nil);
    }];
}

// Pushed to base
-(void)SaveListOfObjectsToTheDatabase:(NSDictionary*)objectList
{
    // get all the users returned from server
    NSArray* arr = [objectList objectForKey:ALLITEMS];
    
    // Go through all users in array
    for (NSDictionary* dict in arr) {
        
        if (![self loadObjectForID:[dict objectForKey:self.COMMONID] inDatabase:DATABASE forAttribute:self.COMMONID]) {
            self.databaseObject = [self CreateANewObjectFromClass:DATABASE isTemporary:NO];
        }
        [objectList setValuesForKeysWithDictionary:dict];
        
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            
        } inDatabase:DATABASE forAttribute:self.COMMONID];
    }
}
// Pushed to base & refactor
-(void)UpdateObjectAndShouldLock:(BOOL)shouldLock onComplete:(ObjectResponse)response{
   
    NSString* username = [BaseObject getCurrenUserName];

    [self.databaseObject setValue:(shouldLock)?username:@"" forKey:ISLOCKEDBY];
    
    NSMutableDictionary* dataToSend = [NSMutableDictionary dictionaryWithDictionary:[self consolidateForTransmitting]];
    
    [dataToSend setValue:[NSNumber numberWithInteger:kUpdateObject] forKey:OBJECTCOMMAND];
    
    [super UpdateObject:response andSendObjects:dataToSend forDatabase:DATABASE withAttribute:self.COMMONID];
}

@end
