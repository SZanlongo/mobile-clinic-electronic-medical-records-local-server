//
//  PharmacyPatientViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/24/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientObject.h"

@interface PharmacyPatientViewController : UIViewController

@property (strong, nonatomic) PatientObject * patientData;
@property (weak, nonatomic) IBOutlet UITextField *patientName;
@property (weak, nonatomic) IBOutlet UITextField *familyName;
@property (weak, nonatomic) IBOutlet UITextField *villageName;
@property (weak, nonatomic) IBOutlet UIButton *patientAge;
@property (weak, nonatomic) IBOutlet UITextField *patientSex;

@property (weak, nonatomic) IBOutlet UIScrollView *patientDiagnosis;

@property (weak, nonatomic) IBOutlet UITextView *patientPrescription;
- (IBAction)submitPrescription:(id)sender;

@end