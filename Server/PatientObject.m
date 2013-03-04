//
//  PatientObject.m
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/11/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "PatientObject.h"


#define FIRSTNAME       @"firstName"
#define FAMILYNAME      @"familyName"
#define VILLAGE         @"villageName"
#define HEIGHT          @"height"
#define SEX             @"sex"
#define DOB             @"age"
#define PICTURE         @"photo"
#define VISITS          @"visits"
#define PATIENTID       @"patientId"
#define ALL_PATIENTS    @"all patients"
#define ISLOCKEDBY      @"isLockedBy"
#define DATABASE        @"Patients"


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
        case kCreateNewObject:
            [self createNewPatient];
            break;
            
        case kUpdateObject:
            [self ClientSidePatientLockToggleWithError:@"Server could not update patient"  orPositiveErro:@"Server successfully updated your information"];
            break;
            
        case kFindObject:
            [self FindPatientByName];
            break;
            
        case kToggleObjectLock:
            [self ClientSidePatientLockToggleWithError:@"Server failed to release/lock the patient" orPositiveErro:@"Server locked the patient"];
            
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
    if (patient){
        
        [self SaveCurrentObjectToDatabase:patient];
        
        eventResponse(self, nil);
    }else{
        eventResponse(nil, [self createErrorWithDescription:@"No Patient has been selected" andErrorCodeNumber:0 inDomain:@"Patient Object"]);
    }
}

#pragma mark - Private Methods
#pragma mark -

-(BOOL)isObject:(id)obj UniqueForKey:(NSString*)key
{
    // Check if it exists in database
    if ([self FindObjectInTable:DATABASE withName:obj forAttribute:key].count > 0) {
        return NO;
    }
    return YES;
}

-(void)createNewPatient{
    
    [patient setIsLockedBy:isLockedBy];

    [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
        if (!error) {
            [self sendInformation:nil toClientWithStatus:kSuccess andMessage:@"Server successfully saved your information"];
        }else{
            [self sendInformation:nil toClientWithStatus:kError andMessage:@"Server could not save your information"];
        }
    }];
    
}

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

-(void)ClientSidePatientLockToggleWithError:(NSString*)negError orPositiveErro:(NSString*)posError{
    // Load old patient in global object and save new patient in variable
    Patients* oldPatient = [self loadAndReturnPatientForID:patient.patientId];
    
    if ([oldPatient.isLockedBy isEqualToString:isLockedBy] || oldPatient.isLockedBy.length == 0) {
        // Update the old patient
        [oldPatient setValuesForKeysWithDictionary:[patient dictionaryWithValuesForKeys:patient.attributeKeys]];
        // save to local database
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            if (!error) {
                [self sendInformation:nil toClientWithStatus:kSuccess andMessage:posError];
            }else{
                [self sendInformation:nil toClientWithStatus:kError andMessage:negError];
            }
        }];
    }else{
        // Patient was already locked
        [self sendInformation:nil toClientWithStatus:kError andMessage:[NSString stringWithFormat:@"Patient is being used by %@",isLockedBy]];
    }
}

-(void)UnlockPatient:(ObjectResponse)WhatIDOAfterThePatientIsUnlocked{
    // Unlock patient
    [patient setIsLockedBy:@""];
    // save changes
    [self saveObject:WhatIDOAfterThePatientIsUnlocked];
}

-(void)sendInformation:(id)data toClientWithStatus:(ServerStatus)kStatus andMessage:(NSString*)message{

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

-(Patients*)LoadOldPatientAndReturnNewPatient{
    // New patient
    Patients* newPatient = [[Patients alloc]init];
    // transfer patient information to the new patient
    [newPatient setValuesForKeysWithDictionary:[patient dictionaryWithValuesForKeys:patient.attributeKeys]];
    // load the old patient with existing patient info
    [self loadPatientWithID:patient.patientId];
    
    return newPatient;
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
            
            self.databaseObject = (Patients*)[self CreateANewObjectFromClass:DATABASE isTemporary:NO];
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
    
    if ([patientID isKindOfClass:[NSString class]]) {
        NSArray* arr = [self FindObjectInTable:DATABASE withName:patientID forAttribute:PATIENTID];
        
        if (arr.count == 1) {
            patient = [arr objectAtIndex:0];
            return  YES;
        }
    }// checks to see if object exists
    return NO;
}

-(Patients*)loadAndReturnPatientForID:(NSString*)patientId{
   
    if ([patientId isKindOfClass:[NSString class]]) {
        
        NSArray* arr = [self FindObjectInTable:DATABASE withName:patientId forAttribute:PATIENTID];
        
        if (arr.count > 0) {
            return [arr lastObject];
        }
    }
        return nil;
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
