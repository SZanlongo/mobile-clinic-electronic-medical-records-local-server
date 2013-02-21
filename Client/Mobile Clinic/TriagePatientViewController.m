//
//  TriagePatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "TriagePatientViewController.h"

@interface TriagePatientViewController ()

@end

@implementation TriagePatientViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _patientNameField.text = _patientData.patient.firstName;
    _familyNameField.text = _patientData.patient.familyName;
    _villageNameField.text = _patientData.patient.villageName;
    _patientSexField.text = [_patientData getSex:_patientData.patient.sex];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPatientNameField:nil];
    [self setFamilyNameField:nil];
    [self setVillageNameField:nil];
    [self setPatientAgeButton:nil];
    [self setPatientSexField:nil];
    [self setPatientWeightLabel:nil];
    [self setPatientBPLabel:nil];
    [super viewDidUnload];
}
@end
