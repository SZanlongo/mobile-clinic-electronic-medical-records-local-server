//
//  DoctorPatientViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/22/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentDiagnosisTableCell.h"
#import "PreviousVisitsTableCell.h"

@interface DoctorPatientViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    ScreenHandler handler;
}

@property (strong, nonatomic) PatientObject *  patientData;
@property (strong, nonatomic) CurrentDiagnosisViewController * control1;
@property (strong, nonatomic) PreviousVisitsViewController * control2;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIToolbar * toolBar;
@property (nonatomic, retain) IBOutlet UISegmentedControl * segmentedControl;

@end