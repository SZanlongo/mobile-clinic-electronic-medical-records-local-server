//
//  PatientObject.m
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/11/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define ISOPEN  @"isOpen"

#import "PatientObject.h"

#import "BaseObject+Protected.h"
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
    
    self->COMMONID =  PATIENTID;
    self->CLASSTYPE = kPatientType;
    self->COMMONDATABASE = DATABASE;
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

    firstname = [self->databaseObject valueForKey:FIRSTNAME];
    lastname = [self->databaseObject valueForKey:FAMILYNAME];
    
}

/* Depending on the RemoteCommands it will execute a different Command */
-(void)CommonExecution
{
    switch (self->commands) {
        case kUpdateObject:
            [super UpdateObjectAndSendToClient];
            break;
        case kFindObject:
            [self sendSearchResults:[self FindAllObjectsForGivenCriteria]];            break;
        case kFindOpenObjects:
            [self sendSearchResults:[self FindAllOpenPatients]];
        default:
            break;
    }
}
#pragma mark - COMMON OBJECT Methods
#pragma mark -

-(NSArray*)FindAllOpenPatients{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == YES",ISOPEN];
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:FIRSTNAME]];
}

-(NSArray *)FindAllObjects{
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:FIRSTNAME]]; 
}

-(NSArray*)FindAllObjectsUnderParentID:(NSString*)parentID{
    return [self FindAllObjects];
}

-(NSString *)printFormattedObject:(NSDictionary *)object{

    return [NSString stringWithFormat:@" Patient Name:\t%@ %@ \n Village:\t%@ \n Date of Birth:\t%@ \n Age:\t%li \n Sex:\t%@ \n",[object objectForKey:FIRSTNAME],[object objectForKey:FAMILYNAME],[object objectForKey:VILLAGE],[[NSDate convertSecondsToNSDate:[object objectForKey:DOB]]convertNSDateFullBirthdayString],[[NSDate convertSecondsToNSDate:[object objectForKey:DOB]]getNumberOfYearsElapseFromDate],([[object objectForKey:SEX]integerValue]==0)?@"Female":@"Male"];
}
#pragma mark - Private Methods
#pragma mark -

-(NSArray *)FindAllObjectsForGivenCriteria{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K beginswith[cd] %@ || %K beginswith[cd] %@",FIRSTNAME,firstname,FAMILYNAME,lastname];
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:FIRSTNAME]];
}

-(void)UnlockPatient:(ObjectResponse)onComplete{
    // Unlock patient
    [self->databaseObject setValue:@"" forKey:ISLOCKEDBY];
    // save changes
    [self saveObject:onComplete];
}

-(void)pullFromCloud:(CloudCallback)onComplete{
    
    [self makeCloudCallWithCommand:DATABASE withObject:nil onComplete:^(id cloudResults, NSError *error) {
        if (!error) {
            NSArray* allPatients = [cloudResults objectForKey:@"data"];
            NSMutableDictionary* serverPatient;
            for (NSMutableDictionary* temp in allPatients) {
                
                serverPatient = [NSMutableDictionary dictionaryWithDictionary:temp];
             
                //   [serverPatient setValue:[NSNumber numberWithInteger:[[serverPatient objectForKey:SEX]integerValue]] forKey:SEX];
                
                [serverPatient removeObjectForKey:PICTURE];
               
                BOOL success = [self setValueToDictionaryValues:serverPatient];
                
                if (success) {
                    [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
                        
                    }];
                }else{
                    error = [[NSError alloc]initWithDomain:COMMONDATABASE code:kErrorObjectMisconfiguration userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Object was misconfigured",NSLocalizedFailureReasonErrorKey, nil]];
                    break;
                }

            }
        }
        
        onComplete((!error)?self:nil,error);
        
    }];
}
-(void)pushToCloud:(CloudCallback)onComplete{
    
    NSArray* allPatients= [self FindAllObjects];
    
    [self makeCloudCallWithCommand:UPDATEPATIENT withObject:[NSDictionary dictionaryWithObject:allPatients forKey:DATABASE] onComplete:^(id cloudResults, NSError *error) {
        onComplete(cloudResults,error);
    }];
}
@end
