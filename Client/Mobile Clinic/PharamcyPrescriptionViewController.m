//
//  PharamcyPrescriptionViewController.m
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/24/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "PharamcyPrescriptionViewController.h"

@interface PharamcyPrescriptionViewController ()

@end

@implementation PharamcyPrescriptionViewController

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
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTabletsTextField:nil];
    [self setTimeOfDayTextFields:nil];
    [self setDrugTextField:nil];
    [self setTimeOfDayButtons:nil];
    [self setDoctorsDiagnosis:nil];
    [super viewDidUnload];
}

- (IBAction)findDrugs:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:MOVE_TO_SEARCH_FOR_MEDICINE object:nil];
}

- (IBAction)newTimeOfDay:(id)sender {
    for(int i = 0; i < [_timeOfDayButtons count]; i++){
        if([[_timeOfDayButtons objectAtIndex:i] isEqual:sender])
            [((UIButton *)sender) setAlpha:1];
        else
            [((UIButton *)[_timeOfDayButtons objectAtIndex:i]) setAlpha:0.5];
    }
}

- (IBAction)savePrescription:(id)sender {
    // NEED LOGIC OF SAVING MEDICATION
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SAVE_PRESCRIPTION object:nil];
}

- (void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
}
@end
