//
//  Triage.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/7/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "Triage.h"

@interface Triage ()

@end

@implementation Triage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Redisplay{
    //set picture
    [_patientPicture setImage:_patient.picture];
   
    NSString* text = [NSString stringWithFormat:@"%@ %@",_patient.firstName,_patient.familyName];
    // set first and lastname
    [_patientName setText:text];
    
    NSString* summary = [NSString stringWithFormat:@"Date of Birth: %@\n Age: %i \nSex: %@ \nVillage: %@\n",_patient.dob.convertNSDateToString, _patient.getAge,(_patient.sex==0)?@"Female":@"Male",_patient.village];
    [_PatientSummary setText:summary];
    
}

- (IBAction)logout:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:LOGOFF object:nil];
}

- (IBAction)CreateNewPatient:(id)sender {
    
    FIUPatientRegistrationViewController* vc = [self getViewControllerFromiPadStoryboardWithName:@"Registration"];
    
    [vc setScreenHandler:^(id object, NSError *error) {
        //Should check for when the error is true
        [popover dismissPopoverAnimated:YES];
        
        // if there was no error and there is an object
        // redisplay information
        if (object) {
            //Redisplay Method here
        }
    }];
   // when creating a new patient, it needs to be nil
    [vc setPatient:nil];
    
        [self setupView:vc ForPopoverByButton:sender];
}

- (IBAction)EditPatientInfo:(id)sender {
    if (_patient) {
        FIUPatientRegistrationViewController* vc = [self getViewControllerFromiPadStoryboardWithName:@"Registration"];
        
        [vc setScreenHandler:^(id object, NSError *error) {
            //Should check for when the error is true
            [popover dismissPopoverAnimated:YES];
            
            // if there was no error and there is an object
            // redisplay information
            if (object) {
                [self Redisplay]; //Redisplay Method here
            }
        }];
        
        [vc setPatient:_patient];
        [[vc SaveButton]setTitle:@"Save" forState:UIControlStateNormal];
        [self setupView:vc ForPopoverByButton:sender];
    }
}

- (IBAction)searchForPatients:(id)sender {
   
    FIUPatientRegistrationViewController* vc = [self getViewControllerFromiPadStoryboardWithName:@"SearchPatients"];
    [_searchPatientBtn setEnabled:NO];
    [vc setScreenHandler:^(id object, NSError *error) {
        //Should check for when the error is true
        [popover dismissPopoverAnimated:YES];
        [_searchPatientBtn setEnabled:YES];
        // if there was no error and there is an object
        // redisplay information
        if (object) {
            //Redisplay Method here
            _patient = object;
            [self Redisplay];
        }
    }];
    
    [self setupView:vc ForPopoverByButton:sender];
}

-(void)setupView:(UIViewController<UIPopoverControllerDelegate>*)vc ForPopoverByButton:(id)btn{
    
    
    popover = [[UIPopoverController alloc]initWithContentViewController:vc];
    
    [popover setDelegate:vc];
    
    if ([btn isKindOfClass:[UIButton class]]) {
        UIButton* button = btn;
        [popover presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        UIBarButtonItem* button = btn;
       [popover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES]; 
    }
}



- (void)viewDidUnload {
    [self setPatientSummary:nil];
    [self setPatientPicture:nil];
    [self setPatientName:nil];
    [self setPassportSwitch:nil];
    [self setSearchPatientBtn:nil];
    [super viewDidUnload];
}
@end
