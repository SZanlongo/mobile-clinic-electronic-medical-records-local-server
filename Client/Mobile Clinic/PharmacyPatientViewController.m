//
//  PharmacyPatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/24/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "PharmacyPatientViewController.h"

@interface PharmacyPatientViewController ()

@end

@implementation PharmacyPatientViewController

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
    [self setPatientName:nil];
    [self setFamilyName:nil];
    [self setVillageName:nil];
    [self setPatientAge:nil];
    [self setPatientSex:nil];
    [self setPatientDiagnosis:nil];
    [self setPatientPrescription:nil];
    [super viewDidUnload];
}
- (IBAction)submitPrescription:(id)sender {
}
@end
