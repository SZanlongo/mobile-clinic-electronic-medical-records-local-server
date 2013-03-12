//
//  CurrentVisitViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationViewHandlerProtocol.h"


@interface CurrentVisitViewController : UIViewController {
    ScreenHandler handler;
    NSMutableDictionary *currentVisit;
}

@property (strong, nonatomic) NSMutableDictionary *patientData;
@property (strong, nonatomic) IBOutlet UITextField *patientWeightField;
@property (weak, nonatomic) IBOutlet UITextField *systolicField;
@property (weak, nonatomic) IBOutlet UITextField *diastolicField;
@property (strong, nonatomic) IBOutlet UITextView *conditionsTextbox;

- (IBAction)checkInButton:(id)sender;
- (IBAction)quickCheckOutButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *respirationField;
@property (weak, nonatomic) IBOutlet UITextField *heartField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *visitPriority;

- (void)setScreenHandler:(ScreenHandler)myHandler;

-(BOOL)validateCheckin;

@end
