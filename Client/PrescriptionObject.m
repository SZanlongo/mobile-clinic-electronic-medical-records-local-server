//
//  PrescriptionObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/25/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#define VISITID         @"visitId"
#define DATABASE    @"Prescription"
#define ALLITEMS    @"ALL_ITEMS"
#import "PrescriptionObject.h"
#import "StatusObject.h"

@implementation PrescriptionObject


+(NSString *)DatabaseName{
    return DATABASE;
}

-(NSDictionary *)consolidateForTransmitting{
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting]];
    [consolidate setValue:[NSNumber numberWithInt:kPrescriptionType] forKey:OBJECTTYPE];
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    [self.databaseObject setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
}

-(void)saveObject:(ObjectResponse)eventResponse
{
    [super saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
        eventResponse(data,error);
    } inDatabase:DATABASE forAttribute:VISITID];
}

-(BOOL)loadPrescriptionWithPrescriptionID:(NSString *)prescriptionID{
    // checks to see if object exists
  return [self loadObjectForID:prescriptionID inDatabase:DATABASE forAttribute:PRESCRIPTIONID];
}

#pragma mark- Public Methods
#pragma mark-
-(void)associatePrescriptionToVisit:(NSString *)visitID{
 
    [self.databaseObject setValue:visitID forKey:VISITID];
}

-(NSArray *)FindAllPrescriptionForCurrentVisitLocally:(NSDictionary*)visit
{
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",VISITID,[visit objectForKey:VISITID]];
    
    return [self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:VISITID];
}

-(void)FindAllPrescriptionsOnServerForVisit:(NSDictionary *)visit OnCompletion:(ObjectResponse)eventResponse
{
    
    respondToEvent = eventResponse;
    
    NSMutableDictionary* query = [[NSMutableDictionary alloc]initWithCapacity:4];
    
    [query setValue:[visit objectForKey:VISITID] forKey:VISITID];
    [query setValue:[NSNumber numberWithInt:kPrescriptionType] forKey:OBJECTTYPE];
    [query setValue:[NSNumber numberWithInt:kFindObject] forKey:OBJECTCOMMAND];
    
    [ self tryAndSendData:query withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {
        respondToEvent(nil,error);
    } andWithPositiveResponse:^(id data) {
        StatusObject* status = data;
        [self SaveListOfPrescriptionsToTheDatabase:status.data];
        respondToEvent(self,nil);
    }];
}

-(void)SaveListOfPrescriptionsToTheDatabase:(NSDictionary*)prescriptionList
{
    // get all the users returned from server
    NSArray* arr = [prescriptionList objectForKey:ALLITEMS];
    
    // Go through all users in array
    for (NSDictionary* dict in arr) {

        if (![self loadPrescriptionWithPrescriptionID:[dict objectForKey:PRESCRIPTIONID]]) {
            self.databaseObject = [self CreateANewObjectFromClass:DATABASE isTemporary:NO];
        }
        [prescriptionList setValuesForKeysWithDictionary:dict];
       
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            
        }];
    }
}

-(void)UpdateObjectAndShouldLock:(BOOL)shouldLock onComplete:(ObjectResponse)response{
    
    if (shouldLock) {
        [self.databaseObject setValue:self.appDelegate.currentUserName forKey:ISLOCKEDBY];
    }else{
        [self.databaseObject setValue:@"" forKey:ISLOCKEDBY];
    }
    
    NSMutableDictionary* dataToSend = [NSMutableDictionary dictionaryWithDictionary:[self consolidateForTransmitting]];
    
    [dataToSend setValue:[NSNumber numberWithInteger:kUpdateObject] forKey:OBJECTCOMMAND];
    [dataToSend setValue:self.appDelegate.currentUserName forKey:ISLOCKEDBY];
    
    [super UpdateObject:response andSendObjects:dataToSend forDatabase:DATABASE withAttribute:VISITID];
}

@end
