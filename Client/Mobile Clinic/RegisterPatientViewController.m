//
//  RegisterPatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "DateController.h"
#import "RegisterPatientViewController.h"

UIPopoverController * pop;

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

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    facade = [[CameraFacade alloc]initWithView:self];
    
    if (!_patient)
        _patient = [[PatientObject alloc]initWithNewPatient];
    else
        [self Redisplay];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Redisplay {
    [_patientNameField setText:[_patient getObjectForAttribute:FIRSTNAME]];
    [_patientPhoto setImage:_patient.getPhoto];
    [_familyNameField setText:[_patient getObjectForAttribute:FAMILYNAME]];
    [_villageNameField setText:[_patient getObjectForAttribute:VILLAGE]];
    [_patientSexSegment setSelectedSegmentIndex:[[_patient getObjectForAttribute:SEX]integerValue]];
}

- (void)viewDidUnload {
    [self setCreatePatientButton:nil];
    [super viewDidUnload];
}

// Set up the camera source and view controller
- (IBAction)patientPhotoButton:(id)sender {
    // Added Indeterminate Loader
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:_patientPhoto.superview animated:YES];
    [progress setMode:MBProgressHUDModeIndeterminate];
    
    [facade TakePictureWithCompletion:^(id img) {
        if(img) {
            [_patientPhoto setImage:img];
            [_patient setPhoto:img];
        }
        [progress hide:YES];
    }];
}

- (IBAction)createPatient:(id)sender {
    // Before doing anything else, chech that all of the fields have been completed
    if (self.validateRegistration) {
        /* Age is set when the moment the user sets it through the Popover */
        [_patient setObject:_patientNameField.text withAttribute:FIRSTNAME];
        [_patient setObject:_familyNameField.text withAttribute:FAMILYNAME];
        [_patient setObject:_villageNameField.text withAttribute:VILLAGE];
        [_patient setObject: [NSNumber numberWithInt:_patientSexSegment.selectedSegmentIndex] withAttribute:SEX];
                
        // Even if the user file is being edited this method will
        // know the difference
        [_patient createNewPatient:^(id<BaseObjectProtocol> data, NSError *error) {
                handler(data,error);
        }];
    }
}

- (IBAction)getAgeOfPatient:(id)sender
{    
    // get datepicker view
    DateController *datepicker = [self getViewControllerFromiPadStoryboardWithName:@"datePicker"];
    
    // Instatiate popover if not available
    if (!pop) {
        pop = [[UIPopoverController alloc]initWithContentViewController:datepicker];
    }
    
    // Set Date if it is available
    if (_patient.getAge) {
        [datepicker.datePicker setDate:[_patient getObjectForAttribute:DOB]];
    }
    
    // set how the screen should return
    // set the age to the date the screen returns
    [datepicker setScreenHandler:^(id object, NSError *error) {
        // This method will return the age
        if (object) {
            [_patient setObject:object withAttribute:DOB];
            [_patientAgeField setTitle:[NSString stringWithFormat:@"%i Years Old",_patient.getAge] forState:UIControlStateNormal];
        }
        [pop dismissPopoverAnimated:YES];
    }];
    
    // show the screen beside the button
    [pop presentPopoverFromRect:_patientAgeField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)setScreenHandler:(ScreenHandler)myHandler {
    handler = myHandler;
}

// Checks the registration form for empty fields, or incorrect data (text in number field)
- (BOOL)validateRegistration {
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

-(void)resetData{
    [_patientAgeField setTitle:@"Tap to Set Age" forState:UIControlStateNormal];
    [_familyNameField setText:@""];
    [_patientNameField setText:@""];
    [_villageNameField setText:@""];
    [_patientPhoto setImage:[UIImage imageNamed:@"userImage.jpeg"]];
    [_patientSexSegment setSelectedSegmentIndex:0];
    _patient = [[PatientObject alloc]initWithNewPatient];
}
@end
