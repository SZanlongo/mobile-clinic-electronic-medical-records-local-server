//
//  PreviousVisitsViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "PreviousVisitsViewController.h"

@interface PreviousVisitsViewController ()

@end

@implementation PreviousVisitsViewController

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
    
    // Define row height
    _patientHistoryTableView.rowHeight = 150;
    
    _visitData = [[Visitation alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    // Retrieve patientData
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPatientData:) name:CREATE_NEW_DIAGNOSIS object:_patientData];
    
    // Search database with patientId
    NSError *error;
    NSManagedObjectContext *context = [[FIUAppDelegate alloc] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    [request setEntity:[NSEntityDescription entityForName:@"Visitation" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(patientId like[cd] %@)", _patientData.patient.patientId]];

//    _patientHistoryArray = [NSMutableArray arrayWithArray:[context executeFetchRequest:request error:&error]];
//
//    // Populate cells
//    [_patientHistoryTableView reloadData];
}

// Assigns patientData from Notification
- (void)assignPatientData:(NSNotification *)note {
    _patientData = note.object;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPatientHistoryTableView:nil];
    [super viewDidUnload];
}

// Defines number of sections in the table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Defines number of row in the table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _patientHistoryArray.count;
}

// Defines content of cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"visitationCell";
    
    PatientHistoryTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        cell = [[PatientHistoryTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UINib * nib = [UINib nibWithNibName:@"PatientHistoryTableCellView" bundle:nil];
        cell = [nib instantiateWithOwner:nil options:nil][0];
    }

    _patientData.patient = (Patients *)[_patientHistoryArray objectAtIndex:indexPath.row];
    
    // Display contents of cells
//    cell.patientDOBLabel = [_patientData getDOB];
//    cell.patientAgeLabel = [_patientData getAge];
//    cell.patientWeightLabel = [NSNumber numberWithInt:_visitData.weight];
//    cell.patientBPLabel = [NSNumber numberWithInt:_visitData.bloodPressure];
//    cell.patientConditionsTextView = _visitData.complaint;
//    cell.patientMedicationTextView = ;
    
    return cell;
}

@end



