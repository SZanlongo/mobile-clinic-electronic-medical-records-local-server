//
//  PatientHistoryViewController.m
//  Mobile Clinic
//
//  Created by Rigo Hernandez on 2/23/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "PatientHistoryViewController.h"

@interface PatientHistoryViewController ()

@end

@implementation PatientHistoryViewController

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
  
    // Populate patient data
//    _patientDOBLabel.text = _patientData.patient.age.description;
//    _patientAgeLabel.text = [NSString stringWithFormat:@"%d", _patientData.patient.age.getNumberOfYearsElapseFromDate];
//    _patientWeightLabel.text =
//    _patientBPLabel.text =
//    [_patientConditionsTextView setText:<#(NSString *)#>];
//    [_patientMedicationTextView setText:<#(NSString *)#>];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPatientDOBLabel:nil];
    [self setPatientAgeLabel:nil];
    [self setPatientWeightLabel:nil];
    [self setPatientBPLabel:nil];
    [self setPatientConditionsTextView:nil];
    [self setPatientMedicationTextView:nil];
    [super viewDidUnload];
}
@end
