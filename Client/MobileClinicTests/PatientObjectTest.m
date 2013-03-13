//
//  PatientObjectTest.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/6/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#import <GHUnitIOS/GHUnit.h>
#import "PatientObject.h"
#import "ServerCore.h"

@interface PatientObjectTest: GHAsyncTestCase {
   
    ServerCore* server;
}

@end

@implementation PatientObjectTest

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return YES;
}

- (void)setUpClass {
    server = [[ServerCore alloc]init];
   // [server startClient];
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}
- (void)testSimplePass {
	[self waitFor:kGHUnitWaitStatusSuccess timeout:5];
}

- (void)testSimpleFail {
	GHAssertTrue(NO, nil);
}
// simple test to ensure building, linking,
// and running test case works in the project

@end