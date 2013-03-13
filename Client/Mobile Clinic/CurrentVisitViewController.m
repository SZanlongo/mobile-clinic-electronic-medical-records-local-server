//
//  CurrentVisitViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "CurrentVisitViewController.h"
#import "MobileClinicFacade.h"
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
    currentVisit = [[NSMutableDictionary alloc]initWithCapacity:10];
    [currentVisit setValue:[NSDate date] forKey:TRIAGEIN];
    
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
    [self setConditionsTextbox:nil];
    [self setVisitPriority:nil];
    [self setRespirationField:nil];
    [self setHeartField:nil];
    [self setSystolicField:nil];
    [self setDiastolicField:nil];
    [super viewDidUnload];
}

// Creates a visit for the patient and checks them in
- (IBAction)checkInButton:(id)sender {
    [self setVisitData];
}

// Allows nurse to check-out a patient without going thru doctor/pharmacy
- (IBAction)quickCheckOutButton:(id)sender {
    [self setVisitData];
}

- (void)setVisitData {
    if (self.validateCheckin) {
        MobileClinicFacade* mobileFacade = [[MobileClinicFacade alloc]init];
        
        [currentVisit setValue:[NSNumber numberWithInt:[_patientWeightField.text intValue]] forKey:WEIGHT];
        [currentVisit setValue:[NSString stringWithFormat: @"%@/%@", _systolicField.text, _diastolicField.text] forKey:BLOODPRESSURE];
//        [currentVisit setValue:_heartField.text forKey:(HEARTRATE)];
//        [currentVisit setValue:_respirationField.text forKey:RESPIRATION];
        [currentVisit setValue:_conditionsTextbox.text forKey:CONDITION];
        [currentVisit setValue:[NSDate date] forKey:TRIAGEOUT];
        [currentVisit setValue:mobileFacade.GetCurrentUsername forKey:NURSEID];
        [currentVisit setValue:[NSNumber numberWithInteger:_visitPriority.selectedSegmentIndex] forKey:PRIORITY];
        
        [mobileFacade updateCurrentPatient:_patientData AndShouldLock:NO onCompletion:^(NSDictionary *object, NSError *error) {
            [mobileFacade addNewVisit:currentVisit ForCurrentPatient:_patientData onCompletion:^(NSDictionary *object, NSError *error) {
                if (!object) {
                    [FIUAppDelegate getNotificationWithColor:AJNotificationTypeOrange Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription inView:self.view];
                }else{
                    handler(object,error);
                }
            }];
            
        }];
    }
}

-(BOOL)validateCheckin{
    BOOL inputIsValid = YES;
    NSString *errorMsg;
    
    NSString * correct = @"\\b([0-9%_.+\\-]+)\\b";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", correct];
    
    if([_patientWeightField.text isEqualToString:@""] || _patientWeightField.text == nil) {
        errorMsg = @"Missing Weight";
        inputIsValid = NO;
    } else if([_systolicField.text isEqualToString:@""] || _systolicField.text == nil) {
        errorMsg = @"Missing Blood Pressure";
        inputIsValid = NO;
    } else if([_diastolicField.text isEqualToString:@""] || _diastolicField.text == nil) {
        errorMsg = @"Missing Blood Pressure";
        inputIsValid = NO;
    } else if([_conditionsTextbox.text isEqualToString:@""] || _conditionsTextbox.text == nil){
        errorMsg = @"Missing Conditions";
        inputIsValid = NO;
    } else if (![predicate evaluateWithObject:_patientWeightField.text]){
        errorMsg = @"Weight has Letters";
        inputIsValid = NO;
    } else if (![predicate evaluateWithObject:_systolicField.text]){
        errorMsg = @"Blood Pressure has Letters";
        inputIsValid = NO;
    } else if (![predicate evaluateWithObject:_diastolicField.text]){
        errorMsg = @"Blood Pressure has Letters";
        inputIsValid = NO;
    } else if ([_heartField.text isEqualToString:@""] || _heartField.text == nil) {
        errorMsg = @"Missing Heart Rate";
        inputIsValid = NO;
    } else if (![predicate evaluateWithObject:_heartField.text]) {
        errorMsg = @"Heart Rate has Letters";
        inputIsValid = NO;
    } else if ([_respirationField.text isEqualToString:@""] || _respirationField.text == nil) {
        errorMsg = @"Missing Respiration";
        inputIsValid = NO;
    } else if (![predicate evaluateWithObject:_respirationField.text]) {
        errorMsg = @"Respiration has Letters";
        inputIsValid = NO;
    }
    
    //display error message on invlaid input
    if(inputIsValid == NO){
        UIAlertView *validateCheckinAlert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [validateCheckinAlert show];
    }
    
    return inputIsValid;
}

-(void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
}

@end
