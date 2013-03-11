//
//  PatientObject.m
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/11/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "PatientObject.h"
#import "StatusObject.h"
#import "NSString+Validation.h"
#import "Patients.h"

NSString* firstname;
NSString* lastname;
NSString* isLockedBy;

@implementation PatientObject

- (id)init
{
    self = [super init];
    if (self) {
        self.databaseObject = [self CreateANewObjectFromClass:DATABASE isTemporary:YES];
         [self linkDatabaseObjects];
        status = [[StatusObject alloc]init];
    }
    return self;
}

#pragma mark - BaseObjectProtocol Methods
#pragma mark -

/* The super needs to be called first */
-(NSDictionary *)consolidateForTransmitting{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting]];

    [consolidate setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];
    return consolidate;
}

-(void)ServerCommand:(NSDictionary *)dataToBeRecieved withOnComplete:(ServerCommand)response{
    commandPattern = response;
    [self unpackageFileForUser:dataToBeRecieved];
    [self CommonExecution];
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];

    self.databaseObject = [self CreateANewObjectFromClass:DATABASE isTemporary:YES];
    
    [self linkDatabaseObjects];
    
    [patient setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];

    firstname = [data objectForKey:FIRSTNAME];
    lastname = [data objectForKey:FAMILYNAME];
    isLockedBy = [data objectForKey:ISLOCKEDBY];
}

/* Depending on the RemoteCommands it will execute a different Command */
-(void)CommonExecution
{
    switch (self.commands) {
        case kUpdateObject:
            [self UpdatePatientInformationWithError:@"Server could not update patient"  orPositiveErro:@"Server successfully updated your information"];
            break;
            
        case kFindObject:
            [self FindPatientByName];
            break;    
        default:
            break;
    }
}


/*
 * This will create a new patient if one does not exists, otherwise it will update the existing one
 */
-(void)saveObject:(ObjectResponse)eventResponse
{
    [self linkDatabaseObjects];
    
       [super saveObject:eventResponse inDatabase:DATABASE forAttribute:PATIENTID];
}

#pragma mark - Private Methods
#pragma mark -

-(void)FindPatientByName{
    
    NSArray* arr = [self FindAllPatientsLocallyWithFirstName:firstname andWithLastName:lastname];
    
    NSMutableArray* arrayToSend = [[NSMutableArray alloc]initWithCapacity:arr.count];
    
    for (Patients* obj in arr) {
        [arrayToSend addObject:[obj dictionaryWithValuesForKeys:obj.attributeKeys]];
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    [dict setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];
    
    [dict setValue:arrayToSend forKey:ALL_PATIENTS];
    
    [self sendInformation:dict toClientWithStatus:kSuccess andMessage:@"Server search completed"];
}

-UpdatePatientInformationWithError:(NSString*)negError orPositiveErro:(NSString*)posError{
    // Load old patient in global object and save new patient in variable
    Patients* oldPatient = [self loadAndReturnPatientForID:patient.patientId];
   
    BOOL isNotLockedUp = (!oldPatient || ![oldPatient.isLockedBy isEqualToString:isLockedBy]);

    if (isNotLockedUp) {
        // save to local database
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            if (!error) {
                [self sendInformation:[self getDictionaryValuesFromManagedObject] toClientWithStatus:kSuccess andMessage:posError];
            }else{
                [self sendInformation:nil toClientWithStatus:kError andMessage:negError];
            }
        }];
    }else{
        [self loadPatientWithID:patient.patientId];
        
        [self sendInformation:[self getDictionaryValuesFromManagedObject] toClientWithStatus:kError andMessage:[NSString stringWithFormat:@"Patient is being used by %@",[self.databaseObject valueForKey:ISLOCKEDBY]]];
    }
}

-(void)UnlockPatient:(ObjectResponse)WhatIDOAfterThePatientIsUnlocked{
    // Unlock patient
    [patient setIsLockedBy:@""];
    // save changes
    [self saveObject:WhatIDOAfterThePatientIsUnlocked];
}

-(void)sendInformation:(id)data toClientWithStatus:(int)kStatus andMessage:(NSString*)message{

    // set data
    [status setData:data];
    
    // Set message
    [status setErrorMessage:message];
        
    // set status
    [status setStatus:kStatus];
        
    commandPattern([status consolidateForTransmitting]);
}

-(NSArray *)FindAllPatientsLocallyWithFirstName:(NSString *)firstname andWithLastName:(NSString *)lastname
{
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K contains[cd] %@ || %K contains[cd] %@",FIRSTNAME,firstname,FAMILYNAME,lastname];
    
    return [self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:FIRSTNAME];
}

-(void)PushPatientsToCloud{
    NSArray* allPatients = [self FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:FIRSTNAME];

    for (Patients* syncPatient in allPatients) {
        
        self.databaseObject = syncPatient;
        
        [self query:@"patients" parameters:nil completion:^(NSError *error, NSDictionary *result) {
            
            NSMutableDictionary* temp = [NSMutableDictionary dictionaryWithDictionary:[[self consolidateForTransmitting]objectForKey:DATABASEOBJECT]];
            
            //TODO: Deal with date values
            [temp setValue:[self convertDateToSeconds:syncPatient.age] forKey:DOB];
            //TODO: Deal with visists
            [temp removeObjectForKey:@"visits"];
            //TODO: Remover CreatedAt
            [temp setValue:@"131231" forKey:@"createdAt"];
       
            if ([[result objectForKey:@"data"]count] == 0) {
                [self query:CREATEPATIENT parameters:temp  completion:nil];
        } else {
            [self query:EDITPATIENT parameters:temp  completion:nil];
         }
            
        }];
    }
}

-(void)SyncPatientsWithCloud{
    NSMutableDictionary * mDic = [[NSMutableDictionary alloc]init];
    
    //TODO: Remove Hard Dependencies
    [mDic setObject:@"1" forKey:@"created_at"];
    
    [self query:@"patients" parameters:mDic completion:^(NSError *error, NSDictionary *result) {
        NSLog(@"Patients: \n\n %@",result);
        [self storeMultipleCloudUsers:result];
        [self PushPatientsToCloud];
    }];
}

-(void)storeMultipleCloudUsers:(NSDictionary*)cloudUsers
{
    //TODO: Remove Hard Dependencies
    NSArray* users = [cloudUsers objectForKey:@"data"];
    
    for (NSDictionary* userInfo in users) {
        //We only want to create patients that do not exists in Database
        if (![self loadPatientWithID:[userInfo objectForKey:PATIENTID]]) {
            
            self.databaseObject = [self CreateANewObjectFromClass:DATABASE isTemporary:YES];
            [self linkDatabaseObjects];
            
            patient.firstName = [userInfo objectForKey:FIRSTNAME];
            patient.familyName = [userInfo objectForKey:FAMILYNAME];
            patient.villageName = [userInfo objectForKey:VILLAGE];
            patient.age = [self convertFromSeconds:[userInfo objectForKey:DOB]];
            patient.sex = [userInfo objectForKey:SEX];
            [self SaveCurrentObjectToDatabase:patient];
            patient = nil;
        }
    }
}

-(BOOL)loadPatientWithID:(NSString *)patientID
{
    return [super loadObjectForID:patientID inDatabase:DATABASE forAttribute:patientID];
}

-(Patients*)loadAndReturnPatientForID:(NSString*)patientId{
    return (Patients*)[super loadObjectWithID:patientId inDatabase:DATABASE forAttribute:PATIENTID];
}

-(void)linkDatabaseObjects{
    patient = (Patients*) self.databaseObject;
}

-(NSDate*)convertFromSeconds:(NSNumber*)seconds{
   return [NSDate dateWithTimeIntervalSince1970:seconds.doubleValue];
}

-(NSNumber*)convertDateToSeconds:(NSDate*)date{
    return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
}
@end
