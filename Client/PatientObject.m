////  PatientObject.m//  Mobile Clinic////  Created by Steven Berlanga on 2/4/13.//  Copyright (c) 2013 Steven Berlanga. All rights reserved.//#define PATIENTID   @"patientId"#define ALLPATIENTS @"all patients"#define DATABASE    @"Patients"#import "PatientObject.h"#import "StatusObject.h"#import "VisitationObject.h"#import "Patients.h"#import "UIImage+ImageVerification.h"StatusObject* tempStatusObject;Patients* patient;VisitationObject* currentVisit;@implementation PatientObject+(NSString*)DatabaseName{    return DATABASE;}#pragma mark- Protocol Methods#pragma mark--(NSDictionary *)consolidateForTransmitting{        NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting]];    [consolidate setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];    return consolidate;}-(void)unpackageFileForUser:(NSDictionary *)data{    [super unpackageFileForUser:data];    [self linkPatient];    [patient setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];    }-(void)saveObject:(ObjectResponse)eventResponse{    [super saveObject:eventResponse inDatabase:DATABASE forAttribute:PATIENTID];}#pragma mark- Public Methods#pragma mark--(void)UpdateAndLockPatientObject:(BOOL)shouldLock onComplete:(ObjectResponse)response{        [self linkPatient];        if (shouldLock) {        [patient setIsLockedBy:self.appDelegate.currentUserName];    }else{        [patient setIsLockedBy:@""];    }      NSMutableDictionary* dataToSend = [NSMutableDictionary dictionaryWithDictionary:[self consolidateForTransmitting]];    [dataToSend setValue:[NSNumber numberWithInteger:kUpdateObject] forKey:OBJECTCOMMAND];    [dataToSend setValue:[NSNumber numberWithInteger:kPatientType] forKey:OBJECTTYPE];    [dataToSend setValue:self.appDelegate.currentUserName forKey:ISLOCKEDBY];        [super UpdateObject:response andSendObjects:dataToSend forDatabase:DATABASE withAttribute:PATIENTID];}-(void)createNewPatientLocally:(ObjectResponse)onSuccessHandler{        [self.databaseObject setValue:@"" forKey:ISLOCKEDBY];        [self.databaseObject setValue:[NSNumber numberWithBool:YES] forKey:STATUS];        // validate patient info and creates a patient ID    [self linkPatient];        patient.firstName =  [patient.firstName  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];        patient.familyName =  [patient.familyName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];        // Check for patientID    if (!patient.patientId.isNotEmpty) {        // Adds an ID if it is not present        patient.patientId = [NSString stringWithFormat:@"%@_%@_%f",patient.firstName,patient.familyName,[[NSDate date]timeIntervalSince1970]];    }            [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {        onSuccessHandler(data,error);    }];}-(NSArray *)FindAllPatientsLocallyWithFirstName:(NSString *)firstname andWithLastName:(NSString *)lastname{    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K contains[cd] %@ || %K contains[cd] %@",FIRSTNAME,firstname,FAMILYNAME,lastname];        return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:FIRSTNAME]];}-(void)FindAllPatientsOnServerWithFirstName:(NSString *)firstname andWithLastName:(NSString *)lastname onCompletion:(ObjectResponse)eventResponse{    respondToEvent = eventResponse;        NSMutableDictionary* query = [[NSMutableDictionary alloc]initWithCapacity:4];        [query setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];    [query setValue:[NSNumber numberWithInt:kFindObject] forKey:OBJECTCOMMAND];        [query setValue:firstname forKey:FIRSTNAME];    [query setValue:lastname forKey:FAMILYNAME];    [ self tryAndSendData:query withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {        [self QueryForPatientActionSuccessfull:nil];    } andWithPositiveResponse:^(id data) {        [self QueryForPatientActionSuccessfull:data];    }];}-(NSManagedObject *)getDBObject{    [self linkPatient];    return patient;}-(void)syncAllPatientsAndVisits{    }#pragma mark- Internal Private Methods#pragma mark--(void)QueryForPatientActionSuccessfull:(StatusObject *)notification{    if (!notification) {        respondToEvent(nil, [self createErrorWithDescription:@"Search result may be incomplete due to lost connection with the server" andErrorCodeNumber:10 inDomain:@"PatientObject"]);    }else if (tempStatusObject.status == kSuccess) {        // Activate the callback so user knows it was successful         tempStatusObject = notification;        [self SaveListOfPatientsToTheDatabase:tempStatusObject.data];        respondToEvent(self, nil);    }else{        respondToEvent(nil,[self createErrorWithDescription:tempStatusObject.errorMessage andErrorCodeNumber:10 inDomain:@"PatientObject"] );    }        // Remove event listener    //[[NSNotificationCenter defaultCenter]removeObserver:self];}-(void)SaveListOfPatientsToTheDatabase:(NSDictionary*)patientList{    [self linkPatient];    // get all the users returned from server    NSArray* arr = [patientList objectForKey:ALLPATIENTS];    // Go through all users in array    for (NSDictionary* dict in arr) {                // Try and find previously existing value        if(![self loadObjectForID:[dict objectForKey:PATIENTID] inDatabase:DATABASE forAttribute:PATIENTID]){            self.databaseObject = [self CreateANewObjectFromClass:DATABASE isTemporary:NO];        }        [self setValueToDictionaryValues:dict];        // Try and save while handling duplication control        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {                    } inDatabase:DATABASE forAttribute:PATIENTID];    }}-(void)linkPatient{    patient = (Patients*)self.databaseObject;}//TODO: Need a method to push all patients to the server@end