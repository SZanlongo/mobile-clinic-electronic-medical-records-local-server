//
//  FIUPatientRegistrationViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "FIUPatientRegistrationViewController.h"
#import "DateController.h"

@interface FIUPatientRegistrationViewController ()

@end

@implementation FIUPatientRegistrationViewController

@synthesize familyNameField, patientNameField, villageNameField, patientWeightField, patientAgeField, patientPictureImage, patientSexSegment;
- (id)init
{
    self = [super init];
    if (self) {
        //initialize these fields
        familyNameField = [[UITextField alloc] init];
        patientNameField = [[UITextField alloc] init];
        villageNameField = [[UITextField alloc] init];
        patientWeightField = [[UITextField alloc] init];
        patientAgeField = [[UIButton alloc] init];
    }
    return self;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    id vc = segue.destinationViewController;
    
    if ([vc isKindOfClass:[DateController class]]) {
        DateController* dvc = vc;
        
        [dvc view];
        
        [dvc setScreenHandler:^(id object, NSError *error) {
            // This method will return the age
            if (object) {
                _patient.patient.age = object;
                [patientAgeField setTitle:[NSString stringWithFormat:@"%i Years Old",_patient.getAge] forState:UIControlStateNormal];
            }
         [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
//set up the camera source and view controller
-(IBAction)patientPictureButton:(id)sender{
    
    //Added Indeterminate Loader
   MBProgressHUD* progress = [MBProgressHUD showHUDAddedTo:patientPictureImage.superview animated:YES];
    [progress setMode:MBProgressHUDModeIndeterminate];
    
    [facade TakePictureWithCompletion:^(id img) {
        if (img) {
            [patientPictureImage setImage:img];
            [_patient.patient setPhoto:[img convertImageToPNGBinaryData]];
        }
        [progress hide:YES];
    }];

}

- (IBAction)registerPatientButton:(id)sender {
    //before doing anything else, chech that all of the fields have been completed
    if (self.validateRegistration) {
        _patient.patient.familyName = familyNameField.text;
        _patient.patient.firstName = patientNameField.text;
        _patient.patient.villageName = villageNameField.text;
        _patient.patient.sex = [NSNumber numberWithInt:patientSexSegment.selectedSegmentIndex];
       
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
    else{
        [self Redisplay];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    return  shouldDismiss;
}
- (void)viewDidUnload {
    [self setPatientSexSegment:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
}

- (IBAction)patientSexSegment:(id)sender {
}
-(void)Redisplay{
    [patientNameField setText:_patient.patient.firstName];
    [patientPictureImage setImage:_patient.getPhoto];
    [familyNameField setText:_patient.patient.familyName];
    [villageNameField setText:_patient.patient.villageName];
    [patientSexSegment setSelectedSegmentIndex:_patient.patient.sex.integerValue];
    NSString* age = [NSString stringWithFormat:@"%i Years Old",_patient.getAge];
    [patientAgeField setTitle:age forState:UIControlStateNormal];
}

-(void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
    shouldDismiss = NO;
}

//checks the registration form for empty fields, or incorrect data (text in number field)
-(BOOL)validateRegistration{
    BOOL inputIsValid = YES;
    NSString *errorMsg;
    
    //check for missing input
    //im not checking to see if the name, village, or family strings contain numbers,
    //this can always be revised, but some names apparently have "!" to symbolize a click (now you learned something new!)
    if([familyNameField.text isEqualToString:@""] || familyNameField.text == nil) {
        errorMsg = @"Missing Family Name";
        inputIsValid = NO;
    }else if([patientNameField.text isEqualToString:@""] || patientNameField.text == nil) {
        errorMsg = @"Missing Patient Name";
        inputIsValid = NO;
    } else if([villageNameField.text isEqualToString:@""] || villageNameField.text == nil){
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

- (IBAction)cancelRegistration:(id)sender {
    shouldDismiss= YES;
    handler(self, nil);
}

@end
