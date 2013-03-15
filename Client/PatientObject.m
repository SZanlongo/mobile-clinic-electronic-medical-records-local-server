////  PatientObject.m//  Mobile Clinic////  Created by Steven Berlanga on 2/4/13.//  Copyright (c) 2013 Steven Berlanga. All rights reserved.//#define PATIENTID   @"patientId"#define ALLPATIENTS @"all patients"#define DATABASE    @"Patients"#import "PatientObject.h"#import "StatusObject.h"#import "VisitationObject.h"#import "Patients.h"#import "UIImage+ImageVerification.h"StatusObject* tempStatusObject;Patients* patient;VisitationObject* currentVisit;@implementation PatientObject+(NSString*)DatabaseName{    return DATABASE;}#pragma mark- Base Protocol Methods Overide#pragma mark-- (id)init{    [self setupObject];    return [super init];}-(id)initAndMakeNewDatabaseObject{     [self setupObject];    return [super initAndMakeNewDatabaseObject];}- (id)initAndFillWithNewObject:(NSDictionary *)info{     [self setupObject];    return [super initAndFillWithNewObject:info];}-(id)initWithCachedObjectWithUpdatedObject:(NSDictionary *)dic{    [self setupObject];    return [super initWithCachedObjectWithUpdatedObject:dic];}-(void)setupObject{        self.COMMONID =  PATIENTID;    self.CLASSTYPE = kPatientType;    self.COMMONDATABASE = DATABASE;}#pragma mark- Public Methods#pragma mark--(void)createNewObject:(NSDictionary*) object Locally:(ObjectResponse)onSuccessHandler{        if (object) {        [self setValueToDictionaryValues:object];    }            // validate patient info and creates a patient ID    [self linkPatient];        // Check for patientID    if (!patient.patientId.isNotEmpty) {        // Adds an ID if it is not present        patient.patientId = [NSString stringWithFormat:@"%@_%@_%f",patient.firstName,patient.familyName,[[NSDate date]timeIntervalSince1970]];    }        [self.databaseObject setValue:@"" forKey:ISLOCKEDBY];        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {        onSuccessHandler(data,error);    }];}-(NSArray *)FindAllObjectsLocallyFromParentObject:(NSDictionary*)parentObject{       NSString* firstname = [parentObject objectForKey: FIRSTNAME];    NSString* lastname = [parentObject objectForKey: FAMILYNAME];        NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K contains[cd] %@ || %K contains[cd] %@",FIRSTNAME,firstname,FAMILYNAME,lastname];        return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:FIRSTNAME]];}-(void)FindAllObjectsOnServerFromParentObject:(NSDictionary*)parentObject OnCompletion:(ObjectResponse)eventResponse{        NSString* firstname = [parentObject objectForKey: FIRSTNAME];    NSString* lastname = [parentObject objectForKey: FAMILYNAME];        respondToEvent = eventResponse;        NSMutableDictionary* query = [[NSMutableDictionary alloc]initWithCapacity:4];        [query setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];    [query setValue:[NSNumber numberWithInt:kFindObject] forKey:OBJECTCOMMAND];        [query setValue:firstname forKey:FIRSTNAME];    [query setValue:lastname forKey:FAMILYNAME];        [ self tryAndSendData:query withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {        [self QuerySuccessful:nil];    } andWithPositiveResponse:^(id data) {        [self QuerySuccessful:data];    }];}-(void)syncAllPatientsAndVisits{    }#pragma mark- Internal Private Methods#pragma mark--(void)QuerySuccessful:(StatusObject *)notification{    if (!notification) {        respondToEvent(nil, [self createErrorWithDescription:@"Search result may be incomplete due to lost connection with the server" andErrorCodeNumber:10 inDomain:@"PatientObject"]);    }else if (tempStatusObject.status == kSuccess) {        // Activate the callback so user knows it was successful        [self SaveListOfObjectsFromDictionary:notification.data ];        respondToEvent(self, nil);    }else{        respondToEvent(nil,[self createErrorWithDescription:tempStatusObject.errorMessage andErrorCodeNumber:10 inDomain:@"PatientObject"] );    }}-(void)linkPatient{    patient = (Patients*)self.databaseObject;}//TODO: Need a method to push all patients to the server@end