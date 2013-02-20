//
//  RegisterPatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "RegisterPatientViewController.h"
#import "DateController.h"

UIPopoverController* pop;
@interface RegisterPatientViewController ()

@end

@implementation RegisterPatientViewController

-(id)init
{
    self = [super init];
    if (self) {
        //initialize these fields
       
    }
    return self;
}



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
    
    facade = [[CameraFacade alloc]initWithView:self];
    if (!_patient)
        _patient = [[PatientObject alloc]initWithNewPatient];
    else
        [self Redisplay];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Redisplay{
    [_patientNameField setText:_patient.patient.firstName];
    [_patientPhoto setImage:_patient.getPhoto];
    [_familyNameField setText:_patient.patient.familyName];
    [_villageNameField setText:_patient.patient.villageName];
    [_patientSexSegment setSelectedSegmentIndex:_patient.patient.sex.integerValue];
//    NSString* age = [NSString stringWithFormat:@"%i Years Old",_patient.getAge];
//    [_patientAgeField setTitle:age forState:UIControlStateNormal];
}

- (void)viewDidUnload {

    [super viewDidUnload];
}

// Set up the camera source and view controller
- (IBAction)patientPhotoButton:(id)sender {
    // Added Indeterminate Loader
    MBProgressHUD* progress = [MBProgressHUD showHUDAddedTo:_patientPhoto.superview animated:YES];
    [progress setMode:MBProgressHUDModeIndeterminate];
    
    [facade TakePictureWithCompletion:^(id img) {
        if(img) {
            [_patientPhoto setImage:img];
            [_patient.patient setPhoto:[img convertImageToPNGBinaryData]];
        }
        [progress hide:YES];
    }];
}

// Create a patient in the DB
- (IBAction)createPatientButton:(id)sender {
    // Before doing anything else, chech that all of the fields have been completed
    if (self.validateRegistration) {
        /* Age is set when the moment the user sets it through the Popover */
        _patient.patient.firstName = _patientNameField.text;
        _patient.patient.familyName = _familyNameField.text;
        _patient.patient.villageName = _villageNameField.text;
        _patient.patient.sex = [NSNumber numberWithInt:_patientSexSegment.selectedSegmentIndex];
        
        // Even if the user file is being edited this method will
        // know the difference
        [_patient createNewPatient:^(id<BaseObjectProtocol> data, NSError *error) {
            if (error)
            {
                [FIUAppDelegate getNotificationWithColor:AJNotificationTypeRed Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription inView:self.view
                 ];
            }
            else
            {
                handler(self, nil);
            }
        }];
    }
}

- (IBAction)getAgeOfPatient:(id)sender {
    
    // get datepicker view
    DateController* datepicker = [self getViewControllerFromiPadStoryboardWithName:@"datePicker"];
    
    // Instatiate popover if not available
    if (!pop) {
        pop = [[UIPopoverController alloc]initWithContentViewController:datepicker];
    }
    
    // Set Date if it is available
    if (_patient.patient.age) {
        [datepicker.datePicker setDate:_patient.patient.age];
    }
    
    // set how the screen should return
    // set the age to the date the screen returns
    [datepicker setScreenHandler:^(id object, NSError *error) {
        // This method will return the age
        if (object) {
            _patient.patient.age = object;
            [_patientAgeField setTitle:[NSString stringWithFormat:@"%i Years Old",_patient.getAge] forState:UIControlStateNormal];
            
        }
        [pop dismissPopoverAnimated:YES];
    }];
    
    // show the screen beside the button
    [pop presentPopoverFromRect:_patientAgeField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
    shouldDismiss = NO;
}

// Checks the registration form for empty fields, or incorrect data (text in number field)
-(BOOL)validateRegistration{
    BOOL inputIsValid = YES;
    NSString *errorMsg;
    
    // Check for missing input
    // Not checking to see if the name, family, or village strings contain numbers,
    // This can always be revised, but some names apparently have "!" to symbolize a click (now you learned something new!)
    if([_patientNameField.text isEqualToString:@""] || _patientNameField.text == nil) {
        errorMsg = @"Missing Patient Name";
        inputIsValid = NO;
    }else if([_familyNameField.text isEqualToString:@""] || _familyNameField.text == nil) {
        errorMsg = @"Missing Family Name";
        inputIsValid = NO;
    } else if([_villageNameField.text isEqualToString:@""] || _villageNameField.text == nil){
        errorMsg = @"Missing Village Name";
        inputIsValid = NO;
    }
    
    //display error message on invlaid input
    if(inputIsValid == NO){
        UIAlertView *validateRegistrationAlert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [validateRegistrationAlert show];
    }
    
    return inputIsValid;
}

- (IBAction)cancelRegistrationClearScreenAndCreateNewPatient:(id)sender {
    shouldDismiss= YES;
    handler(self, nil);
}
@end
