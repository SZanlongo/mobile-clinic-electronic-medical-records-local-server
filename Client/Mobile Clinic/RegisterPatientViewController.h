//
//  RegisterPatientViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientObject.h"
#import "CameraFacade.h"
#import "ScreenNavigationDelegate.h"

@interface RegisterPatientViewController : UIViewController{
    ScreenHandler handler;
    CameraFacade *facade;
    BOOL shouldDismiss;
}

@property (strong, nonatomic) IBOutlet UITextField *patientNameField;
@property (strong, nonatomic) IBOutlet UITextField *familyNameField;
@property (strong, nonatomic) IBOutlet UITextField *villageNameField;
@property (strong, nonatomic) IBOutlet UIDatePicker *dobDatePicker;
// ADD AGE FIELD HERE //
@property (weak, nonatomic) IBOutlet UIImageView *patientPhoto;
@property (weak, nonatomic) IBOutlet UISegmentedControl *patientSexSegment;
@property (weak, nonatomic) IBOutlet UIButton *createPatientButton;

@property (strong, nonatomic) PatientObject *patient;

- (IBAction)patientPhotoButton:(id)sender;
- (PatientObject *)createPatient;

- (BOOL)validateRegistration;
- (void)setScreenHandler:(ScreenHandler)myHandler;

@end
