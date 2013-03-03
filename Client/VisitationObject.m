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
    // Database object needs to exist
    if (self.databaseObject){
        [super SaveAndRefreshObjectToDatabase:self.databaseObject];
        eventResponse(self,nil);
    }else{
        
        eventResponse(Nil,[self createErrorWithDescription:@"Error: No Visit Selected" andErrorCodeNumber:0 inDomain:@"Visitation Object"]);
    }
}


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
-(void)createVisitationIDForPatient:(NSString *)patientFirstName{
    [visit setVisitationId:[NSString stringWithFormat:@"%@.%f",patientFirstName,[[NSDate date]timeIntervalSince1970]]];
}

-(void)createNewVisitOnClientAndServer:(ObjectResponse)onSuccessHandler
{
    respondToEvent = onSuccessHandler;
    NSMutableDictionary* dataToSend= [NSMutableDictionary dictionaryWithDictionary:[self consolidateForTransmitting]];
    [dataToSend setValue:[NSNumber numberWithInteger:kCreateNewObject] forKey:OBJECTCOMMAND];
    [self UpdateObject:onSuccessHandler andSendObjects:dataToSend forDatabase:DATABASE];
}

-(NSArray *)FindAllVisitsForCurrentPatientLocally:(NSDictionary*)patient
{
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",[patient objectForKey:PATIENTID]];
    
    return [self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:[patient objectForKey:PATIENTID]];
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
-(NSDictionary*)DictionaryReadyToCreateVisit{
    
    [self.databaseObject setValue:[NSNumber numberWithBool:YES] forKey:ISOPEN];
    
    NSMutableDictionary* query = [[NSMutableDictionary alloc]initWithDictionary:[self consolidateForTransmitting]];
    
    [query setValue:[NSNumber numberWithInt:kCreateNewObject] forKey:OBJECTCOMMAND];
    
    [query setValue:@"" forKey:ISLOCKEDBY];
    
    return query;
}

-(void)UpdateObject:(ObjectResponse)response andSendObjects:(NSDictionary*)DataToSend forDatabase:(NSString*)database{
    
    [self UpdateObject:response andSendObjects:DataToSend forDatabase:database];
}

-(void)shouldLockVisit:(BOOL)lockVisit forDatabase:(NSString *)database onCompletion:(ObjectResponse)Response{
   
    [super shouldLockVisit:lockVisit forDatabase:DATABASE onCompletion:Response];
}
@end
