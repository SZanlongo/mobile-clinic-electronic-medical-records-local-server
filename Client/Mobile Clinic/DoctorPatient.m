//
//  DoctorPatient.m
//  Mobile Clinic
//
//  Created by Rigo Hernandez on 3/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "DoctorPatientViewController.h"
@interface DoctorPatient : GHTestCase {
    DoctorPatientViewController* dpvc;
}
@end

@implementation DoctorPatient
- (void)setUpClass {
   
    // [server startClient];
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {

    dpvc = [[DoctorPatientViewController alloc]init];

}

- (void)tearDown {
    dpvc = nil;
}
-(void) testThisIsMe{
    
}
@end
