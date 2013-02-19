//
//  PatientObject.m
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/11/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "PatientObject.h"


#define FIRSTNAME   @"firstName"
#define FAMILYNAME  @"familyName"
#define VILLAGE     @"villageName"
#define HEIGHT      @"height"
#define SEX         @"sex"
#define DOB         @"age"
#define PICTURE     @"photo"
#define VISITS      @"visits"
#define PATIENTID   @"patientId"
#define DATABASE    @"Patients"


#import "StatusObject.h"
#import "NSString+Validation.h"
#import "Patients.h"
@implementation PatientObject


#pragma mark - BaseObjectProtocol Methods
#pragma mark -

/* The super needs to be called first */
-(NSDictionary *)consolidateForTransmitting:(NSManagedObject *)object{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting:object]];

    [consolidate setValue:[self packagedVisits] forKey:VISITS];
    [consolidate setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    [_patient setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
    
   // [self unpackageVisits:[data objectForKey:VISITS]];
    
}

/* Depending on the RemoteCommands it will execute a different Command */
-(void)CommonExecution
{
    switch (self.commands) {
        case kCreateNewPatient:
            [self CreateANewPatient:nil];
            break;
        case kUpdatePatient:
            [self UpdateANewPatient: nil];
            break;
        default:
            break;
    }
}


/* Make sure you call Super after checking the existance of the database object
 * This can be done by doing the following:
 *       if (![self FindDataBaseObjectWithID]) {
 *               [self CreateANewObjectFromClass:<<CLASS NAME>>];
 *           }
 */
-(void)saveObject:(ObjectResponse)eventResponse
{
    if (_patient){
        
        [self SaveCurrentObjectToDatabase:_patient];
        
        if (eventResponse)
            eventResponse(self, nil);
    }else{
        //        if (eventResponse)
        //            eventResponse(self, nil);
    }
}

#pragma mark - Private Methods
#pragma mark -

-(NSString *)description
{
   
   
}


-(void)CreateANewPatient:(ObjectResponse)onSuccessHandler
{
    // Find and return object if it exists
    StatusObject* status = [[StatusObject alloc]init];
    
    // Need to set client so it can go the correct device
    [status setClient:self.client];

    // Create new Patient database object
    [self CreateANewObjectFromClass:DATABASE];
    
    // Save internal information to the patient object
    [self saveObject:nil];
    
    // Create message
    [status setErrorMessage:@"Patient has been created."];
    
    // send status back to requested client
    [status CommonExecution];
}


-(BOOL)isObject:(id)obj UniqueForKey:(NSString*)key
{
    // Check if it exists in database
    if ([self FindObjectInTable:DATABASE withName:obj forAttribute:key].count > 0) {
        return NO;
    }
    return YES;
}

-(void)UpdateANewPatient:(ObjectResponse)onSuccessHandler
{
    // Find and return object if it exists
    StatusObject* status = [[StatusObject alloc]init];
    
    // Need to set client so it can go the correct device
    [status setClient:self.client];

    if (_patient) {
        [self saveObject:nil];
        [status setStatus:kSuccess];
        [status setErrorMessage:@"Patient has been updated."];
    }else{
        [status setStatus:kError];
        [status setErrorMessage:@"Patient doesnt exist"];
    }
    
    
    [status CommonExecution];

    
}
-(void)addVisitToPatient:(Visitation *)visit{
    [_patient addVisitationObject:visit];
}
-(NSMutableArray*)packagedVisits{
    NSMutableArray* completeVisits = [[NSMutableArray alloc]initWithCapacity:_visits.count];
//    for (VisitationObject* visit in _visits) {
//        [completeVisits addObject:[visit consolidateForTransmitting]];
//    }
    return completeVisits;
}
// Used to unpack all the visits
-(NSArray*)unpackageVisits:(NSArray*)packagedVists
{
    if (!_visits) {
        _visits = [[NSMutableArray alloc]initWithCapacity:packagedVists.count];
    }
    
    for (NSDictionary* visitInformation in packagedVists) {
        VisitationObject* visit = [[VisitationObject alloc]initWithVisit:visitInformation];
        [_visits addObject:visit];
    }
    return _visits;
}

@end