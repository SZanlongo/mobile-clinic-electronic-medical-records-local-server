////  PatientObject.m//  Mobile Clinic////  Created by Steven Berlanga on 2/4/13.//  Copyright (c) 2013 Steven Berlanga. All rights reserved.//#define FIRSTNAME   @"firstName"#define FAMILYNAME  @"familyName"#define PHYSICIAN   @"physician"#define VILLAGE     @"villageName"#define HEIGHT      @"height"#define SEX         @"sex"#define DOB         @"age"#define PICTURE     @"photo"#define VISITS      @"visits"#define PATIENTID   @"patientId"#define DATABASE    @"Patients"#import "PatientObject.h"#import "StatusObject.h"#import "UIImage+ImageVerification.h"#import "Patients.h"StatusObject* tempObject;@implementation PatientObject- (id)initWithNewPatient{    self = [super init];    if (self) {        _patient = (Patients*)[self CreateANewObjectFromClass:DATABASE];                if (!_visits) {            _visits = [[NSMutableArray alloc]init];        }    }    return self;}#pragma mark- Protocol Methods#pragma mark--(NSDictionary *)consolidateForTransmitting:(NSManagedObject *)object{        NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting:object]];    //[consolidate setValue:[self packagedVisits] forKey:VISITS];    [consolidate setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];    return consolidate;}-(void)unpackageFileForUser:(NSDictionary *)data{    [super unpackageFileForUser:data];    [_patient setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];        // [self unpackageVisits:[data objectForKey:VISITS]];    }-(void)saveObject:(ObjectResponse)eventResponse{    respondToEvent = eventResponse;    // Database object needs to exist    if (_patient){                [self SaveCurrentObjectToDatabase];                respondToEvent(self,nil);    }else{        respondToEvent(Nil,[self createErrorWithDescription:@"No Patient has been selected" andErrorCodeNumber:0 inDomain:@"Patient Object"]);    }}#pragma mark- Public Methods#pragma mark--(NSString *)description{    NSString* text = [NSString stringWithFormat:@"\nFirst Name: %@ \nLast Name: %@ \nVillage %@\nObjectType: %i",_patient.firstName,_patient.familyName,_patient.villageName, self.objectType];    return text;}-(void)createNewPatient:(ObjectResponse)onSuccessHandler{       NSNotificationCenter* center = [NSNotificationCenter defaultCenter];    [center addObserver:self selector:@selector(CreatePatientActionSuccessfull:) name:GLOBAL_STATUS_LISTENER object:tempObject];        respondToEvent = onSuccessHandler;        // Check for patientID    if (!_patient.patientId.isNotEmpty) {        // Adds an ID if it is not present        _patient.patientId = [NSString stringWithFormat:@"%@.%@.%@",_patient.firstName,_patient.familyName,[[NSDate date]description]];    }        // validate patient info    if ([self isValidateIfPatientInformationIsPresent]) {        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {            if (!error)            {                NSMutableDictionary* dataToSend = [NSMutableDictionary dictionaryWithDictionary:[self consolidateForTransmitting:_patient]];                [dataToSend setValue:[NSNumber numberWithInt:kCreateNewPatient] forKey:OBJECTCOMMAND];                [self.appDelegate.ServerManager sendData:dataToSend];            }        }];    }  }- (NSInteger)getAge{    return [_patient.age getNumberOfYearsElapseFromDate];}- (UIImage *)getPhoto{    return [UIImage imageWithData:_patient.photo];}//- (NSString *)getSex:(NSNumber)sex//{//    if (sex == 0)//        return @"Male";//    else if (sex == 1)//        return @"Female";//    else//        return @"";//}#pragma mark- Internal Private Methods#pragma mark--(void)CreatePatientActionSuccessfull:(NSNotification *)notification{    if (tempObject.status == kSuccess) {        // Activate the callback so user knows it was successful        respondToEvent(self, nil);    }else{        respondToEvent(nil,[self createErrorWithDescription:tempObject.errorMessage andErrorCodeNumber:10 inDomain:@"PatientObject"] );    }        // Remove event listener    [[NSNotificationCenter defaultCenter]removeObserver:self];}-(NSMutableArray*)packagedVisits{    NSMutableArray* completeVisits = [[NSMutableArray alloc]initWithCapacity:_visits.count];//    for (VisitationObject* visit in _visits) {//        [completeVisits addObject:[visit consolidateForTransmitting]];//    }return completeVisits;}// Used to unpack all the visits-(NSArray*)unpackageVisits:(NSArray*)packagedVists{    if (!_visits) {        _visits = [[NSMutableArray alloc]initWithCapacity:packagedVists.count];    }        for (NSDictionary* visitInformation in packagedVists) {        VisitationObject* visit = [[VisitationObject alloc]initWithVisit:visitInformation];        [_visits addObject:visit];    }    return _visits;}-(BOOL)isValidateIfPatientInformationIsPresent{    if (!_patient.firstName.isNotEmpty) {        return NO;    }else if (!_patient.familyName.isNotEmpty){        return NO;    }else if(!_patient.patientId.isNotEmpty){        return NO;    }else{        return YES;    }    }//May not be needed-(void)addVisitToPatient:(VisitationObject*)visit{    [_visits addObject:visit];}-(NSArray *)FindAllPatientsLocallyWithFirstName:(NSString *)firstname andWithLastName:(NSString *)lastname{    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K contains[cd] %@ || %K contains[cd] %@",FIRSTNAME,firstname,FAMILYNAME,lastname];      return [self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:FIRSTNAME];}-(void)FindAllPatientsOnServerWithFirstName:(NSString *)firstname andWithLastName:(NSString *)lastname onCompletion:(ObjectResponse)eventResponse{        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];        [center addObserver:self selector:@selector(QueryForPatientActionSuccessfull:) name:GLOBAL_STATUS_LISTENER object:tempObject];        respondToEvent = eventResponse;        NSMutableDictionary* query = [[NSMutableDictionary alloc]initWithCapacity:4];        [query setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];    [query setValue:[NSNumber numberWithInt:kFindPatientsByName] forKey:OBJECTCOMMAND];       [query setValue:firstname forKey:FIRSTNAME];    [query setValue:lastname forKey:FAMILYNAME];       [self.appDelegate.ServerManager sendData:query];}-(void)QueryForPatientActionSuccessfull:(NSNotification *)notification{    if (tempObject.status == kSuccess) {        // Activate the callback so user knows it was successful        respondToEvent(self, nil);    }else{        respondToEvent(nil,[self createErrorWithDescription:tempObject.errorMessage andErrorCodeNumber:10 inDomain:@"PatientObject"] );    }        // Remove event listener    [[NSNotificationCenter defaultCenter]removeObserver:self];}-(BOOL)loadPatientWithPatientID:(NSString *)patientId{    // checks to see if object exists    NSArray* arr = [self FindObjectInTable:DATABASE withName:patientId forAttribute:PATIENTID];        if (arr.count == 1) {        _patient = [arr objectAtIndex:0];        return  YES;    }    return  NO;}//TODO: Need a method to push all patients to the server@end