//
//  CurrentDiagnosisViewControllerTest.m
//  Mobile Clinic
//
//  Created by Rigo Hernandez on 3/19/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "MobileClinicFacade.h"
#import "DoctorPatientViewController.h"
#import "DoctorPrescriptionViewController.h"
#import "MedicineSearchViewController.h"

@interface CurrentDiagnosisViewControllerTest: GHAsyncTestCase

@end

NSMutableDictionary * patientData;
NSMutableDictionary * visitData;
DoctorPatientViewController * doctorView;

@implementation CurrentDiagnosisViewControllerTest

- (void)setUpClass {
    // Run at beginning of all tests in the class
    DoctorPatientViewController * newView = [self getViewControllerFromiPadStoryboardWithName:@"doctorPatientViewController"];
    [newView setPatientData:pDic];
    
    patientData = [[NSMutableDictionary alloc]init];
    visitData = [[NSMutableDictionary alloc]init];
    
    [patientData setObject:[NSDate date] forKey:DOB];
    [patientData setObject:"Hernandez" forKey:FAMILYNAME];
    [patientData setObject:@"Rigo" forKey:FIRSTNAME];
    [patientData setObject:@"admin" forKey:ISLOCKEDBY];
    [patientData setObject:YES forKey:ISOPEN];
    [patientData setObject:@"rigo.hernandez.1" forKey:PATIENTID];
    [patientData setObject:[NSNumber numberWithInt:1] forKey:SEX];
    [patientData setObject:@"Kendall" forKey:VILLAGE];
    
    [visitData setObject:"120/80" forKey:BLOODPRESSURE];
    [visitData setObject:@"This is a condition for the patient" forKey:CONDITION];
    [visitData setObject:"admin" forKey:DOCTORID];
    [visitData setObject:[NSDate date] forKey:DOCTORIN];
    [visitData setObject:@"70" forKey:HEARTRATE];
    [visitData setObject:@"admin" forKey:ISLOCKEDBY];
    [visitData setObject:YES forKey:ISOPEN];
    [visitData setObject:@"admin" forKey:NURSEID];
    [visitData setObject:[NSNumber numberWithInt:1] forKey:PRIORITY];
    [visitData setObject:@"30" forKey:RESPIRATION];
    [visitData setObject:@"rigo.hernandez.010113" forKey:VISITID];
    [visitData setObject:[NSNumber numberWithDouble:180.0] forKey:WEIGHT];
    
    [visitData setObject:patientData forKey:@"OPEN VISITS"];
    
    doctorView = [self getViewControllerFromiPadStoryboardWithName:@"doctorPatientViewController"];
    [newView setPatientData:visitData];
}

- (void)tearDownClass {
    // Run at end of all tests in the class
    patientData = nil;
    visitData = nil;
    doctorView = nil;
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}

- 

@end
