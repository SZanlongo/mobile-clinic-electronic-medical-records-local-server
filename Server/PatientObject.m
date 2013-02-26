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
#define ALL_PATIENTS @"all patients"
#define DATABASE    @"Patients"


#import "StatusObject.h"
#import "NSString+Validation.h"
#import "Patients.h"

NSString* firstname;
NSString* lastname;
@implementation PatientObject


#pragma mark - BaseObjectProtocol Methods
#pragma mark -

/* The super needs to be called first */
-(NSDictionary *)consolidateForTransmitting:(NSManagedObject *)object{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting:object]];

    [consolidate setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    
    // Possible that not all values may be set
    // so depending on the command the appropriate action is taken
    switch (self.commands) {
        case kFindPatientsByName:
            firstname = [data objectForKey:FIRSTNAME];
            lastname = [data objectForKey:FAMILYNAME];
            break;
        case kCreateNewPatient:
        default:
            _patient = (Patients*)[self CreateANewObjectFromClass:DATABASE];
            [_patient setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
            break;
    }
}

/* Depending on the RemoteCommands it will execute a different Command */
-(void)CommonExecution
{
    switch (self.commands) {
        case kCreateNewPatient:
            [self UpdatePatientWithErrorMessage:@"Patient could not be saved on the server" andSuccessMessage:@"Patient was saved on the server"];
            break;
        case kUpdatePatients:
            [self UpdatePatientWithErrorMessage:@"Patient could not be updated on the server" andSuccessMessage:@"Patient was succesfully updated on the server"];
            break;
        case kFindPatientsByName:
            [self FindPatientByName];
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

-(void)UpdatePatientWithErrorMessage:(NSString*)errorMessage andSuccessMessage:(NSString*)success{
    // Find and return object if it exists
    StatusObject* status = [[StatusObject alloc]init];
    
    // Need to set client so it can go the correct device
    [status setClient:self.client];
    
    // Save internal information to the patient object
    [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
        if (error) {
            // Create message
            [status setErrorMessage:errorMessage];
            [status setStatus:kError];
        }else{
            // Create message
            [status setErrorMessage:success];
            [status setStatus:kSuccess];
        }
        // send status back to requested client
        [status CommonExecution];
    }];

}

-(NSArray *)FindAllPatientsLocallyWithFirstName:(NSString *)firstname andWithLastName:(NSString *)lastname
{
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K contains[cd] %@ || %K contains[cd] %@",FIRSTNAME,firstname,FAMILYNAME,lastname];
    
    return [self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:FIRSTNAME];
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
    
    StatusObject* status = [[StatusObject alloc]init];
    // Need to set client so it can go the correct device
    [status setClient:self.client];
    // status will hold a copy of this user data
    [status setData:dict];
    // Indicates that this was a success
    [status setStatus:kSuccess];
    // Its good to send a message
    [status setErrorMessage:@"Search Completed"];
    // Let the status object send this information
    [status CommonExecution];
}


@end
