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
    [_patientPicture setImage:_patient.getPhoto];
   
    NSString* text = [NSString stringWithFormat:@"%@ %@",_patient.patient.firstName,_patient.patient.familyName];
    // set first and lastname
    [_patientName setText:text];
    
    NSString* summary = [NSString stringWithFormat:@"Date of Birth: %@\n Age: %i \nSex: %@ \nVillage: %@\n",_patient.patient.age.convertNSDateToString, _patient.getAge,(_patient.patient.sex==0)?@"Female":@"Male",_patient.patient.villageName];
    [_PatientSummary setText:summary];
    
}

- (IBAction)logout:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:LOGOFF object:nil];
}

- (IBAction)CreateNewPatient:(id)sender {
    
    UINavigationController* vc = [self getViewControllerFromiPadStoryboardWithName:@"Registration"];
    FIUPatientRegistrationViewController* fiu = vc.viewControllers.lastObject;
    [fiu setScreenHandler:^(id object, NSError *error) {
        //Should check for when the error is true
        [popover dismissPopoverAnimated:YES];
        
        // if there was no error and there is an object

    }];
   // when creating a new patient, it needs to be nil
    [fiu setPatient:nil];
    
        [self setupView:fiu ForPopoverByButton:sender hasController:vc];
}

- (IBAction)EditPatientInfo:(id)sender {
    if (_patient) {
        UINavigationController* vc = [self getViewControllerFromiPadStoryboardWithName:@"Registration"];
        FIUPatientRegistrationViewController* fiu = vc.viewControllers.lastObject;
        
        [fiu setScreenHandler:^(id object, NSError *error) {
            //Should check for when the error is true
            [popover dismissPopoverAnimated:YES];
            
            // if there was no error and there is an object
            // redisplay information
            if (object) {
                [self Redisplay]; //Redisplay Method here
            }
        }];
        
        [fiu setPatient:_patient];
        [[fiu SaveButton]setTitle:@"Save" forState:UIControlStateNormal];
        [self setupView:fiu ForPopoverByButton:sender hasController:vc];
    }else{
        [FIUAppDelegate getNotificationWithColor:AJNotificationTypeOrange Animation:AJLinedBackgroundTypeAnimated WithMessage:@"Please find and select a patient first" inView:self.view];
    }
}

- (IBAction)commitPatient:(id)sender {
    
    UINavigationController* vc = [self getViewControllerFromiPadStoryboardWithName:@"Visitation"];
    
    UIViewController<ScreenNavigationDelegate,UIPopoverControllerDelegate>* fiu = vc.viewControllers.lastObject;
    
    [fiu setScreenHandler:^(id object, NSError *error) {
        //Should check for when the error is true
        [popover dismissPopoverAnimated:YES];
        
        // if there was no error and there is an object
        // redisplay information
        if (object) {
            //Redisplay Method here
        }
    }];
    
    [self setupView:fiu ForPopoverByButton:sender hasController:vc];
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
    
    [self setupView:vc ForPopoverByButton:sender hasController:nil];
}

-(void)setupView:(UIViewController<UIPopoverControllerDelegate>*)vc ForPopoverByButton:(id)btn hasController:(id)controller{
    
    id ctrl;
    
    if (controller) {
        ctrl = controller;
    }else{
        ctrl = vc;
    }
    
    popover = [[UIPopoverController alloc]initWithContentViewController:ctrl];
    
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
