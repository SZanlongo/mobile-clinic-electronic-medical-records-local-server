//
//  PatientObject.m
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/11/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define ISOPEN  @"isOpen"
#import "DataProcessor.h"
#import "PatientObject.h"
#import "StatusObject.h"
#import "NSString+Validation.h"
#import "Patients.h"

NSString* firstname;
NSString* lastname;
NSString* isLockedBy;

@implementation PatientObject
+(NSString *)DatabaseName{
    return DATABASE;
}
- (id)init
{
    [self setupObject];
    return [super init];
}
-(id)initAndMakeNewDatabaseObject
{
    [self setupObject];
    return [super initAndMakeNewDatabaseObject];
}
- (id)initAndFillWithNewObject:(NSDictionary *)info
{
    [self setupObject];
    return [super initAndFillWithNewObject:info];
}
-(id)initWithCachedObjectWithUpdatedObject:(NSDictionary *)dic
{
    [self setupObject];
    return [super initWithCachedObjectWithUpdatedObject:dic];
}

-(void)setupObject{
    
    self.COMMONID =  PATIENTID;
    self.CLASSTYPE = kPatientType;
    self.COMMONDATABASE = DATABASE;
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
    [super ServerCommand:nil withOnComplete:response];
    [self unpackageFileForUser:dataToBeRecieved];
    [self CommonExecution];
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];

    firstname = [self.databaseObject valueForKey:FIRSTNAME];
    lastname = [self.databaseObject valueForKey:FAMILYNAME];
    
}

/* Depending on the RemoteCommands it will execute a different Command */
-(void)CommonExecution
{
    switch (self.commands) {
        case kUpdateObject:
            [super UpdateObjectAndSendToClient];
            break;
        case kFindObject:
            [self sendSearchResults:[self FindAllObjectsLocallyFromParentObject]];            break;
        case kFindOpenObjects:
            [self sendSearchResults:[self FindAllOpenPatients]];
        default:
            break;
    }
}
#pragma mark - COMMON OBJECT Methods
#pragma mark -
-(NSArray *)FindAllObjectsLocallyFromParentObject{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K beginswith[cd] %@ || %K beginswith[cd] %@",FIRSTNAME,firstname,FAMILYNAME,lastname];
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:FIRSTNAME]];
}
-(NSArray*)FindAllOpenPatients{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == YES",ISOPEN];
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:FIRSTNAME]];
}
-(NSArray*)serviceAllObjectsForParentID:(NSString*)parentID{
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:FIRSTNAME]];
}

-(NSString *)printFormattedObject:(NSDictionary *)object{
    return [NSString stringWithFormat:@" Patient Name:\t%@ %@ \n Village:\t%@ \n Date of Birth:\t%@ \n Age:\t%li \n Sex:\t%li \n",[object objectForKey:FIRSTNAME],[object objectForKey:FAMILYNAME],[object objectForKey:VILLAGE],[[object objectForKey:DOB]convertNSDateFullBirthdayString],[[object objectForKey:DOB]getNumberOfYearsElapseFromDate],[[object objectForKey:SEX]integerValue]];
}
#pragma mark - Private Methods
#pragma mark -

-(void)UnlockPatient:(ObjectResponse)WhatIDOAfterThePatientIsUnlocked{
    // Unlock patient
    [patient setIsLockedBy:@""];
    // save changes
    [self saveObject:WhatIDOAfterThePatientIsUnlocked];
}


-(void)PullAllPatientsFromCloud:(ObjectResponse)onComplete{
   // NSArray* allPatients = [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:FIRSTNAME]];
[cloudAPI query:@"patients" parameters:nil completion:^(NSError *error, NSDictionary *result) {
    if (!error) {
        NSArray* allPatients = [result objectForKey:@"data"];
        for (int i = 0; i < allPatients.count; i++) {
            NSMutableDictionary* serverPatient = [NSMutableDictionary dictionaryWithDictionary:[allPatients objectAtIndex:i]];
            [serverPatient removeObjectForKey:@"createdAt"];
            [serverPatient removeObjectForKey:@"dob"];
            [serverPatient setValue:[serverPatient objectForKey:@"village"] forKey:VILLAGE];
            [serverPatient removeObjectForKey:@"village"];
            [serverPatient setValue:[NSNumber numberWithInteger:[[serverPatient objectForKey:SEX]integerValue]] forKey:SEX];
            [self setValueToDictionaryValues:serverPatient];
            [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
                
            }];
        }
    }
}];
//    for (NSDictionary* syncPatient in allPatients) {
//        
//        [cloudAPI query:@"patient_for_id" parameters:[NSDictionary dictionaryWithObject:[syncPatient objectForKey:PATIENTID] forKey:@"userId"] completion:^(NSError *error, NSDictionary *result) {
//            
//            if (!error) {
//                NSMutableDictionary* old = [NSMutableDictionary dictionaryWithDictionary:[result objectForKey:@"data"]];
//                [old setDictionary:syncPatient];
//                
//                [self setValueToDictionaryValues:old];
//                
//                [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
//                    if (data) {
//                        NSDate* date = [syncPatient objectForKey:DOB];
//                        
//                        //TODO: Deal with date values
//                        [old setValue:[NSNumber numberWithLong:[date timeIntervalSince1970]] forKey:DOB];
//                        
//                        if ([[result objectForKey:@"data"]count] == 0)
//                            [cloudAPI query:CREATEPATIENT parameters:old  completion:^(NSError *error, NSDictionary *result) {
//                                NSLog(@"Create Patient: %@",result);
//                            }];
//                        else
//                            [cloudAPI query:EDITPATIENT parameters:old  completion:^(NSError *error, NSDictionary *result) {
//                                NSLog(@"Edited Patient: %@",result);
//                            }];
//                    }
//                }];
//            }
//    
//        }];
//    }
    if (onComplete) {
        onComplete(self,nil);
    }
}
-(void)PushAllPatientsToCloud:(ObjectResponse)onComplete{
    
}
-(void)SyncPatientsWithCloud{
//    NSMutableDictionary * mDic = [[NSMutableDictionary alloc]init];
//    
//    //TODO: Remove Hard Dependencies
//    [mDic setObject:@"1" forKey:@"created_at"];
//    
//    [self query:@"patients" parameters:mDic completion:^(NSError *error, NSDictionary *result) {
//        NSLog(@"Patients: \n\n %@",result);
//        [self storeMultipleCloudUsers:result];
//        [self PushPatientsToCloud];
//    }];
}

-(void)storeMultipleCloudUsers:(NSDictionary*)cloudUsers
{
//    //TODO: Remove Hard Dependencies
//    NSArray* users = [cloudUsers objectForKey:@"data"];
//    
//    for (NSDictionary* userInfo in users) {
//        //We only want to create patients that do not exists in Database
//        if (![self loadPatientWithID:[userInfo objectForKey:PATIENTID]]) {
//            
//            self.databaseObject = [self CreateANewObjectFromClass:DATABASE isTemporary:YES];
//            [self linkDatabaseObjects];
//            
//            patient.firstName = [userInfo objectForKey:FIRSTNAME];
//            patient.familyName = [userInfo objectForKey:FAMILYNAME];
//            patient.villageName = [userInfo objectForKey:VILLAGE];
//            patient.age = [self convertFromSeconds:[userInfo objectForKey:DOB]];
//            patient.sex = [userInfo objectForKey:SEX];
//            [self SaveCurrentObjectToDatabase:patient];
//            patient = nil;
//        }
//    }
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
