//
//  PatientObject.m
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/11/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "PatientObject.h"


#define STATUS      @"status"
#define LASTNAME    @"lastname"
#define FIRSTNAME   @"firstname"
#define SEX         @"sex"
#define WEIGHT      @"weight"
#define AGE         @"age"
#define VILLIAGE    @"villiage" //The different user types (look at enum)
#define DATABASE    @"Patients"

#import "Patient.h"
#import "StatusObject.h"
#import "NSString+Validation.h"

@implementation PatientObject


#pragma mark - BaseObjectProtocol Methods
#pragma mark -

/* The super needs to be called first */
-(NSDictionary *)consolidateForTransmitting{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting]];
    
    [consolidate setValue:_firstName forKey:FIRSTNAME];
    [consolidate setValue:_lastName forKey:LASTNAME];
    [consolidate setValue:_villiage forKey:VILLIAGE];
    [consolidate setValue:_sex forKey:SEX];
    [consolidate setValue:_weight  forKey:WEIGHT];
    [consolidate setValue:[NSNumber numberWithBool:_status] forKey:STATUS];
    [consolidate setValue:_age forKey:AGE];

    
    return consolidate;
}
/* The super needs to be called first */
-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    
    _lastName = [data objectForKey:LASTNAME];
    _firstName = [data objectForKey:FIRSTNAME];
    _villiage = [data objectForKey:VILLIAGE];
    _sex = [NSNumber numberWithInt:[[data objectForKey:SEX]intValue]];
    _weight = [NSNumber numberWithInt:[[data objectForKey:WEIGHT]intValue]];
    _age = [NSNumber numberWithInt:[[data objectForKey:AGE]intValue]];
    _status = [[data objectForKey:STATUS]boolValue];
    self.commands = [[data objectForKey:OBJECTCOMMAND]intValue];
}
/* The super needs to be called first */
-(void)unpackageDatabaseFileForUser:(NSManagedObject *)object{
    [super unpackageDatabaseFileForUser:object];

    _lastName = [self getValueForKey:LASTNAME];
    _firstName = [self getValueForKey:FIRSTNAME];
    _villiage = [self getValueForKey:VILLIAGE];
    _sex = [NSNumber numberWithInt:[[self getValueForKey:SEX]intValue]];
    _weight = [NSNumber numberWithInt:[[self getValueForKey:WEIGHT]intValue]];
    _age = [NSNumber numberWithInt:[[self getValueForKey:AGE]intValue]];
    _status = [[self getValueForKey:STATUS]intValue];
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
        case kLogoutUser:
            
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
    
    if (databaseObject){
        
        [super saveObject:^(id<BaseObjectProtocol> data, NSError* error) {
            [self addObjectToDatabaseObject:_firstName forKey:FIRSTNAME];
            [self addObjectToDatabaseObject:_lastName forKey:LASTNAME];
            [self addObjectToDatabaseObject:_villiage forKey:VILLIAGE];
            [self addObjectToDatabaseObject:_sex forKey:SEX];
            [self addObjectToDatabaseObject:_weight forKey:WEIGHT];
            [self addObjectToDatabaseObject:[NSNumber numberWithBool:_status] forKey:STATUS];
            [self addObjectToDatabaseObject:_age forKey:AGE];
        }];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:SAVE_USER object:self];
    }
}

#pragma mark - Private Methods
#pragma mark -

-(NSString *)description
{
    NSString* text = [NSString stringWithFormat:@"\nFirst Name: %@ \nLast Name: %@ \nVillage %@\nObjectType: %i\nSex: %@ \nWeight: %@ \nAge %@\n",_firstName,_lastName,_villiage, self.objectType, _sex,_weight,_age];
    return text;
}


-(void)CreateANewPatient:(ObjectResponse)onSuccessHandler
{
    // Find and return object if it exists
    StatusObject* status = [[StatusObject alloc]init];
    // Need to set client so it can go the correct device
    [status setClient:self.client];
    
    // Run Complete validation on the information given
    // if there is an error it will be stored in the status var
        if (![self FindDataBaseObjectWithID]){
            [self CreateANewObjectFromClass:DATABASE];
        }
        [self saveObject:nil];
        [status setErrorMessage:@"Patient has been created."];
    
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
    
    // Run Complete validation on the information given
    // if there is an error it will be stored in the status var
    if (![self FindDataBaseObjectWithID]){
        [self CreateANewObjectFromClass:DATABASE];
    }
    [self saveObject:nil];
    [status setErrorMessage:@"Patient has been updated."];
    
    [status CommonExecution];

    
}

@end
