//
//  DoctorPatientViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/22/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientHistoryTableCell.h"
#import "PatientResultTableCell.h"
#import "PatientObject.h"

@interface DoctorPatientViewController : UIViewController

//Patient Info Labels
@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UITextField *familyNameField;
@property (weak, nonatomic) IBOutlet UITextField *villageNameField;
@property (weak, nonatomic) IBOutlet UIButton *patientAgeButton;
@property (weak, nonatomic) IBOutlet UITextField *patientSexField;

//Vitals Labels
@property (weak, nonatomic) IBOutlet UILabel *patientWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientBPLabel;

@property (weak, nonatomic) PatientObject *patientData;

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
-(IBAction) segmentedControlIndexChanged;

@end
