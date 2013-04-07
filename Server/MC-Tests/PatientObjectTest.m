//
//  PatientObjectTest.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 4/7/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

//
//  BaseObject+Protected.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 4/5/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "PatientObject.h"

#import <GHUnit/GHUnit.h>

@interface PatientObjectTest : GHTestCase {
    id<PatientObjectProtocol> underTest;
    NSMutableDictionary* testObject;
}
@end

@implementation PatientObjectTest

- (void)setUpClass {
    // Run at start of all tests in the class
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    underTest = [[UserObject alloc]init];
    
    /* Setup test user */
    testObject = [[NSMutableDictionary alloc]initWithCapacity:8];
    [testObject setValue:@"Daniel" forKey:FIRSTNAME];
    [testObject setValue:@"Dover" forKey:FAMILYNAME];
    [testObject setValue:[NSNumber numberWithInt:1032853245] forKey:DOB];
    [testObject setValue:[NSNumber numberWithInt:1] forKey:SEX];
    [testObject setValue:@"JamesFortune_1834257321" forKey:PATIENTID];
    [testObject setValue:[NSNumber numberWithBool:YES] forKey:ISOPEN];
    [testObject setValue:"Wispy Meadow" forKey:VILLAGE];
    [testObject setValue:[NSNumber numberWithBool:YES] forKey:STATUS];
}

- (void)tearDown {
    [objectUnderTest deleteDatabaseDictionaryObject:testUser];
    testUser = nil;
    objectUnderTest = nil;
    
}

@end
