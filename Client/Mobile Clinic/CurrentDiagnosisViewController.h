//
//  CurrentDiagnosisViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/22/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationViewHandlerProtocol.h"
#import "PatientObject.h"
#import "VisitationObject.h"

@interface CurrentDiagnosisViewController : UIViewController {
    ScreenHandler handler;
}

@property (weak, nonatomic) IBOutlet UITextView *diagnosisTextbox;
@property (strong, nonatomic) PatientObject * patientData;
@property (strong, nonatomic) VisitationObject * visitationData;
- (IBAction)submitButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (void)setScreenHandler:(ScreenHandler)myHandler;

@end
