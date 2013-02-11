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

}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!_patientData)
        _patientData = [[PatientObject alloc]init];
    
}
-(void)setScreenHandler:(ScreenHandler)myHandler{
    // Responsible for dismissing the screen
    handler = myHandler;
    shouldDismiss = NO;
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
    return patientSearchResultsArray.count;
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    FIUSearchPatientViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[FIUSearchPatientViewControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    NSManagedObject * obj = [patientSearchResultsArray objectAtIndex:indexPath.row];
    
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
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    return shouldDismiss;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    shouldDismiss = YES;
    // Gets the object at the corresponding index
    NSManagedObject* obj = [patientSearchResultsArray objectAtIndex:indexPath.row];
    // Unpackage the object for use
    [_patientData unpackageDatabaseFileForUser:obj];
    // Return object to main screen and dismiss view
    handler(_patientData, nil);
}
// Search manually by patient name
- (IBAction)searchByNameButton:(id)sender {
 
    if (_patientNameField.text.isNotEmpty) {
        patientSearchResultsArray = [NSArray arrayWithArray:[_patientData FindObjectInTable:@"Patients" withName:_patientNameField.text forAttribute:@"firstName"]];
        
        [_patientResultTableView reloadData];
    }
}

- (IBAction)searchByNFCButton:(id)sender {
}

- (IBAction)searchByFingerprintButton:(id)sender {
}

- (IBAction)cancelSearching:(id)sender {
    shouldDismiss = YES;
    handler(nil,nil);
}
@end
