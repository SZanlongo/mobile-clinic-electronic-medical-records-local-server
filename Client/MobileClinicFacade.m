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
#import "MedicationObject.h"

@implementation MobileClinicFacade

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSString *)GetCurrentUsername{
    return [BaseObject getCurrenUserName];
}

#pragma mark- CREATING NEW OBJECTS
#pragma mark-
// Creates only a local copy of the patient
-(void)createAndCheckInPatient:(NSDictionary *)patientInfo onCompletion:(MobileClinicCommandResponse)Response{
   
    PatientObject* patient = [[PatientObject alloc]initAndMakeNewDatabaseObject];

    // Object is Create locally Only
    [patient createNewObject:patientInfo Locally:^(id<BaseObjectProtocol> data, NSError *error) {
         Response([data getDictionaryValuesFromManagedObject], error);
    }];
}

// creates a new prescription for a given visit
-(void)addNewPrescription:(NSDictionary *)Rx ForCurrentVisit:(NSDictionary *)visit AndlockVisit:(BOOL)lock onCompletion:(MobileClinicCommandResponse)Response{
    
    PrescriptionObject* prescript = [[PrescriptionObject alloc]initAndMakeNewDatabaseObject];
    
    [self CommonCommandObject:prescript ForCreating:Rx bindedToParentObject:visit withResults:Response];
}

// Creates a new visit for a given patient.
-(void)addNewVisit:(NSDictionary *)visitInfo ForCurrentPatient:(NSDictionary *)patientInfo shouldCheckOut:(BOOL)checkout onCompletion:(MobileClinicCommandResponse)Response{
    
    VisitationObject* visit = [[VisitationObject alloc]initAndMakeNewDatabaseObject];
    NSMutableDictionary* openVisit = [[NSMutableDictionary alloc]initWithDictionary:visitInfo];
    
    [openVisit setValue:[NSNumber numberWithBool:!checkout] forKey:ISOPEN];

    [self CommonCommandObject:visit ForCreating:openVisit bindedToParentObject:patientInfo withResults:Response];
}



#pragma mark- SEARCHING FOR OBJECTS
#pragma mark-
//  Use to find patients. 
-(void)findPatientWithFirstName:(NSString *)firstname orLastName:(NSString *)lastname onCompletion:(MobileClinicSearchResponse)Response{
    
    /* Create a temporary Patient Object to make request */
    PatientObject* patients = [[PatientObject alloc]init];
   
    NSDictionary* search = [NSDictionary dictionaryWithObjectsAndKeys:firstname,FIRSTNAME,lastname,FAMILYNAME, nil];
    
    [self CommonCommandObject:patients ForSearch:search withResults:Response];
}

// Use to find visits for a given patient. 
-(void)findAllVisitsForCurrentPatient:(NSDictionary *)patientInfo AndOnCompletion:(MobileClinicSearchResponse)Response{
    
    /* Create a temporary Visitation Object to make request */
    VisitationObject* vObject = [[VisitationObject alloc]init];
    
    [self CommonCommandObject:vObject ForSearch:patientInfo withResults:Response];
}

//TODO: Needs to be optimized
// Use to find open visits that needs servicing
-(void)findAllOpenVisitsAndOnCompletion:(MobileClinicSearchResponse)Response{
    
    /* Create a temporary Patient Object to make request */
    VisitationObject* vObject = [[VisitationObject alloc]init];
    
    // Fetch and Save query results from server
    [vObject SyncAllOpenVisitsOnServer:^(id<BaseObjectProtocol> data, NSError *error) {
        
        // Array of Visit Dictionaries
        NSArray* allVisits = [NSArray arrayWithArray:[vObject FindAllOpenVisitsLocally]];
        
        NSString* patientID;
        
        // For every Dictionary in the array...
        for (NSMutableDictionary* dic in allVisits) {
            // Get the patient ID
            patientID = [dic objectForKey:PATIENTID];
            // Find the patient for that ID
            PatientObject* patients = [[PatientObject alloc]initWithCachedObjectWithUpdatedObject:[NSDictionary dictionaryWithObjectsAndKeys:patientID,PATIENTID, nil]];
            // Save the Dictionary value of that patient inside the current dictionary
            [dic setValue:patients.getDictionaryValuesFromManagedObject forKey:OPEN_VISITS_PATIENT];
        }
        // Send array Results to caller
        Response(allVisits,error);
    }];
}

// Use to find all Prescriptions
-(void)findAllPrescriptionForCurrentVisit:(NSDictionary *)visit AndOnCompletion:(MobileClinicSearchResponse)Response{
    
    /* Create a temporary Patient Object to make request */
    PrescriptionObject* prObject = [[PrescriptionObject alloc]init];
    
    [self CommonCommandObject:prObject ForSearch:visit withResults:Response];
    
}

// Finds all the medication
-(void)findAllMedication:(NSDictionary *)visit AndOnCompletion:(MobileClinicSearchResponse)Response{
    MedicationObject* base = [[MedicationObject alloc]init];
    [self CommonCommandObject:base ForSearch:nil withResults:Response];
}


#pragma mark- UPDATING OBJECTS
#pragma mark-
// Updates a visitation record and locks it depend the Bool variable
-(void)updateVisitRecord:(NSDictionary *)visitRecord andShouldUnlock:(BOOL)unlock andShouldCloseVisit:(BOOL)closeVisit onCompletion:(MobileClinicCommandResponse)Response{
   
    NSMutableDictionary* temp = [NSMutableDictionary dictionaryWithDictionary:visitRecord];
   
    // Just in case people become silly
    [temp removeObjectForKey:OPEN_VISITS_PATIENT];
    
    VisitationObject* base = [[VisitationObject alloc]initWithCachedObjectWithUpdatedObject:temp];
    [self CommonCommandObject:base ShouldLock:!unlock CommonUpdate:[NSMutableDictionary dictionaryWithDictionary:temp] withResults:Response];
}

// Updates the patient and locks based on Bool variable
-(void)updateCurrentPatient:(NSDictionary *)patientInfo AndShouldLock:(BOOL)lock onCompletion:(MobileClinicCommandResponse)Response{
    
    PatientObject* base = [[PatientObject alloc]initWithCachedObjectWithUpdatedObject:patientInfo];
    [self CommonCommandObject:base ShouldLock:lock CommonUpdate:[NSMutableDictionary dictionaryWithDictionary:patientInfo] withResults:Response];
}

// Updates the prescription and locks based on Bool variable
-(void) updatePrescription:(NSDictionary*)Rx AndShouldLock:(BOOL)lock onCompletion:(MobileClinicCommandResponse)Response{
     PrescriptionObject* base = [[PrescriptionObject alloc]initWithCachedObjectWithUpdatedObject:Rx];
    [self CommonCommandObject:base ShouldLock:lock CommonUpdate:[NSMutableDictionary dictionaryWithDictionary:Rx] withResults:Response];
}

// Updates the medication and locks it if necessary
-(void)updateMedication:(NSDictionary *)Rx AndShouldLock:(BOOL)lock onCompletion:(MobileClinicCommandResponse)Response{
    MedicationObject* base = [[MedicationObject alloc]initWithCachedObjectWithUpdatedObject:Rx];
    [self CommonCommandObject:base ShouldLock:lock CommonUpdate:[NSMutableDictionary dictionaryWithDictionary:Rx] withResults:Response];
}

#pragma mark- PRIVATE GENERIC METHODS
#pragma mark-
-(void)CommonCommandObject:(id<BaseObjectProtocol,CommonObjectProtocol>)base ShouldLock:(BOOL)lock CommonUpdate:(NSMutableDictionary*)object withResults:(MobileClinicCommandResponse)results{
  
    /* Call the server to make a request for Visits */
    [base UpdateObject:^(id<BaseObjectProtocol> data, NSError *error) {
        results([data getDictionaryValuesFromManagedObject],error);
    } shouldLock:lock andSendObjects:object withInstruction:kUpdateObject];
}

-(void)CommonCommandObject:(id<CommonObjectProtocol>)commandObject ForSearch:(NSDictionary*)object withResults:(MobileClinicSearchResponse)searchResults{
    
    /* Call the server to make a request for Visits */
    [commandObject FindAllObjectsOnServerFromParentObject:object OnCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
        /* get all visits that are stored on the device */
        NSArray* allVisits = [NSArray arrayWithArray:[commandObject FindAllObjectsLocallyFromParentObject:object]];
        searchResults(allVisits,error);
    }];
}

-(void)CommonCommandObject:(id<CommonObjectProtocol>)commandObject ForCreating:(NSDictionary*)object bindedToParentObject:(NSDictionary*)parent withResults:(MobileClinicCommandResponse)results{
    
    if (parent) {
        [commandObject associateObjectToItsSuperParent:parent];
    }
    
    [commandObject createNewObject:object Locally:^(id<BaseObjectProtocol> data, NSError *error) {
    if (data) {
        [self CommonCommandObject:commandObject ShouldLock:NO CommonUpdate:[data getDictionaryValuesFromManagedObject] withResults:results];
    }else{
        results([data getDictionaryValuesFromManagedObject],error);
    }
    }];
}

@end
