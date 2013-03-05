//
//  Mobile_ClinicTests.m
//  Mobile ClinicTests
//
//  Created by Steven Berlanga on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#define TEST_CHAR @"montaque22"
#define TEST_CHAR_PW @"000000"
#define LOGIN_SCREEN @"loginScreen"

#import "Mobile_ClinicTests.h"
#import "UIViewControllerExt.h"
#import "PatientObject.h"
#import "UserObject.h"

id<PatientObjectProtocol> patient;
UserObject* user;
@implementation Mobile_ClinicTests

- (void)setUp
{
    [super setUp];
    user = [[UserObject alloc]initWithDatabase:[UserObject DatabaseName]];
    patient = [[PatientObject alloc]initWithDatabase:[PatientObject DatabaseName]];
    
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}
- (void)testUserObjectSendingInvalidUsername{
    [self setUp];
    [user setObject:@"" withAttribute:PASSWORD];
    [user setObject:TEST_CHAR withAttribute:USERNAME];
    
    
    [user loginWithUsername:USERNAME andPassword:PASSWORD onCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
        
    }];
    [self tearDown];
}
- (void)testCreatingANewLocalPatient
{
    [self setUp];
    NSMutableDictionary* testPatient = [[NSMutableDictionary alloc]init];
    UIImage* img = [UIImage imageNamed:@"orant_logo.png"];
    [testPatient setValue:@"Mike" forKey:FIRSTNAME];
    [testPatient setValue:@"Mont" forKey:FAMILYNAME];
    [testPatient setValue:@"Mia" forKey:VILLAGE];
    [testPatient setValue:[NSDate date] forKey:DOB];

   // patient =[[PatientObject alloc]initAndFillWithNewObject:testPatient andRelatedDatabase:[PatientObject DatabaseName]];
    
//    [patient createNewPatientLocally:^(id<BaseObjectProtocol> data, NSError *error) {
//        
//    }];

    [self tearDown];
}


@end
