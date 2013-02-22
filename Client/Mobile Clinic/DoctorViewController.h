//
//  DoctorViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/22/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPatientTableCell.h"
#import "StationViewHandlerProtocol.h"

@interface DoctorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    ScreenHandler handler;
}

@property (strong, nonatomic) SearchPatientViewController * viewController;
@property (strong, nonatomic) PatientObject * patientData;
@property (strong, nonatomic) SearchPatientViewController * control2;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)setScreenHandler:(ScreenHandler)myHandler;

@end