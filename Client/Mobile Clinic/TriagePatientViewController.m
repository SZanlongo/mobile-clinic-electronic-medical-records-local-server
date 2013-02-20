//
//  TriagePatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "TriagePatientViewController.h"

@interface TriagePatientViewController ()

@end

@implementation TriagePatientViewController

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
    [self setPatientNameLabel:nil];
    [self setFamilyNameLabel:nil];
    [self setVillageNameLabel:nil];
    [self setPatientAgeLabel:nil];
    [self setPatientSexLabel:nil];
    [self setPatientWeightLabel:nil];
    [self setPatientBPLabel:nil];
    [super viewDidUnload];
}
@end