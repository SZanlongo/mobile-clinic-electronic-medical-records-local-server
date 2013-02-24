//
//  TriageViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterPatientTableCell.h"
#import "SearchPatientTableCell.h"
#import "StationViewHandlerProtocol.h"

@interface TriageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    ScreenHandler handler;
}

@property (strong, nonatomic) SearchPatientViewController * viewController;
@property (strong, nonatomic) PatientObject * patientData;
@property (strong, nonatomic) RegisterPatientViewController * control1;
@property (strong, nonatomic) SearchPatientViewController * control2;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

-(void)setScreenHandler:(ScreenHandler)myHandler;

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

@end