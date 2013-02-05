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
@implementation Mobile_ClinicTests

- (void)setUp
{
    [super setUp];
    loginScreen = [UIViewController getViewControllerFromiPadStoryboardWithName:LOGIN_SCREEN];
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

@end
