//
//  CurrentVisitViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationViewHandlerProtocol.h"
#import "PatientObject.h"
#import "VisitationObject.h"

@interface CurrentVisitViewController : UIViewController {
    ScreenHandler handler;
    VisitationObject *currentVisit;
}

@property (strong, nonatomic) PatientObject *patientData;
@property (strong, nonatomic) IBOutlet UITextField *patientWeightField;
@property (strong, nonatomic) IBOutlet UITextField *patientBPField;
@property (strong, nonatomic) IBOutlet UITextView *conditionsTextbox;

- (IBAction)checkInButton:(id)sender;
- (IBAction)quickCheckOutButton:(id)sender;

- (void)setScreenHandler:(ScreenHandler)myHandler;

-(BOOL)validateCheckin;

@end
