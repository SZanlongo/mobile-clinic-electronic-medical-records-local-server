//
//  PatientObjectTest.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/6/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#import <GHUnitIOS/GHUnit.h>

@interface PatientObjectTest : GHTestCase { }
@end

@implementation PatientObjectTest

- (void)testSimplePass {
	// Another test
}

- (void)testSimpleFail {
	GHAssertTrue(NO, nil);
}
// simple test to ensure building, linking,
// and running test case works in the project

@end