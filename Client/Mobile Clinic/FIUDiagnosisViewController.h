//
//  FIUDiagnosisViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/10/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FIUDiagnosisViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *patientPicture;

@property (weak, nonatomic) IBOutlet UILabel *familyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *villageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientSexLabel;

@property (weak, nonatomic) IBOutlet UITextView *symptomsText;
@property (weak, nonatomic) IBOutlet UITextView *diagnosisText;
@property (weak, nonatomic) IBOutlet UITextView *treatmentsText;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
