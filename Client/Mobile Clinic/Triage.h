//
//  Triage.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/7/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FIUPatientRegistrationViewController.h"
@interface Triage : UIViewController{
    UIPopoverController* popover;

}
@property(nonatomic, strong)PatientObject* patient;
@property (weak, nonatomic) IBOutlet UITextView *PatientSummary;
@property (weak, nonatomic) IBOutlet UIImageView *patientPicture;
@property (weak, nonatomic) IBOutlet UILabel *patientName;
@property (weak, nonatomic) IBOutlet UISwitch *passportSwitch;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchPatientBtn;

- (IBAction)logout:(id)sender;
- (IBAction)CreateNewPatient:(id)sender;
- (IBAction)searchForPatients:(id)sender;
- (IBAction)EditPatientInfo:(id)sender;
@end
