////  PatientObject.m//  Mobile Clinic////  Created by Steven Berlanga on 2/4/13.//  Copyright (c) 2013 Steven Berlanga. All rights reserved.//#define ALLpatientS @"all patients"#define DATABASE    @"Patients"#import "PatientObject.h"#import "StatusObject.h"#import "UIImage+ImageVerification.h"#import "Patients.h"StatusObject* tempStatusObject;@implementation PatientObject- (id)initWithNewPatient{    self = [super init];    if (self) {                self.databaseObject = [self CreateANewObjectFromClass:DATABASE];                [self linkPatient];                if (!_visits) {            _visits = [[NSMutableArray alloc]init];        }    }    return self;}#pragma mark- Protocol Methods#pragma mark--(NSDictionary *)consolidateForTransmitting:(NSManagedObject *)object{        NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting:object]];    [consolidate setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];    return consolidate;}-(void)unpackageFileForUser:(NSDictionary *)data{    [super unpackageFileForUser:data];    [self linkPatient];    [patient setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];    }-(void)saveObject:(ObjectResponse)eventResponse{    [self linkPatient];    // Database object needs to exist    if (patient){        [super SaveAndRefreshObjectToDatabase:patient];        eventResponse(self,nil);    }else{        eventResponse(Nil,[self createErrorWithDescription:@"No Patient has been selected" andErrorCodeNumber:0 inDomain:@"Patient Object"]);    }}-(void)setDBObject:(NSManagedObject *)databaseObject{    [super setDBObject:databaseObject];    [self linkPatient];    }#pragma mark- Public Methods#pragma mark--(NSString *)description{    NSString* text = [NSString stringWithFormat:@"\nFirst Name: %@ \nLast Name: %@ \nVillage %@\nObjectType: %i",patient.firstName,patient.familyName,patient.villageName, self.objectType];    return text;}-(NSArray *)FindAllPatientsLocallyWithFirstName:(NSString *)firstname andWithLastName:(NSString *)lastname{    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K contains[cd] %@ || %K contains[cd] %@",FIRSTNAME,firstname,FAMILYNAME,lastname];        return [self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:FIRSTNAME];}-(void)FindAllPatientsOnServerWithFirstName:(NSString *)firstname andWithLastName:(NSString *)lastname onCompletion:(ObjectResponse)eventResponse{        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];        [center addObserver:self selector:@selector(QueryForPatientActionSuccessfull:) name:GLOBAL_STATUS_LISTENER object:tempStatusObject];        respondToEvent = eventResponse;        NSMutableDictionary* query = [[NSMutableDictionary alloc]initWithCapacity:4];        [query setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];    [query setValue:[NSNumber numberWithInt:kFindPatientsByName] forKey:OBJECTCOMMAND];        [query setValue:firstname forKey:FIRSTNAME];    [query setValue:lastname forKey:FAMILYNAME];        [self tryAndSendData:query withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {        [self QueryForPatientActionSuccessfull:nil];    }];    }-(void)createNewPatient:(ObjectResponse)onSuccessHandler{    [self linkPatient];  //TODO: Remove Spaces and Lowercase certain fields    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];    [center addObserver:self selector:@selector(CreatePatientActionSuccessfull:) name:GLOBAL_STATUS_LISTENER object:tempStatusObject];        respondToEvent = onSuccessHandler;        // Check for patientID    if (!patient.patientId.isNotEmpty) {        // Adds an ID if it is not present        patient.patientId = [NSString stringWithFormat:@"%@.%@.%@.%@",patient.firstName,patient.familyName,patient.villageName,[[NSDate date]description]];    }        // validate patient info    if ([self isValidateIfPatientInformationIsPresent]) {                [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {            if (!error)            {                NSMutableDictionary* dataToSend = [NSMutableDictionary dictionaryWithDictionary:[self consolidateForTransmitting:patient]];                [dataToSend setValue:[NSNumber numberWithInt:kCreateNewPatient] forKey:OBJECTCOMMAND];                                [self tryAndSendData:dataToSend withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {                    [self CreatePatientActionSuccessfull:nil];                }];            }        }];    }  }-(NSString *)getSex{    [self linkPatient];    return (patient.sex.intValue == 0)?@"Female":@"Male";}-(NSManagedObject *)getDBObject{    [self linkPatient];    return patient;}-(void)setPhoto:(UIImage*)image{    [self linkPatient];    [patient setPhoto:[image convertImageToPNGBinaryData]];}- (NSInteger)getAge{    [self linkPatient];    return [patient.age getNumberOfYearsElapseFromDate];}-(NSString *)getDateOfBirth{    [self linkPatient];    return [patient.age convertNSDateFullBirthdayString];}- (UIImage *)getPhoto{    [self linkPatient];    return [UIImage imageWithData:patient.photo];}-(void)addVisitToCurrentPatient:(VisitationObject *)visitation{    [self linkPatient];    _currentVisit = visitation;    [patient addVisitObject:(Visitation*)_currentVisit.databaseObject];    [_currentVisit setObject:patient.patientId withAttribute:PATIENTID];}-(BOOL)loadPatientWithPatientID:(NSString *)patientId{    [self linkPatient];    // checks to see if object exists    NSArray* arr = [self FindObjectInTable:DATABASE withName:patientId forAttribute:PATIENTID];        if (arr.count == 1) {        patient = [arr objectAtIndex:0];        return  YES;    }    return  NO;}#pragma mark- Internal Private Methods#pragma mark--(void)CreatePatientActionSuccessfull:(NSNotification *)notification{    tempStatusObject = notification.object;        if (!notification) {        respondToEvent(nil,[self createErrorWithDescription:@"Patient saved but was could synced with server." andErrorCodeNumber:10 inDomain:@"PatientObject"] );    }    else if (tempStatusObject.status == kSuccess) {        // Activate the callback so user knows it was successful        respondToEvent(self, nil);    }else{        respondToEvent(nil,[self createErrorWithDescription:tempStatusObject.errorMessage andErrorCodeNumber:10 inDomain:@"PatientObject"] );    }        // Remove event listener    [[NSNotificationCenter defaultCenter]removeObserver:self];}-(void)QueryForPatientActionSuccessfull:(NSNotification *)notification{    if (!notification) {        respondToEvent(nil, [self createErrorWithDescription:@"Search result may be incomplete due to lost connection with the server" andErrorCodeNumber:10 inDomain:@"PatientObject"]);    }else if (tempStatusObject.status == kSuccess) {        // Activate the callback so user knows it was successful         tempStatusObject = notification.object;        [self SaveListOfPatientsToTheDatabase:tempStatusObject.data];        respondToEvent(self, nil);    }else{        respondToEvent(nil,[self createErrorWithDescription:tempStatusObject.errorMessage andErrorCodeNumber:10 inDomain:@"PatientObject"] );    }        // Remove event listener    [[NSNotificationCenter defaultCenter]removeObserver:self];}-(void)SaveListOfPatientsToTheDatabase:(NSDictionary*)patientList{    [self linkPatient];    // get all the users returned from server    NSArray* arr = [patientList objectForKey:ALLpatientS];        // Go through all users in array    for (NSDictionary* dict in arr) {        // If the user doesnt exists in the database currently then add it in        if (![self loadPatientWithPatientID:[dict objectForKey:PATIENTID]]) {            patient = (Patients*)[self CreateANewObjectFromClass:DATABASE];        }                [patient setValuesForKeysWithDictionary:dict];        [self SaveCurrentObjectToDatabase];    }}-(NSMutableArray*)packagedVisits{    NSMutableArray* completeVisits = [[NSMutableArray alloc]initWithCapacity:_visits.count];//    for (VisitationObject* visit in _visits) {//        [completeVisits addObject:[visit consolidateForTransmitting]];//    }return completeVisits;}//// Used to unpack all the visits//-(NSArray*)unpackageVisits:(NSArray*)packagedVists//{//    if (!_visits) {//        _visits = [[NSMutableArray alloc]initWithCapacity:packagedVists.count];//    }//    //    for (NSDictionary* visitInformation in packagedVists) {//        VisitationObject* visit = [[VisitationObject alloc]initWithVisit:visitInformation];//        [_visits addObject:visit];//    }//    return _visits;//}-(BOOL)isValidateIfPatientInformationIsPresent{    if (!patient.firstName.isNotEmpty) {        return NO;    }else if (!patient.familyName.isNotEmpty){        return NO;    }else if(!patient.patientId.isNotEmpty){        return NO;    }else{        return YES;    }    }-(NSArray*)getAllVisitsForCurrentPatient{       if (!_visits) {        _visits = [[NSMutableArray alloc]initWithCapacity:patient.visit.count];    }else if (_visits.count>0) {        [_visits removeAllObjects];    }        for (Visitation* visit in patient.visit) {        VisitationObject* vObject = [[VisitationObject alloc]initWithVisit:visit];        [_visits addObject:vObject];    }    return  _visits;}-(void)linkPatient{    patient = (Patients*)self.databaseObject;}//TODO: Need a method to push all patients to the server@end