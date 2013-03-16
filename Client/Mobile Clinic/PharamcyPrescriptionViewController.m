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
    [self setMedicationNotes:nil];
    [super viewDidUnload];
}

- (IBAction)newTimeOfDay:(id)sender {
    
    for(int i = 0; i < [_timeOfDayButtons count]; i++) {
        if([[_timeOfDayButtons objectAtIndex:i] isEqual:sender]) {
            [((UIButton *)sender) setAlpha:1];
            _timeOfDayTextFields.text = [self getTimeOfDay:i];
        }else
            [((UIButton *)[_timeOfDayButtons objectAtIndex:i]) setAlpha:0.35];
    }
}

- (NSString *)getTimeOfDay:(int)num {
    switch (num)
    {
        case 0:
            return @"Morning";
            break;
        case 1:
            return @"Midday";
            break;
        case 2:
            return @"Mid-Afternoon";
            break;
        case 3:
            return @"Evening";
            break;
        default:
            return @"";
            break;
    }
}

- (IBAction)findDrugs:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:MOVE_TO_SEARCH_FOR_MEDICINE object:nil];
}

// Change name of button (Send to Pharmacy / Checkout)
- (IBAction)savePrescription:(id)sender{
    if([self validatePrescription]) {
        // Save prescription fields
        [_prescriptionData setObject:_medicationNotes forKey:INSTRUCTIONS];
        [_prescriptionData setObject:_tabletsTextField.text forKey:TABLEPERDAY];
        [_prescriptionData setObject:_timeOfDayTextFields.text forKey:TIMEOFDAY];
//        [_prescriptionData setObject:????? forKey:PRESCRIBETIME];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SAVE_PRESCRIPTION object:_prescriptionData];
    }
}

// Hides keyboard when whitespace is pressed
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)deactivateControllerFields {
    [_medicationNotes setEditable:NO];
    [_tabletsTextField setEnabled:NO];
    [_timeOfDayTextFields setEnabled:NO];
    
    
    for(int i = 0; i <[_timeOfDayButtons count]; i++){
        [((UIButton *)[_timeOfDayButtons objectAtIndex:i]) setEnabled:NO];
    }
}

- (BOOL)validatePrescription {
    BOOL inputIsValid = YES;
    NSString *errorMsg;
    
    if([_drugTextField.text isEqualToString:@""] || _drugTextField.text == nil) {
        errorMsg = @"Missing medication";
        inputIsValid = NO;
    } else if([_tabletsTextField.text isEqualToString:@""] || _tabletsTextField.text == nil) {
        errorMsg = @"Missing number of tablets per day";
        inputIsValid = NO;
    } else if([_timeOfDayTextFields.text isEqualToString:@""] || _timeOfDayTextFields.text == nil) {
        errorMsg = @"Choose time of day";
        inputIsValid = NO;
    }
    
    // Display error message on invalid input
    if(inputIsValid == NO){
        UIAlertView *validateDiagnosisAlert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [validateDiagnosisAlert show];
    }
    
    return inputIsValid;
}

- (void)setScreenHandler:(ScreenHandler)myHandler {
    handler = myHandler;
}

@end
