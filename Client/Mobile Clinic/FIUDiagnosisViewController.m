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
    [self setSymptomsText:nil];
    [self setDiagnosisText:nil];
    [self setTreatmentsText:nil];
    [self setCancelButton:nil];
    [self setCheckoutButton:nil];
    [self setSubmitButton:nil];
    [super viewDidUnload];
}
@end
