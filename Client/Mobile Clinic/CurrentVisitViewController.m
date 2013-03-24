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

@property CGPoint originalCenter;

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
    self.conditionsTextbox.delegate = self;
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
    [self setVisitData:NO];
}

// Allows nurse to check-out a patient without going thru doctor/pharmacy
- (IBAction)quickCheckOutButton:(id)sender {
    [self setVisitData:YES];
}

- (void)setVisitData:(BOOL)type {
    if (self.validateCheckin) {
        MobileClinicFacade* mobileFacade = [[MobileClinicFacade alloc]init];
        
        [currentVisit setValue:[NSNumber numberWithInt:[_patientWeightField.text intValue]] forKey:WEIGHT];
        [currentVisit setValue:[NSString stringWithFormat: @"%@/%@", _systolicField.text, _diastolicField.text] forKey:BLOODPRESSURE];
        [currentVisit setValue:_heartField.text forKey:HEARTRATE];
        [currentVisit setValue:_respirationField.text forKey:RESPIRATION];
        [currentVisit setValue:_conditionsTextbox.text forKey:CONDITION];
        [currentVisit setValue:[NSDate date] forKey:TRIAGEOUT];
        [currentVisit setValue:mobileFacade.GetCurrentUsername forKey:NURSEID];
        [currentVisit setValue:[NSNumber numberWithInteger:_visitPriority.selectedSegmentIndex] forKey:PRIORITY];
        
        [mobileFacade addNewVisit:currentVisit ForCurrentPatient:_patientData shouldCheckOut:type onCompletion:^(NSDictionary *object, NSError *error) {
                if (!object) {
                    [FIUAppDelegate getNotificationWithColor:AJNotificationTypeOrange Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription inView:self.view];
                }else{
                    handler(object,error);
                }
            }];
    }
}

// Hides keyboard when whitespace is pressed
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextField Delegate Methods

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView == self.conditionsTextbox) {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.center = CGPointMake(self.view.center.x + 130, self.view.center.y);
            
            //move the patient weight stuff
            CGRect weightFrame = self.patientWeightField.frame;
            weightFrame.origin.y += 60;
            weightFrame.origin.x -= 110;
            weightFrame.size.width -= 30;
            self.patientWeightField.frame = weightFrame;
            
            CGRect weightLabelFrame = self.patientWeightLabel.frame;
            weightLabelFrame.origin.y += 60;
            weightLabelFrame.origin.x -= 100;
            self.patientWeightLabel.frame = weightLabelFrame;
            
            CGRect weightLabelMeasurement = self.patientWeightMeasurementLabel.frame;
            weightLabelMeasurement.origin.y += 60;
            weightLabelMeasurement.origin.x -= 140;
            self.patientWeightMeasurementLabel.frame = weightLabelMeasurement;
            
            //move patient bp stuff
            CGRect bloodPressureFrame = self.bloodPressureLabel.frame;
            bloodPressureFrame.origin.y += 60;
            bloodPressureFrame.origin.x -= 80;
            self.bloodPressureLabel.frame = bloodPressureFrame;
            
            CGRect bloodPressureDividerFrame = self.bloodPressureDivider.frame;
            bloodPressureDividerFrame.origin.y += 60;
            bloodPressureDividerFrame.origin.x -= 95;
            self.bloodPressureDivider.frame = bloodPressureDividerFrame;
            
            CGRect bloodPressureMeasurementFrame = self.bloodPressureMeasurementLabel.frame;
            bloodPressureMeasurementFrame.origin.y += 60;
            bloodPressureMeasurementFrame.origin.x -= 110;
            self.bloodPressureMeasurementLabel.frame = bloodPressureMeasurementFrame;
            
            CGRect systolicField = self.systolicField.frame;
            systolicField.origin.y += 65;
            systolicField.origin.x -= 80;
            systolicField.size.width -= 15;
            self.systolicField.frame = systolicField;
            
            CGRect diastolicField = self.diastolicField.frame;
            diastolicField.origin.y += 65;
            diastolicField.origin.x -= 95;
            diastolicField.size.width -= 15;
            self.diastolicField.frame = diastolicField;

            //move heart field
            CGRect heartFrame = self.heartField.frame;
            heartFrame.origin.y += 22;
            heartFrame.origin.x += 50;
            heartFrame.size.width -= 30;
            self.heartField.frame = heartFrame;
            
            CGRect heartLabelFrame = self.heartFieldLabel.frame;
            heartLabelFrame.origin.y += 22;
            heartLabelFrame.origin.x += 50;
            self.heartFieldLabel.frame = heartLabelFrame;
            
            CGRect heartMeasurementFrame = self.heartMeasurementLabel.frame;
            heartMeasurementFrame.origin.y += 22;
            heartMeasurementFrame.origin.x += 20;
            self.heartMeasurementLabel.frame = heartMeasurementFrame;
            
            
            //move respiration stuff
            CGRect respirationLabelFrame = self.respirationLabel.frame;
            respirationLabelFrame.origin.y += 22;
            respirationLabelFrame.origin.x += 165;
            self.respirationLabel.frame = respirationLabelFrame;
            
            CGRect respirationMeasurementFrame = self.respirationMeasurementLabel.frame;
            respirationMeasurementFrame.origin.y += 22;
            respirationMeasurementFrame.origin.x += 90;
            self.respirationMeasurementLabel.frame = respirationMeasurementFrame;
            
            
            CGRect respirationFrame = self.respirationField.frame;
            respirationFrame.origin.y += 22;
            respirationFrame.origin.x += 155;
            respirationFrame.size.width -= 60;
            self.respirationField.frame = respirationFrame;
        }];
        
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.conditionsTextbox) {
        [UIView animateWithDuration:.3 animations:^{
            
            self.view.center = CGPointMake(self.view.center.x - 132, self.view.center.y);
            
            //move the patient weight stuff
            CGRect weightFrame = self.patientWeightField.frame;
            weightFrame.origin.y -= 60;
            weightFrame.origin.x += 110;
            weightFrame.size.width += 30;
            self.patientWeightField.frame = weightFrame;
            
            CGRect weightLabelFrame = self.patientWeightLabel.frame;
            weightLabelFrame.origin.y -= 60;
            weightLabelFrame.origin.x += 100;
            self.patientWeightLabel.frame = weightLabelFrame;
            
            CGRect weightLabelMeasurement = self.patientWeightMeasurementLabel.frame;
            weightLabelMeasurement.origin.y -= 60;
            weightLabelMeasurement.origin.x += 140;
            self.patientWeightMeasurementLabel.frame = weightLabelMeasurement;
            
            //move patient bp stuff
            CGRect bloodPressureFrame = self.bloodPressureLabel.frame;
            bloodPressureFrame.origin.y -= 60;
            bloodPressureFrame.origin.x += 80;
            self.bloodPressureLabel.frame = bloodPressureFrame;
            
            CGRect bloodPressureDividerFrame = self.bloodPressureDivider.frame;
            bloodPressureDividerFrame.origin.y -= 60;
            bloodPressureDividerFrame.origin.x += 95;
            self.bloodPressureDivider.frame = bloodPressureDividerFrame;
            
            CGRect bloodPressureMeasurementFrame = self.bloodPressureMeasurementLabel.frame;
            bloodPressureMeasurementFrame.origin.y -= 60;
            bloodPressureMeasurementFrame.origin.x += 110;
            self.bloodPressureMeasurementLabel.frame = bloodPressureMeasurementFrame;
            
            CGRect systolicField = self.systolicField.frame;
            systolicField.origin.y -= 65;
            systolicField.origin.x += 80;
            systolicField.size.width += 15;
            self.systolicField.frame = systolicField;
            
            CGRect diastolicField = self.diastolicField.frame;
            diastolicField.origin.y -= 65;
            diastolicField.origin.x += 95;
            diastolicField.size.width += 15;
            self.diastolicField.frame = diastolicField;
            
            //move heart field
            CGRect heartFrame = self.heartField.frame;
            heartFrame.origin.y -= 22;
            heartFrame.origin.x -= 50;
            heartFrame.size.width += 30;
            self.heartField.frame = heartFrame;
            
            CGRect heartLabelFrame = self.heartFieldLabel.frame;
            heartLabelFrame.origin.y -= 22;
            heartLabelFrame.origin.x -= 50;
            self.heartFieldLabel.frame = heartLabelFrame;
            
            CGRect heartMeasurementFrame = self.heartMeasurementLabel.frame;
            heartMeasurementFrame.origin.y -= 22;
            heartMeasurementFrame.origin.x -= 20;
            self.heartMeasurementLabel.frame = heartMeasurementFrame;
            
            
            //move respiration stuff
            CGRect respirationLabelFrame = self.respirationLabel.frame;
            respirationLabelFrame.origin.y -= 22;
            respirationLabelFrame.origin.x -= 165;
            self.respirationLabel.frame = respirationLabelFrame;
            
            CGRect respirationMeasurementFrame = self.respirationMeasurementLabel.frame;
            respirationMeasurementFrame.origin.y -= 22;
            respirationMeasurementFrame.origin.x -= 90;
            self.respirationMeasurementLabel.frame = respirationMeasurementFrame;
            
            
            CGRect respirationFrame = self.respirationField.frame;
            respirationFrame.origin.y -= 22;
            respirationFrame.origin.x -= 155;
            respirationFrame.size.width += 60;
            self.respirationField.frame = respirationFrame;
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
