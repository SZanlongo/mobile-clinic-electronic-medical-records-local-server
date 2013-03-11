//
//  VisitationObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "VisitationObject.h"
#define ISOPEN      @"isOpen"
#define DATABASE    @"Visitation"
#define ALLVISITS   @"all visits"

#import "StatusObject.h"
#import "Visitation.h"
@implementation VisitationObject

+(NSString *)DatabaseName{
    return DATABASE;
}

-(NSDictionary *)consolidateForTransmitting{
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting]];
    [consolidate setValue:[NSNumber numberWithInt:kVisitationType] forKey:OBJECTTYPE];
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    [self linkVisit];
    [visit setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
}

-(void)saveObject:(ObjectResponse)eventResponse
{
    [super saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
         eventResponse(data,error);
    } inDatabase:DATABASE forAttribute:VISITID];
}

#pragma mark- Private Methods
#pragma mark-
-(BOOL)isVisitUniqueForVisitID
{
    NSArray* pastVisits = [self FindObjectInTable:DATABASE withName:visit.visitationId forAttribute:VISITID];
    
    if (pastVisits.count > 0) {
        return NO;
    }
    
    return YES;
}

-(BOOL)loadVisitWithVisitationID:(NSString *)visitID{   
   return [super loadObjectForID:visitID inDatabase:DATABASE forAttribute:VISITID];

}

-(void)linkVisit{
    visit = (Visitation*)self.databaseObject;
}

#pragma mark- Public Methods
#pragma mark-
-(void)associatePatientToVisit:(NSString *)patientFirstName{
    [self linkVisit];
    [visit setVisitationId:[NSString stringWithFormat:@"%@_%f",patientFirstName,[[NSDate date]timeIntervalSince1970]]];
}

-(BOOL)shouldSetCurrentVisitToOpen:(BOOL)shouldOpen{
    BOOL isAlreadyOpen = ([[self.databaseObject valueForKey:ISOPEN]boolValue]);
    if (isAlreadyOpen) {
        return NO;
    }
    [self.databaseObject setValue:[NSNumber numberWithBool:shouldOpen] forKey:ISOPEN];
    return YES;
}

-(void) SyncAllOpenVisitsOnServer:(ObjectResponse)Response{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:kFindOpenObjects],OBJECTCOMMAND,[NSNumber numberWithInteger:kVisitationType],OBJECTTYPE, nil];
    
    [self tryAndSendData:dict withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {
        Response(data,error);
    } andWithPositiveResponse:^(id data) {
        StatusObject* status = data;
        [self SaveListOfPatientsToTheDatabase:status.data];
        Response(self,nil);
    }];
}

-(NSArray*)FindAllOpenVisitsLocally{
   //Predicate to return list of Open Objects
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"isOpen == TRUE"];
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:TRIAGEIN]];
}

-(NSArray *)FindAllVisitsForCurrentPatientLocally:(NSDictionary*)patient
{
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",PATIENTID,[patient objectForKey:PATIENTID]];
    
    return [self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:PATIENTID];
}

-(void)FindAllVisitsOnServerForPatient:(NSDictionary*)patient OnCompletion:(ObjectResponse)eventResponse
{
    
    respondToEvent = eventResponse;
    
    NSMutableDictionary* query = [[NSMutableDictionary alloc]initWithCapacity:4];
    
    [query setValue:[patient objectForKey:PATIENTID] forKey:PATIENTID];
    [query setValue:[NSNumber numberWithInt:kVisitationType] forKey:OBJECTTYPE];
    [query setValue:[NSNumber numberWithInt:kFindObject] forKey:OBJECTCOMMAND];
    
    [ self tryAndSendData:query withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {
        respondToEvent(nil,error);
    } andWithPositiveResponse:^(id data) {
        StatusObject* status = data;
        [self SaveListOfPatientsToTheDatabase:status.data];
        respondToEvent(self,nil);        
    }];
}

-(void)SaveListOfPatientsToTheDatabase:(NSDictionary*)VisitList
{
    // get all the users returned from server
    NSArray* arr = [VisitList objectForKey:ALLVISITS];
    
    // Go through all users in array
    for (NSDictionary* dict in arr) {
        // If the user doesnt exists in the database currently then add it in
        if (![self loadVisitWithVisitationID:[dict objectForKey:VISITID]]) {
            self.databaseObject = [self CreateANewObjectFromClass:DATABASE isTemporary:NO];
        }
        [self linkVisit];
        [visit setValuesForKeysWithDictionary:dict];
        [self SaveCurrentObjectToDatabase];
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
