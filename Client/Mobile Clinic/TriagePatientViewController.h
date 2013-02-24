//
//  TriagePatientViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentVisitTableCell.h"
#import "PreviousVisitTableCell.h"
//#import "StationViewHandlerProtocol.h"

#import "PatientObject.h"           // MAY NOT NEED THIS (RIGO).  NEED TO TEST COMMENTED OUT.

@interface TriagePatientViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
//{
//    ScreenHandler handler;
//}

@property (strong, nonatomic) PatientObject *patientData;
@property (strong, nonatomic) CurrentVisitViewController *currentVisitControl;
@property (strong, nonatomic) PreviousVisitsViewController *previousVisitControl;

// Patient Info Labels
@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UITextField *familyNameField;
@property (weak, nonatomic) IBOutlet UITextField *villageNameField;
@property (weak, nonatomic) IBOutlet UIButton *patientAgeButton;
@property (weak, nonatomic) IBOutlet UITextField *patientSexField;

// Vitals Labels :: WE MAY END UP DELETING THESE FOR TRIAGE
@property (weak, nonatomic) IBOutlet UILabel *patientWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientBPLabel;

// Objects on View
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

//- (void)setScreenHandler:(ScreenHandler)myHandler;

@end

