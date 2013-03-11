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

PatientObject* patient;
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

/**
 *  Given that i have a patient object
 *  And I add values to a dictionary
 *  When i call the setValueToDictionaryValues
 *  Then the patient.database should contain the same values
 */
- (void)testCreatingANewLocalPatient
{
    [self setUp];
    NSMutableDictionary* testPatient = [[NSMutableDictionary alloc]init];

    [testPatient setValue:@"Mike" forKey:FIRSTNAME];
    [testPatient setValue:@"Mont" forKey:FAMILYNAME];
    [testPatient setValue:@"Mia" forKey:VILLAGE];
    [testPatient setValue:[NSDate date] forKey:DOB];
    
    patient =[[PatientObject alloc]init];
    [patient setValueToDictionaryValues:testPatient];

    [self tearDown];
}
/**
 *  Given that i have a patient object with a database object that is empty
 *  And i create a null dictionary
 *  When when i call the setValueToDictionaryValues
 *  Then patient.database should remain empty
 */
- (void)testOCMockPass {
    id mock = [OCMockObject mockForClass:NSString.class];
    [[[mock stub] andReturn:@"mocktest"] lowercaseString];

    NSString *returnValue = [mock lowercaseString];
    GHAssertEqualObjects(@"mocktest", returnValue,
                         @"Should have returned the expected string.");
}

@end
