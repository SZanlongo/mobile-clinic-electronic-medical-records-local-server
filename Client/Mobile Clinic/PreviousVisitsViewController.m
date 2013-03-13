//
//  PreviousVisitsViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "PreviousVisitsViewController.h"
#import "MobileClinicFacade.h"
#import "BaseObject.h"

@interface PreviousVisitsViewController (){
    NSManagedObjectContext *context;
    MobileClinicFacade* mobileFacade;
    NSArray *tempArray;                     // TEMP .. CAN DELELE
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
    mobileFacade = [[MobileClinicFacade alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {

    /*
     * Please Look at the API For instructions on the MobileClinicFacade
     * This class is meant to simplify work, reduce code and reduce coupling
     * The Previous Code to populate the cells with information has been reduced to one method call
     */
     
    [mobileFacade findAllVisitsForCurrentPatient:_patientData AndOnCompletion:^(NSArray *allObjectsFromSearch, NSError *error) {
        _patientHistoryArray = [NSMutableArray arrayWithArray:allObjectsFromSearch];
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"triageOut" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        _patientHistoryArray = [NSMutableArray arrayWithArray:[_patientHistoryArray sortedArrayUsingDescriptors:sortDescriptors]];
        [_patientHistoryTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
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
    
    // Set Patient Data
    cell.patientDOBLabel.text = [[_patientData objectForKey:DOB]convertNSDateFullBirthdayString];

    // Set Visitation Data
    BaseObject * visitData = [[BaseObject alloc]init];
    [visitData setDBObject:[_patientHistoryArray objectAtIndex:indexPath.row]];
    
    cell.patientWeightLabel.text = [NSString stringWithFormat:@"%.02f",[[visitData getObjectForAttribute:WEIGHT]doubleValue]];
    cell.patientBPLabel.text = [visitData getObjectForAttribute:BLOODPRESSURE];
//    cell.patientHeartLabel.text = [visitData getObjectForAttribute:HEARTRATE];
//    cell.patientRespirationLabel.text = [visitData getObjectForAttribute:RESPIRATION];
    [cell.patientConditionsTextView setText:[visitData getObjectForAttribute:CONDITION]];

    return cell;
}

//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // TODO: YOU NEED TO TRY AND LOCK THE PATIENT BEFORE CHANGING SCREENS OR PROCEEDING
    
    // Gets the object at the corresponding index
   // [_patientData setDatabaseObject:[_patientHistoryArray objectAtIndex:indexPath.row]];
    
    // Sets color of cell when selected
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor grayColor];

}

@end



