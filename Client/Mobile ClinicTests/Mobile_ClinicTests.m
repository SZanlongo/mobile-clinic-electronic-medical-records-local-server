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
#import "FIUPatientRegistrationViewController.h"

FIUPatientRegistrationViewController *pReg;
@implementation Mobile_ClinicTests

- (void)setUp
{
    [super setUp];
    loginScreen = [UIViewController getViewControllerFromiPadStoryboardWithName:LOGIN_SCREEN];
    pReg = [[FIUPatientRegistrationViewController alloc] init];
    user = [[UserObject alloc]init];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    loginScreen = Nil;
    [super tearDown];
}

- (void)testUserObjectSendingValidInformation
{
    [self setUp];
    user.username = TEST_CHAR;
    user.password = @"";
    
    [user CreateANewUser:^(id<BaseObjectProtocol> data, NSError *error) {
        STAssertNil(data, @"There should be no data passed when an error is thrown");
        STAssertNotNil(error, error.localizedDescription);
    }];
    
    user.username = @"!@($*#&@@";
    user.password = TEST_CHAR_PW;
    
    [user CreateANewUser:^(id<BaseObjectProtocol> data, NSError *error) {
        STAssertNil(data, @"There should be no data passed when an error is thrown");
        STAssertNotNil(error, error.localizedDescription);
    }];
    
    user.username = TEST_CHAR;
    user.password = TEST_CHAR_PW;
    
    [user CreateANewUser:^(id<BaseObjectProtocol> data, NSError *error) {
        STAssertNil(data, @"There should be no data passed when an error is thrown");
        STAssertNotNil(error, error.localizedDescription);
    }];

}


-(void)testValidateRegistration {
    [self setUp];
    [pReg view];
    
    //all of this below checks for empty input
    STAssertFalse([pReg validateRegistration], @"family name empty");
    [pReg.familyNameField setText:@"last"];
    
    STAssertFalse([pReg validateRegistration], @"patient name empty");
    [pReg.patientNameField setText:@"first"];
    
    STAssertFalse([pReg validateRegistration], @"village name empty");
    [pReg.villageNameField setText:@"village"];
    
    STAssertFalse([pReg validateRegistration], @"patient weight empty");
    [pReg.patientWeightField setText:@"weight"];
    
    //now that the weight and age are non null, check that they are numbers
    STAssertFalse([pReg validateRegistration], @"patient weight is not a number");
    [pReg.patientWeightField setText:@"150"];
    
    STAssertFalse([pReg validateRegistration], @"patient age empty");
    [pReg.patientAgeField setText:@"age"];
    
    STAssertFalse([pReg validateRegistration], @"patient age is not a number");
    [pReg.patientAgeField setText:@"50"];
    
    //check that all of the above tests completed successfuly, and that we return true
    STAssertTrue([pReg validateRegistration], @"validate registration works");
    
    
    
    [self tearDown];
}

@end
