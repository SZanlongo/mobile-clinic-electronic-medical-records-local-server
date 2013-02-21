//
//  SearchPatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "SearchPatientViewController.h"

@implementation SearchPatientViewControllerCell
@end

@interface SearchPatientViewController ()
@end

@implementation SearchPatientViewController

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
    
    if (!_patientData)
        _patientData = [[PatientObject alloc]init];
}

- (void)setScreenHandler:(ScreenHandler)myHandler{
    // Responsible for dismissing the screen
    handler = myHandler;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
//    [self setPatientNameField:nil];
//    [self setFamilyNameField:nil];
//    [self setSearchResultTableView:nil];
    [super viewDidUnload];
}


/* Deals with cells in Table View */

// Determines the number of rows that appear in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _patientSearchResultsArray.count;
}

// Specifes contents of each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    SearchPatientViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SearchPatientViewControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    _patientData.patient = (Patients *)[_patientSearchResultsArray objectAtIndex:indexPath.row];
    
    // Display contents of cells
    cell.patientName.text = [NSString stringWithFormat:@"%@ %@", _patientData.patient.firstName, _patientData.patient.familyName];
    
    [cell.patientPic setImage:_patientData.getPhoto];
    
    cell.ageLabel.text =  [NSString stringWithFormat:@"%d", _patientData.patient.age.getNumberOfYearsElapseFromDate];
    
    cell.dateLabel.text = _patientData.patient.age.convertNSDateToString;
    
    return cell;
}

// 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    shouldDismiss = YES;
    
    // Gets the object at the corresponding index
    _patientData.patient = (Patients *)[_patientSearchResultsArray objectAtIndex:indexPath.row];
    
    // Return object to main screen and dismiss view
    handler(_patientData, nil);
    
    [_patientFound sendActionsForControlEvents:UIControlEventTouchUpInside];
}


/* Logic for search buttons */

- (IBAction)searchByNameButton:(id)sender {
    
    // Check if there is at least one name 
    if (_patientNameField.text.isNotEmpty || _familyNameField.text.isNotEmpty) {
        //Search the server and save all the results to the Clients database
        [_patientData FindAllPatientsOnServerWithFirstName:_patientNameField.text andWithLastName:_familyNameField.text onCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
            // Get all the result from the query
            _patientSearchResultsArray  = [NSArray arrayWithArray:[_patientData FindAllPatientsLocallyWithFirstName:_patientNameField.text andWithLastName:_familyNameField.text]];
            // Redisplay the information
            [_searchResultTableView reloadData];
        }];
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
