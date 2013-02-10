////  PatientObject.m//  Mobile Clinic////  Created by Steven Berlanga on 2/4/13.//  Copyright (c) 2013 Steven Berlanga. All rights reserved.//#define FIRSTNAME   @"firstName"#define FAMILYNAME  @"familyName"#define VILLAGE     @"villageName"#define HEIGHT      @"height"#define SEX         @"sex"#define DOB         @"age"#define PICTURE     @"photo"#define DATABASE    @"Patients"#import "PatientObject.h"#import "StatusObject.h"#import "UIImage+ImageVerification.h"StatusObject* tempObject;@implementation PatientObject-(NSDictionary *)consolidateForTransmitting{        NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithCapacity:4];    [consolidate setValue:_firstName forKey:FIRSTNAME];    [consolidate setValue:_familyName forKey:FAMILYNAME];    [consolidate setValue:_village forKey:VILLAGE];    [consolidate setValue:[_picture convertImageToPNGBinaryData] forKey:PICTURE];    [consolidate setValue:_dob forKey:DOB];    return consolidate;}-(void)unpackageFileForUser:(NSDictionary *)data{    [super unpackageFileForUser:data];    _firstName = [data objectForKey:FIRSTNAME];    _familyName = [data objectForKey:FAMILYNAME];    _village = [data objectForKey:VILLAGE];    _sex = (int)[data objectForKey:SEX];    _picture = [UIImage imageWithData:[data objectForKey:PICTURE]];    _dob = [data objectForKey:DOB];}-(void)unpackageDatabaseFileForUser:(NSManagedObject *)object{    [super unpackageDatabaseFileForUser:object];    _village = [self getValueForKey:VILLAGE];    _familyName= [self getValueForKey:FAMILYNAME];    _firstName = [self getValueForKey:FIRSTNAME];    _sex = [[self getValueForKey:SEX]intValue];    _picture = [UIImage imageWithData:[self getValueForKey:PICTURE]];    _dob = [self getValueForKey:DOB];}-(void)saveObject:(ObjectResponse)eventResponse{    respondToEvent = eventResponse;    // First check to see if a databaseObject is present    if (!databaseObject)        // Otherwise create a new object from scratch        [self CreateANewObjectFromClass:DATABASE];            [super saveObject:^(id<BaseObjectProtocol> data, NSError* error) {            [self addObjectToDatabaseObject:_familyName forKey:FAMILYNAME];            [self addObjectToDatabaseObject:_village forKey:VILLAGE];            [self addObjectToDatabaseObject:_firstName forKey:FIRSTNAME];            [self addObjectToDatabaseObject:[NSNumber numberWithInt:_sex] forKey:SEX];            [self addObjectToDatabaseObject:[_picture convertImageToPNGBinaryData]  forKey:PICTURE];            [self addObjectToDatabaseObject:_dob forKey:DOB];        }];            respondToEvent(self,nil);}-(void)CommonExecution{    NSLog(@"Doesn't need to be implemented Client-side");}-(NSString *)description{    NSString* text = [NSString stringWithFormat:@"\nFirst Name: %@ \nLast Name: %@ \nVillage %@\nObjectType: %i",_firstName,_familyName,_village, self.objectType];    return text;}-(void)createNewPatient:(ObjectResponse)onSuccessHandler{    respondToEvent = onSuccessHandler;    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];    [center addObserver:self selector:@selector(ActionSuccessfull:) name:GLOBAL_STATUS_LISTENER object:tempObject];        NSMutableDictionary* dataToSend = [NSMutableDictionary dictionaryWithDictionary:[self consolidateForTransmitting]];        [dataToSend setValue:[NSNumber numberWithInt:kCreateNewPatient] forKey:OBJECTCOMMAND];        [self.appDelegate.ServerManager sendData:dataToSend];}-(void)ActionSuccessfull:(NSNotification *)notification{        if (tempObject.status == kSuccess) {        // Reset this object with the information brought back through the server        [self unpackageFileForUser:tempObject.data];        // Activate the callback so user knows it was successful        respondToEvent(self, nil);    }else{        respondToEvent(nil,[self createErrorWithDescription:tempObject.errorMessage andErrorCodeNumber:10 inDomain:@"PatientObject"] );    }        // Remove event listener    [[NSNotificationCenter defaultCenter]removeObserver:self];        // Save the new user information that has been returned    [self saveObject:nil];}-(NSInteger)getAge{    return [_dob getNumberOfYearsElapseFromDate];}@end