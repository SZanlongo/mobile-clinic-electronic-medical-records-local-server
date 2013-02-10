//
//  FIUSearchViewController.m
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "FIUSearchPatientViewController.h"

@implementation FIUSearchPatientViewControllerCell
@end

//Global Variable Declarations
FIUAppDelegate *appDelegate;
NSMutableArray *patientResultsArray;

@interface FIUSearchPatientViewController ()

@end

@implementation FIUSearchPatientViewController

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
    
    // Instantiate Global Variables
    appDelegate = (FIUAppDelegate *)[[UIApplication sharedApplication] delegate];
    patientResultsArray = [[NSMutableArray alloc] init];
}

-(void)setScreenHandler:(ScreenHandler)myHandler{
    // Responsible for dismissing the screen
    handler = myHandler;
}

-(CGSize)contentSizeForViewInPopover{
    return CGSizeMake(460, 600);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [super viewDidUnload];
}

// Determines the number of rows that appear in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return patientResultsArray.count;
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    FIUSearchPatientViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[FIUSearchPatientViewControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    NSManagedObject * obj = [patientResultsArray objectAtIndex:indexPath.row];
    
    [_patientData unpackageDatabaseFileForUser:obj];

    cell.PatientName.text =  _patientData.firstName;
    [cell.PatientPic setImage:_patientData.picture];
    
    return cell;
}

//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Search manually by patient name
- (IBAction)searchByNameButton:(id)sender {
 
    patientResultsArray = [NSArray arrayWithArray:[_patientData FindObjectInTable:@"Patients" withName:_patientNameField.text forAttribute:@"firstname"]];
    
    [_patientResultTableView reloadData];
    
}

- (IBAction)searchByNFCButton:(id)sender {
}

- (IBAction)searchByFingerprintButton:(id)sender {
}
@end
