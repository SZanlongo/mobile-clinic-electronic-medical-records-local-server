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
        _patient = [[NSMutableDictionary alloc]initWithCapacity:10];
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
    
    [_patientNameField setText:[_patient objectForKey:FIRSTNAME]];
    [_patientPhoto setImage:[UIImage imageWithData:[_patient objectForKey:PICTURE]]];
    [_familyNameField setText:[_patient objectForKey:FAMILYNAME]];
    [_villageNameField setText:[_patient objectForKey:VILLAGE]];
    [_patientSexSegment setSelectedSegmentIndex:[[_patient objectForKey:SEX]integerValue]];
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
            [_patient setValue:[img convertImageToPNGBinaryData] forKey:PICTURE];
        }
        [progress hide:YES];
    }];
}

- (IBAction)createPatient:(id)sender {
    // Before doing anything else, chech that all of the fields have been completed
    if (self.validateRegistration) {
        /* Age is set when the moment the user sets it through the Popover */
        [_patient setValue:_patientNameField.text forKey:FIRSTNAME];
        [_patient setValue:_familyNameField.text forKey:FAMILYNAME];
        [_patient setValue:_villageNameField.text forKey:VILLAGE];
        [_patient setValue:[NSNumber numberWithInt:_patientSexSegment.selectedSegmentIndex] forKey:SEX];
        /**
         * This will create a patient locally and on the server.
         * The patient created on the server will be locked automatically.
         * This is done because of the workflow of the system
         * To unlock the patient see the documentation for the PatientObject
         */
        
        MobileClinicFacade* mobileFacade = [[MobileClinicFacade alloc]init];
       
        [mobileFacade createAndCheckInPatient:_patient onCompletion:^(NSDictionary *object, NSError *error) {
            if (!object) {
                [FIUAppDelegate getNotificationWithColor:AJNotificationTypeRed Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription];
            }else{                
                handler(object,error);
            }
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
    if ([_patient objectForKey:DOB]) {
        [datepicker.datePicker setDate:[_patient objectForKey:DOB]];
    }
    
    // set how the screen should return
    // set the age to the date the screen returns
    [datepicker setScreenHandler:^(id object, NSError *error) {
        // This method will return the age
        if (object) {
            [_patient setValue:object forKey:DOB];
            NSDate* date = object;
            
            [_patientAgeField setTitle:[NSString stringWithFormat:@"%i Years Old", [date getNumberOfYearsElapseFromDate]] forState:UIControlStateNormal];
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
        errorMsg = @"Missing Name";
        inputIsValid = NO;
    }else if([_familyNameField.text isEqualToString:@""] || _familyNameField.text == nil) {
        errorMsg = @"Missing Family Name";
        inputIsValid = NO;
    } else if([_villageNameField.text isEqualToString:@""] || _villageNameField.text == nil){
        errorMsg = @"Missing Village Name";
        inputIsValid = NO;
    } else if ([_patient objectForKey:DOB] == nil) {
        errorMsg = @"Missing Age";
        inputIsValid = NO;
    }
//    else if ([_patient objectForKey:PICTURE] == nil) {
//        errorMsg = @"Missing Photo";
//        inputIsValid = NO;
//    }
    
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
    [_patient removeAllObjects];
}

// Hides keyboard when whitespace is pressed
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
