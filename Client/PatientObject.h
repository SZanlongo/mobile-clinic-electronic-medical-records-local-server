////  PatientObject.h//  Mobile Clinic////  Created by Steven Berlanga on 2/4/13.//  Copyright (c) 2013 Steven Berlanga. All rights reserved.//#import "BaseObject.h"#import "NSObject+CustomTools.h"#import "VisitationObject.h"#import "Patients.h"@interface PatientObject : BaseObject@property(nonatomic, strong)        Patients* patient;@property(nonatomic, strong)        NSMutableArray* visits;//----> 0 = Female, 1 = Male <---//-(NSInteger)getAge;-(UIImage*)getPhoto;- (id)initWithNewPatient;/* call to send this object to be store a new patient */-(void)createNewPatient:(ObjectResponse)onSuccessHandler;-(void)addVisitToPatient:(VisitationObject*)visit;-(BOOL)loadPatientWithPatientID:(NSString *)patientID;-(NSArray*)FindAllPatientsLocallyWithFirstName:(NSString*)firstname andWithLastName:(NSString*)lastname;-(void)FindAllPatientsOnServerWithFirstName:(NSString *)firstname andWithLastName:(NSString *)lastname onCompletion:(ObjectResponse)eventResponse;@end