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

@interface PharamcyPrescriptionViewController : UIViewController{
    ScreenHandler handler;
}

@property (strong, nonatomic) PatientObject * patientData;
@property (weak, nonatomic) IBOutlet UITextField *tabletsTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeOfDayTextFields;
@property (weak, nonatomic) IBOutlet UITextField *drugTextField;
- (IBAction)findDrugs:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *timeOfDayButtons;
- (IBAction)newTimeOfDay:(id)sender;
- (IBAction)savePrescription:(id)sender;
- (void)setScreenHandler:(ScreenHandler)myHandler;

@end
