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
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assignPatientData:) name:CREATE_NEW_DIAGNOSIS object:_patientData];
    
    // Instantiate visitation object
    
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
    if (self.validateCheckin) {
        // Assigning vitals & condition
        currentVisit = [[VisitationObject alloc] initWithNewVisit];
        
        [currentVisit setObject:[NSNumber numberWithInt:[_patientWeightField.text intValue]] withAttribute:WEIGHT];
        [currentVisit setObject:_patientBPField.text withAttribute:BLOODPRESSURE];
        [currentVisit setObject:_conditionsTextbox.text withAttribute:CONDITION];
        [currentVisit SetTriageCheckinTime];
        [currentVisit associateUserToNurseId];
        // Adding visitation to patient object
        [_patientData addVisitToCurrentPatient:currentVisit];
        
        [_patientData UpdatePatientObject:^(id<BaseObjectProtocol> data, NSError *error) {
            if (error) {
                [FIUAppDelegate getNotificationWithColor:AJNotificationTypeOrange Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription inView:self.view];
            }
            handler(self,nil);
        }];
    }    
}

// Allows nurse to check-out a patient without going thru doctor/pharmacy
- (IBAction)quickCheckOutButton:(id)sender {
    if (self.validateCheckin) {
        
    }
}

-(BOOL)validateCheckin{
    BOOL inputIsValid = YES;
    NSString *errorMsg;
    NSString * correct = @"\\b([0-9%_.+\\-]+)\\b";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", correct];
    
    if([_patientWeightField.text isEqualToString:@""] || _patientWeightField.text == nil) {
        errorMsg = @"Missing Patient Weight";
        inputIsValid = NO;
    } else if([_patientBPField.text isEqualToString:@""] || _patientBPField.text == nil) {
        errorMsg = @"Missing Blood Pressure";
        inputIsValid = NO;
    } else if([_conditionsTextbox.text isEqualToString:@""] || _conditionsTextbox.text == nil){
        errorMsg = @"Missing Patient Conditions";
        inputIsValid = NO;
    } else if (![predicate evaluateWithObject:_patientWeightField.text]){
        errorMsg = @"Patient Weight has Letters";
        inputIsValid = NO;
    } else if (![predicate evaluateWithObject:_patientBPField.text]){
        errorMsg = @"Patient Blood Pressure has Letters";
        inputIsValid = NO;
    }
    
    //display error message on invlaid input
    if(inputIsValid == NO){
        UIAlertView *validateRegistrationAlert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [validateRegistrationAlert show];
    }
    
    return inputIsValid;
}

-(void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
}

@end
