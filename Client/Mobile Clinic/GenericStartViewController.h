//
//  GenericStartViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 3/6/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterPatientTableCell.h"
#import "SearchPatientTableCell.h"
#import "StationViewHandlerProtocol.h"
//need to import patient queue table cell when its complete

@interface GenericStartViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    ScreenHandler handler;
}

//patient data
@property (strong, nonatomic) NSMutableDictionary * patientData;

//station chosen
@property (strong, nonatomic) NSNumber * stationChosen;

//different cell view controllers
@property (strong, nonatomic) RegisterPatientViewController * registerControl;
@property (strong, nonatomic) SearchPatientViewController * searchControl;

//gui elements
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

//methods
- (void)setScreenHandler:(ScreenHandler)myHandler;

@end
