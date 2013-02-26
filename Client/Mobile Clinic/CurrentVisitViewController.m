//
//  CurrentVisitViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "CurrentVisitViewController.h"

@interface CurrentVisitViewController ()

@end

@implementation CurrentVisitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Pass in the patient's data thru notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assignPatientData:) name:CREATE_NEW_DIAGNOSIS object:_patientData];
    
    // Instantiate visitation object
    _currentVisit = [[VisitationObject alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
}

// Assigns patientData from Notification
- (void)assignPatientData:(NSNotification *)note {
    _patientData = note.object;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPatientWeightField:nil];
    [self setPatientBPField:nil];
    [self setConditionsTextbox:nil];
    [super viewDidUnload];
}

// Creates a visit for the patient and checks them in
- (IBAction)checkInButton:(id)sender {
    // Assigning vitals & condition
    _currentVisit.visit.weight = [NSNumber numberWithInt:[_patientWeightField.text intValue]];
    _currentVisit.visit.bloodPressure = _patientWeightField.text;
    _currentVisit.visit.complaint = _conditionsTextbox.text;
    
    // Adding visitation to patient object
    [_patientData.patient addVisitObject:_currentVisit.visit];
    
    // NEED LOGIC TO RESET EVERYTHING AND START A NEW PATIENT
}

// Allows nurse to check-out a patient without going thru doctor/pharmacy
- (IBAction)quickCheckOutButton:(id)sender {
    
}

-(void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
}

@end
