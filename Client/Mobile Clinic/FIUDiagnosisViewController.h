//
//  FIUDiagnosisViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/10/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FIUPatientRegistrationViewController.h"

@interface FIUDiagnosisViewController : UIViewController {UIPopoverController* popover;}

@property (weak, nonatomic) IBOutlet UIImageView *patientPicture;

@property(nonatomic, strong)PatientObject* patient;

@property (weak, nonatomic) IBOutlet UILabel *familyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *villageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientSexLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;

@property (weak, nonatomic) IBOutlet UITextView *diagnosisText;

- (IBAction)checkoutButton:(id)sender;
- (IBAction)submitButton:(id)sender;
- (IBAction)searchForPatients:(id)sender;

@end
