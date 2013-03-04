//
//  MobileClinicFacade.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/1/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "MobileClinicFacade.h"
#import "PatientObject.h"
#import "VisitationObject.h"
FIUAppDelegate* appDelegate;
@implementation MobileClinicFacade
- (id)init
{
    self = [super init];
    if (self) {
        appDelegate = (FIUAppDelegate*)[[UIApplication sharedApplication]delegate];
    }
    return self;
}
-(NSString *)GetCurrentUsername{
    return appDelegate.currentUserName;
}
-(void)createAndCheckInPatient:(NSDictionary *)patientInfo onCompletion:(MobileClinicCommandResponse)Response{
   
    PatientObject* patient = [[PatientObject alloc]initWithNewDatabaseObject:[PatientObject DatabaseName]];
    [patient setValueToDictionaryValues:patientInfo];
    // Object is Create locally Only
    [patient createNewPatient:^(id<BaseObjectProtocol> data, NSError *error) {
        Response([data getDictionaryValuesFromManagedObject], error);
    }];
}
//  Use to find patients. Has no need to lock
-(void)findPatientWithFirstName:(NSString *)firstname orLastName:(NSString *)lastname onCompletion:(MobileClinicSearchResponse)Response{
    
    /* Create a temporary Patient Object to make request */
    PatientObject* patients = [[PatientObject alloc]init];
    
    /* Query server and save results locally */
    [patients FindAllPatientsOnServerWithFirstName:firstname andWithLastName:lastname onCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
        
        /* Query local results and return results to caller */
        NSArray* allPatientResult = [NSArray arrayWithArray:[patients FindAllPatientsLocallyWithFirstName:firstname andWithLastName:lastname]];
        
        Response(allPatientResult,error);
        
    }];
}
// Use to find visits for a given patient. Has no need to lock
-(void)findAllVisitsForCurrentPatient:(NSDictionary *)patientInfo AndOnCompletion:(MobileClinicSearchResponse)Response{
    
    /* Create a temporary Patient Object to make request */
    VisitationObject* vObject = [[VisitationObject alloc]init];
    
    [vObject FindAllVisitsOnServerForPatient:patientInfo OnCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
        NSArray* allVisits = [NSArray arrayWithArray:[vObject FindAllVisitsForCurrentPatientLocally:patientInfo]];
        Response(allVisits,error);
    }];
}
// Creates a new visit for a given patient. Has no need to lock
-(void)addNewVisit:(NSDictionary *)visitInfo ForCurrentPatient:(NSDictionary *)patientInfo onCompletion:(MobileClinicCommandResponse)Response{
    VisitationObject* visit = [[VisitationObject alloc]initWithNewDatabaseObject:[VisitationObject DatabaseName]];
    [visit setValueToDictionaryValues:visitInfo];
    [visit setObject:[patientInfo objectForKey:PATIENTID] withAttribute:PATIENTID];
    [visit createVisitationIDForPatient:[patientInfo objectForKey:FIRSTNAME]];
    [visit createNewVisitOnClientAndServer:^(id<BaseObjectProtocol> data, NSError *error) {
        Response([data getDictionaryValuesFromManagedObject],error);
        
    }];
}

-(void)LockPatient:(NSDictionary *)patientInfo onCompletion:(MobileClinicCommandResponse)Response{
   
    PatientObject* patient = [[PatientObject alloc]initWithCachedObject:[patientInfo objectForKey:PATIENTID] inDatabase:[PatientObject DatabaseName] forAttribute:PATIENTID];
   
    [patient shouldLockVisit:YES forDatabase:nil onCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
        Response([data getDictionaryValuesFromManagedObject],error);
    }];
}
// Locks a visit 
-(void)LockVist:(NSDictionary *)VisitInfo  onCompletion:(MobileClinicCommandResponse)Response{
    VisitationObject* visit = [[VisitationObject alloc]init];
    [visit loadVisitWithVisitationID:[VisitInfo objectForKey:VISITID]];
   
    [visit shouldLockVisit:YES forDatabase:nil onCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
        Response([data getDictionaryValuesFromManagedObject],error);
    }];
}
// Updates a visitation record and locks it depend the Bool variable
-(void)updateVisitRecord:(NSDictionary *)visitRecord andShouldUnlock:(BOOL)unlock onCompletion:(MobileClinicCommandResponse)Response{
    VisitationObject* vObject = [[VisitationObject alloc]init];
    [vObject loadVisitWithVisitationID:[visitRecord objectForKey:VISITID]];
    [vObject setValueToDictionaryValues:visitRecord];
    
    [vObject shouldLockVisit:!unlock forDatabase:nil onCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
        Response([data getDictionaryValuesFromManagedObject],error);
    }];
}

-(void)findAllOpenVisitsAndOnCompletion:(MobileClinicSearchResponse)Response{
    
    /* Create a temporary Patient Object to make request */
    VisitationObject* vObject = [[VisitationObject alloc]init];
    
    [vObject FindAllOpenVisitsOnServer:^(id<BaseObjectProtocol> data, NSError *error) {
        NSArray* allVisits = [NSArray arrayWithArray:[vObject FindAllOpenVisitsLocally]];
        Response(allVisits,error);
    }];
}
@end
