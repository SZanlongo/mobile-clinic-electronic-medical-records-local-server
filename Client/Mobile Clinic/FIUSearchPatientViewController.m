//
//  FIUSearchViewController.m
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "FIUSearchPatientViewController.h"

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPatientNameField:nil];
    [self setPatientResultTableView:nil];
    [super viewDidUnload];
}

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

// Determines the number of rows that appear in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return patientResultsArray.count;
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    NSManagedObject * obj = [patientResultsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [obj valueForKey:@"firstname"];
    //    cell.textLabel.text = [obj valueForKey:@"family_name"];
    cell.textLabel.text = [obj valueForKey:@"age"];
    //    cell.textLabel.text = [obj valueForKey:@"sex"];
    
    return cell;
}

//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

// Search manually by patient name
- (IBAction)searchByNameButton:(id)sender {
    
    NSError *error;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Patients" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:
                           @"(firstname contains[cd] %@) OR (family_name contains[cd] %@)", _patientNameField.text, _patientNameField.text]];
    
    patientResultsArray = [NSMutableArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    [_patientResultTableView reloadData];
    
    for(NSManagedObject *patients in patientResultsArray){
        NSLog(@"Name: %@", [patients valueForKey:@"firstname"]);
        NSLog(@"Age: %@", [patients valueForKey:@"age"]);
        NSLog(@"Sex: %@", [patients valueForKey:@"sex"]);
    }
}

- (IBAction)searchByNFCButton:(id)sender {
}

- (IBAction)searchByFingerprintButton:(id)sender {
}
@end
