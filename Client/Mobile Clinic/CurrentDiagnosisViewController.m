//
//  CurrentDiagnosisViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/22/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "CurrentDiagnosisViewController.h"

@interface CurrentDiagnosisViewController ()

@end

@implementation CurrentDiagnosisViewController

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
    _visitationData = [[VisitationObject alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {
    // Populate condition for doctor to see
    _conditionsTextbox.text = [_patientData objectForKey:CONDITION];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setConditionsTextbox:nil];
    [self setDiagnosisTextbox:nil];
    [self setSubmitButton:nil];
    [self setView:nil];
    [super viewDidUnload];
}

- (IBAction)submitButton:(id)sender {
    //set visitiation diag
    if (self.validateDiagnosis) {
        [_patientData setObject:_diagnosisTextbox.text forKey:OBSERVATION];
        [[NSNotificationCenter defaultCenter] postNotificationName:SAVE_VISITATION object:_patientData];
        
//        [_visitationData setObject:_diagnosisTextbox.text withAttribute:OBSERVATION];
//        [[NSNotificationCenter defaultCenter] postNotificationName:SAVE_VISITATION object:_visitationData];
//        handler(self,nil);
    }
}

- (BOOL)validateDiagnosis {
    BOOL inputIsValid = YES;
    NSString *errorMsg;
    
    // Check for missing input
    // Not checking to see if the name, family, or village strings contain numbers,
    // This can always be revised, but some names apparently have "!" to symbolize a click (now you learned something new!)
    if([_diagnosisTextbox.text isEqualToString:@""] || _diagnosisTextbox.text == nil) {
        errorMsg = @"Missing Diagnosis";
        inputIsValid = NO;
    }
    
    //display error message on invlaid input
    if(inputIsValid == NO){
        UIAlertView *validateDiagnosisAlert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [validateDiagnosisAlert show];
    }
    
    return inputIsValid;
}

// Hides keyboard when whitespace is pressed
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setScreenHandler:(ScreenHandler)myHandler {
    handler = myHandler;
}

@end
