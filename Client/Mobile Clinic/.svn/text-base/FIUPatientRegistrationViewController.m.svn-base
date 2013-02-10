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

-(IBAction)patientPictureButton:(id)sender{
    pCtrl = [[UIImagePickerController alloc] init];
    pCtrl.delegate = self;    
    
    [pCtrl setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [self presentViewController:pCtrl animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    [patientPictureImage setImage:img];
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (IBAction)patientSexSegment:(id)sender {
}

- (IBAction)addFamilyMembersButton:(id)sender {
}

- (IBAction)registerPatientButton:(id)sender {
}

- (IBAction)patientVitalsButton:(id)sender {
}
@end
