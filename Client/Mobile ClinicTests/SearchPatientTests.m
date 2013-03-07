//
//  SearchPatientTests.m
//  Mobile Clinic
//
//  Created by Rigo Hernandez on 3/5/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "SearchPatientTests.h"
#import "SearchPatientViewController.h"
#import "PatientObject.h"
#import "UserObject.h"

@implementation SearchPatientTests

- (void)searchPatientTest {
    SearchPatientViewController *obj = [[SearchPatientViewController alloc] init];
    obj.patientNameField.text = @"Rigo";
    obj.mode = kTriageMode;
//    [obj searchByNameButton];
    
}

@end