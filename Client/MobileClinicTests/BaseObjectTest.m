//
//  BaseObjectTest.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/12/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h> 
#import "BaseObject.h"
#import "PatientObject.h"
@interface BaseObjectTest : GHTestCase {
    BaseObject* base;
    NSMutableDictionary* testData;
}
@end

NSString* PATIENTID;
@implementation BaseObjectTest

- (void)setUpClass {
    PATIENTID  = @"patientId";
    // [server startClient];
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    base = [[BaseObject alloc]initWithDatabase:@"Patients"];
    
    testData = [[NSMutableDictionary alloc]initWithCapacity:5];
  
    [testData setValue:@"Michael" forKey:FIRSTNAME];
    [testData setValue:@"Montaque" forKey:FAMILYNAME];
    [testData setValue:@"Village" forKey:VILLAGE];
    [testData setValue:@"Michael.9084" forKey:PATIENTID];
    [testData setValue:[NSNumber numberWithInt:1] forKey:SEX];
}

- (void)tearDown {
    // Run after each test method
}

- (void) testUnpackagingFileForUser {
   
    [base unpackageFileForUser:testData];
   
    GHAssertEqualStrings([base.databaseObject valueForKey:PATIENTID], @"Michael.9084", @"Patient's ID should be Michael.9084");
}

@end
