//
//  PharamcyPrescriptionViewController.h
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/24/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationViewHandlerProtocol.h"
#import "PatientObject.h"
#import "PrescriptionObject.h"

@interface PharamcyPrescriptionViewController : UIViewController{
    ScreenHandler handler;
}

@property (strong, nonatomic) NSMutableDictionary * patientData;
@property (strong, nonatomic) PrescriptionObject * prescriptionData;

@property (weak, nonatomic) IBOutlet UITextView *doctorsDiagnosis;
@property (weak, nonatomic) IBOutlet UITextField *tabletsTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeOfDayTextFields;
@property (weak, nonatomic) IBOutlet UITextField *drugTextField;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *timeOfDayButtons;

- (IBAction)findDrugs:(id)sender;
- (IBAction)newTimeOfDay:(id)sender;
- (IBAction)savePrescription:(id)sender;

-(void)deactivateControllerFields;
- (void)setScreenHandler:(ScreenHandler)myHandler;

@end
