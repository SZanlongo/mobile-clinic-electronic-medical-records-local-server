//
//  PatientHistoryViewController.h
//  Mobile Clinic
//
//  Created by Rigo Hernandez on 2/23/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientObject.h"

@interface PatientHistoryViewController : UIViewController

@property (strong, nonatomic) PatientObject *patientData;

@property (weak, nonatomic) IBOutlet UILabel *patientDOBLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientBPLabel;
@property (weak, nonatomic) IBOutlet UITextView *patientConditionsTextView;
@property (weak, nonatomic) IBOutlet UITextView *patientMedicationTextView;

@end
