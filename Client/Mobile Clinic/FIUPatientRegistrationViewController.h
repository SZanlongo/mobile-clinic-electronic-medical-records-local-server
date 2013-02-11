//
//  FIUPatientRegistrationViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientObject.h"
#import "CameraFacade.h"

@interface FIUPatientRegistrationViewController : UITableViewController<UIPopoverControllerDelegate> {
    UIImagePickerController *pCtrl;
    ScreenHandler handler;
    CameraFacade *facade;
    BOOL shouldDismiss;
}
@property (strong, nonatomic) IBOutlet UITextField *familyNameField;
@property (strong, nonatomic) IBOutlet UITextField *patientNameField;
@property (strong, nonatomic) IBOutlet UITextField *villageNameField;
@property (strong, nonatomic) IBOutlet UITextField *patientWeightField;
@property (strong, nonatomic) IBOutlet UIButton *patientAgeField;
@property (strong, nonatomic) IBOutlet UIImageView *patientPictureImage;
@property (weak, nonatomic) IBOutlet UIButton *SaveButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *patientSexSegment;

@property (strong, nonatomic) PatientObject *patient;

- (IBAction)patientPictureButton:(id)sender;

- (IBAction)registerPatientButton:(id)sender;

- (BOOL)validateRegistration;
- (IBAction)cancelRegistration:(id)sender;

- (void)setScreenHandler:(ScreenHandler)setHandler;

@end
