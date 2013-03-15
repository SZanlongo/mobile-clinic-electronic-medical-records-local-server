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

- (void)viewWillAppear:(BOOL)animated {
//    // Populate condition for doctor to see

//    NSArray * arr = [[NSArray alloc] init];
//    arr = [_patientData getAllVisitsForCurrentPatient];
//    VisitationObject * tempVisit = [arr objectAtIndex:(arr.count - 1)];
//
//    if (arr.count > 0) {
//        _conditionsTextbox.text = [tempVisit getObjectForAttribute:CONDITION];
//    }
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
    [self setMedicationNotes:nil];
    [super viewDidUnload];
}

- (void)deactivateControllerFields {
    [_medicationNotes setEditable:NO];
    [_tabletsTextField setEnabled:NO];
    [_timeOfDayTextFields setEnabled:NO];
    
    for(int i = 0; i <[_timeOfDayButtons count]; i++){
        [((UIButton *)[_timeOfDayButtons objectAtIndex:i]) setEnabled:NO];
    }
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

// Change name of button (Send to Pharmacy / Checkout)
- (IBAction)savePrescription:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:SAVE_PRESCRIPTION object:nil];
}

// Hides keyboard when whitespace is pressed
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setScreenHandler:(ScreenHandler)myHandler {
    handler = myHandler;
}
@end
