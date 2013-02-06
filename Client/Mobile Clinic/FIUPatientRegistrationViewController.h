//
//  FIUPatientRegistrationViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FIUAppDelegate.h"

@interface FIUPatientRegistrationViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImagePickerController *pCtrl;
    FIUAppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UITextField *familyNameField;
@property (strong, nonatomic) IBOutlet UITextField *patientNameField;
@property (strong, nonatomic) IBOutlet UITextField *villageNameField;
@property (strong, nonatomic) IBOutlet UITextField *patientWeightField;
@property (strong, nonatomic) IBOutlet UITextField *patientAgeField;
@property (strong, nonatomic) IBOutlet UIImageView *patientPictureImage;

- (IBAction)patientSexSegment:(id)sender;
- (IBAction)patientPictureButton:(id)sender;
- (IBAction)giveMedicineButton:(id)sender;
- (IBAction)registerPatientButton:(id)sender;
- (BOOL)validateRegistration;
@end
