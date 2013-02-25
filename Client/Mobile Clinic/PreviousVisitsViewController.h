//
//  PreviousVisitsViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientHistoryTableCell.h"
#import "PatientObject.h"
#import "VisitationObject.h"

@interface PreviousVisitsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PatientObject * patientData;
@property (nonatomic, strong) Visitation * visitData;
@property (nonatomic, strong) NSArray * patientHistoryArray;

@property (weak, nonatomic) IBOutlet UITableView *patientHistoryTableView;

@end
