//
//  FIUDiagnosisViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/10/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "FIUDiagnosisViewController.h"

@interface FIUDiagnosisViewController ()

@end

@implementation FIUDiagnosisViewController

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
    [self setPatientPicture:nil];
    [self setFamilyNameLabel:nil];
    [self setPatientNameLabel:nil];
    [self setPatientAgeLabel:nil];
    [self setPatientWeightLabel:nil];
    [self setPatientSexLabel:nil];
    [self setVillageNameLabel:nil];
    [self setDiagnosisText:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
}

- (IBAction)checkoutButton:(id)sender {
    id navCtrl = [self getViewControllerFromiPadStoryboardWithName:@"mainNavigationController"];
    [self presentViewController:navCtrl animated:YES completion:^{
        [FIUAppDelegate getNotificationWithColor:AJNotificationTypeGreen Animation:AJLinedBackgroundTypeAnimated WithMessage:@"Patient Checked Out"];
    }];
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

- (IBAction)searchForPatients:(id)sender {
    
    FIUPatientRegistrationViewController* vc = [self getViewControllerFromiPadStoryboardWithName:@"SearchPatients"];
    [_searchButton setEnabled:NO];
    [vc setScreenHandler:^(id object, NSError *error) {
        //Should check for when the error is true
        [popover dismissPopoverAnimated:YES];
        [_searchButton setEnabled:YES];
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

-(void)Redisplay{
    //set picture
    [_patientPicture setImage: [UIImage imageWithData:_patient.patient.photo]];
    
    _familyNameLabel.text = _patient.patient.familyName;
    _patientNameLabel.text = _patient.patient.firstName;
    _villageNameLabel.text = _patient.patient.villageName;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyy"];
    _patientAgeLabel.text = [dateFormat stringFromDate:_patient.patient.age];
    
    if (_patient.patient.sex = 0) {
        _patientSexLabel.text = @"Female";
    } else {
        _patientSexLabel.text = @"Male";
    }
    
}

- (IBAction)submitButton:(id)sender {
    
    id navCtrl = [self getViewControllerFromiPadStoryboardWithName:@"mainNavigationController"];
    [self presentViewController:navCtrl animated:YES completion:^{
        [FIUAppDelegate getNotificationWithColor:AJNotificationTypeGreen Animation:AJLinedBackgroundTypeAnimated WithMessage:@"Patient Diagnosis Submitted"];
    }];
}

@end
