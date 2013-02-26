//
//  PreviousVisitsViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "PreviousVisitsViewController.h"

@interface PreviousVisitsViewController (){
    NSManagedObjectContext *context;
}
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
}

- (void)viewWillAppear:(BOOL)animated {

    // Search database with patientId
    _patientHistoryArray = [_patientData getAllVisitsForCurrentPatient];
    
    // Populate cells
    [_patientHistoryTableView reloadData];
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
    }
    
    VisitationObject * visitData = [_patientHistoryArray objectAtIndex:indexPath.row];
    
    // Display contents of cells
    cell.patientDOBLabel.text = [[_patientData getObjectForAttribute:DOB]convertNSDateFullBirthdayString];
    cell.patientAgeLabel.text = [_patientData getObjectForAttribute:DOB];
    cell.patientWeightLabel.text = [visitData getObjectForAttribute:WEIGHT];
    cell.patientBPLabel.text = [visitData getObjectForAttribute:BLOODPRESSURE];
    [cell.patientConditionsTextView setText:[visitData getObjectForAttribute:CONDITION]];
//    cell.patientMedicationTextView setText:[visitData getObjectForAttribute:MEDICATIONID]];
    
    return cell;
}

//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Gets the object at the corresponding index
    [_patientData setDatabaseObject:[_patientHistoryArray objectAtIndex:indexPath.row]];
    
    // Sets color of cell when selected
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor grayColor];
    
    // Select patient and post notification
//    [[NSNotificationCenter defaultCenter] postNotificationName:<#(NSString *)#> object:_patientData];
}

@end



