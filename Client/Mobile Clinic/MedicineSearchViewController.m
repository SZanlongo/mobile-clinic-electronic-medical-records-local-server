//
//  MedicineSearchViewController.m
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/24/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "MedicineSearchViewController.h"

@interface MedicineSearchViewController ()

@end

@implementation MedicineSearchViewController

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

- (IBAction)moveBackToPrescription:(id)sender {
}
- (void)viewDidUnload {
    [self setMedicineField:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
- (IBAction)searchMedicine:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:MOVE_FROM_SEARCH_FOR_MEDICINE object:_medicineField.text];
}
@end
