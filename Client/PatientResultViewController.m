//
//  PatientResultViewController.m
//  Mobile Clinic
//
//  Created by Rigo Hernandez on 2/23/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "PatientResultViewController.h"

@interface PatientResultViewController ()

@end

@implementation PatientResultViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
//    _patientNameLabel.text = @"rigo";
//    _patientAgeLabel.text = @"32";
//    _patientDOBLabel.text = @"Feb. 27, 1980";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
//    [self setPatientPhoto:nil];
//    [self setPatientNameLabel:nil];
//    [self setPatientDOBLabel:nil];
//    [self setPatientAgeLabel:nil];
    [super viewDidUnload];
}
@end
