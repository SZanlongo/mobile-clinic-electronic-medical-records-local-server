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
#import "PrescriptionObject.h"
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
    [patient createNewPatientLocally:^(id<BaseObjectProtocol> data, NSError *error) {
        Response([data getDictionaryValuesFromManagedObject], error);
    }];
}

//  Use to find patients. Has no need to lock
-(void)findPatientWithFirstName:(NSString *)firstname orLastName:(NSString *)lastname onCompletion:(MobileClinicSearchResponse)Response{
    
    /* Create a temporary Patient Object to make request */
    PatientObject* patients = [[PatientObject alloc]initWithDatabase:[PatientObject DatabaseName]];
    
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
    [visit associatePatientToVisit:[patientInfo objectForKey:FIRSTNAME]];
    
    if ([visit shouldSetCurrentVisitToOpen:YES]) {
        [visit UpdateObjectAndShouldLock:NO onComplete:^(id<BaseObjectProtocol> data, NSError *error) {
            Response([data getDictionaryValuesFromManagedObject],error);
        }];
    }else{
        NSString* msg = [NSString stringWithFormat:@"%@ %@ already has an open visit",[patientInfo objectForKey:FIRSTNAME],[patientInfo objectForKey:FAMILYNAME]];
        Response(nil,[self createErrorWithDescription:msg andErrorCodeNumber:20 inDomain:@"MobileClinicFacade"]);
    }
    

}


// Updates a visitation record and locks it depend the Bool variable
-(void)updateVisitRecord:(NSDictionary *)visitRecord andShouldUnlock:(BOOL)unlock andShouldCloseVisit:(BOOL)closeVisit onCompletion:(MobileClinicCommandResponse)Response{
   
    VisitationObject* vObject = [[VisitationObject alloc]initWithCachedObject:[visitRecord objectForKey:VISITID] inDatabase:[VisitationObject DatabaseName] forAttribute:VISITID withUpdatedObject:visitRecord];
   
    [vObject shouldSetCurrentVisitToOpen:closeVisit];
   
    [vObject UpdateObjectAndShouldLock:!unlock onComplete:^(id<BaseObjectProtocol> data, NSError *error) {
        Response([data getDictionaryValuesFromManagedObject],error);
    }];
}

//TODO: Needs to be optimized
-(void)findAllOpenVisitsAndOnCompletion:(MobileClinicSearchResponse)Response{    
    /* Create a temporary Patient Object to make request */
    VisitationObject* vObject = [[VisitationObject alloc]init];
    
    [vObject SyncAllOpenVisitsOnServer:^(id<BaseObjectProtocol> data, NSError *error) {
        
        NSArray* allVisits = [NSArray arrayWithArray:[vObject FindAllOpenVisitsLocally]];
        
        NSString* patientDatabase = [PatientObject DatabaseName];
        NSString* patientID;
       
        for (NSMutableDictionary* dic in allVisits) {
            
            patientID = [dic objectForKey:PATIENTID];
            
            PatientObject* patients = [[PatientObject alloc]initWithCachedObject:patientID inDatabase:patientDatabase forAttribute:PATIENTID withUpdatedObject:nil];
            [dic setValue:patients.getDictionaryValuesFromManagedObject forKey:OPEN_VISITS_PATIENT];
        }
        Response(allVisits,error);
    }];
}

-(void)updateCurrentPatient:(NSDictionary *)patientInfo AndShouldLock:(BOOL)lock onCompletion:(MobileClinicCommandResponse)Response{
    
    PatientObject* patient = [[PatientObject alloc]initWithCachedObject:[patientInfo objectForKey:PATIENTID] inDatabase:[PatientObject DatabaseName] forAttribute:PATIENTID withUpdatedObject:patientInfo];

    [patient UpdateAndLockPatientObject:lock onComplete:^(id<BaseObjectProtocol> data, NSError *error) {
        Response([data getDictionaryValuesFromManagedObject],error);
    }];
    
}

-(void)findAllPrescriptionForCurrentVisit:(NSDictionary *)visit AndOnCompletion:(MobileClinicSearchResponse)Response{
    /* Create a temporary Patient Object to make request */
    PrescriptionObject* prObject = [[PrescriptionObject alloc]init];
    
    [prObject FindAllPrescriptionsOnServerForVisit:visit OnCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
        NSArray* allVisits = [NSArray arrayWithArray:[prObject FindAllPrescriptionForCurrentVisitLocally:visit]];
        Response(allVisits,error);

    }];
}

-(void) updatePrescription:(NSDictionary*)Rx AndShouldLock:(BOOL)lock onCompletion:(MobileClinicCommandResponse)Response{
    
    PrescriptionObject* prescript = [[PrescriptionObject alloc]initWithCachedObject:[Rx objectForKey:PRESCRIPTIONID] inDatabase:[PrescriptionObject DatabaseName] forAttribute:PRESCRIPTIONID withUpdatedObject:Rx];
   
    [prescript UpdateObjectAndShouldLock:lock onComplete:^(id<BaseObjectProtocol> data, NSError *error) {
         Response([data getDictionaryValuesFromManagedObject],error);
    }];
}
@end
