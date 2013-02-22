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
#import "StationViewHandlerProtocol.h"

@interface RegisterPatientViewController : UIViewController{
    ScreenHandler handler;
    CameraFacade *facade;
    BOOL shouldDismiss;
}

@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UITextField *familyNameField;
@property (weak, nonatomic) IBOutlet UITextField *villageNameField;
@property (weak, nonatomic) IBOutlet UIButton *patientAgeField;
@property (weak, nonatomic) IBOutlet UIImageView *patientPhoto;
@property (weak, nonatomic) IBOutlet UISegmentedControl *patientSexSegment;

@property (strong, nonatomic) PatientObject *patient;

- (IBAction)patientPhotoButton:(id)sender;
- (IBAction)createPatient:(id)sender;

- (BOOL)validateRegistration;
- (IBAction)getAgeOfPatient:(id)sender;
- (IBAction)goBackToChangeStation:(id)sender;
-(void)setScreenHandler:(ScreenHandler)myHandler;
- (IBAction)cancelRegistrationClearScreenAndCreateNewPatient:(id)sender;

@end
