//
//  FIUPatientRegistrationViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "FIUPatientRegistrationViewController.h"

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
        patientAgeField = [[UITextField alloc] init];
    }
    return self;
}

//set up the camera source and view controller
-(IBAction)patientPictureButton:(id)sender{
    pCtrl = [[UIImagePickerController alloc] init];
    pCtrl.delegate = self;
    [pCtrl setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [self presentViewController:pCtrl animated:YES completion:nil];
}

- (IBAction)giveMedicineButton:(id)sender {
    //before doing anything else, check that all of the fields have been completed
    if(self.validateRegistration) {
        UIStoryboard * mStory = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        [[mStory instantiateViewControllerWithIdentifier:@"Register"] performSegueWithIdentifier:@"checkout" sender:self];
        
    }
}

- (IBAction)registerPatientButton:(id)sender {
    //before doing anything else, chech that all of the fields have been completed
    if (self.validateRegistration) {
        _patient.familyName = familyNameField.text;
        _patient.firstName = patientNameField.text;
        _patient.village = villageNameField.text;
        //_patient.age = patientAgeField.text;
        _patient.sex = patientSexSegment.selectedSegmentIndex;
        
        handler(self, nil);
    }
}

//dismiss the controller and gui
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    [patientPictureImage setImage:img];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//cancel the camera
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    _patient = [[PatientObject alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPatientSexSegment:nil];
    [super viewDidUnload];
}
- (IBAction)patientSexSegment:(id)sender {
}

-(void)setScreenHandler:(ScreenHandler)setHandler{
    handler = setHandler;
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
    }else if ([patientWeightField.text isEqualToString:@""] || patientWeightField.text == nil){
        errorMsg = @"Missing Patient Weight";
        inputIsValid = NO;
    }else if(![[NSScanner scannerWithString:patientWeightField.text] scanFloat:NULL]) {
        errorMsg = @"Patient Weight is not Numeric";
        inputIsValid = NO;
    }else if([patientAgeField.text isEqualToString:@""] || patientAgeField.text == nil){
        errorMsg = @"Missing Patient Age";
        inputIsValid = NO;
    } else if(![[NSScanner scannerWithString:patientAgeField.text] scanFloat:NULL]) {
        errorMsg = @"Patient Age is not Numeric";
        inputIsValid = NO;
    }
    
    //display error message on invlaid input
    if(inputIsValid == NO){
        UIAlertView *validateRegistrationAlert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [validateRegistrationAlert show];
    }
    
    return inputIsValid;
}
@end
