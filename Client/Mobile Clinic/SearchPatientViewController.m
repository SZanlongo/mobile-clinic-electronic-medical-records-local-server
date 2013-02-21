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
    shouldDismiss = NO;
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
    
    //cell.PatientName.text = [NSString stringWithFormat:@"%@ %@", _patientData.patient.firstName, _patientData.patient.familyName];
    
    // Display contents of cells
    cell.patientName.text = _patientData.patient.firstName;
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
    
    if (_patientNameField.text.isNotEmpty) {
        // Gather results from firstName only
        // patientSearchResultsArray = [NSArray arrayWithArray:[_patientData FindObjectInTable:@"Patients" withName:_patientNameField.text forAttribute:@"firstName"]];
        
        // Gather results from firstName & familyName
        NSMutableOrderedSet *firstNameArray = [NSMutableOrderedSet orderedSetWithArray:[_patientData FindObjectInTable:@"Patients" withName:_patientNameField.text forAttribute:@"firstName"]];
        NSMutableOrderedSet *familyNameArray = [NSMutableOrderedSet orderedSetWithArray:[_patientData FindObjectInTable:@"Patients" withName:_familyNameField.text forAttribute:@"familyName"]];
        
        // Sort & union both arrays
        [firstNameArray unionOrderedSet:familyNameArray];
        [firstNameArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSManagedObject *first = obj1;
            NSManagedObject *second = obj2;
            
            NSString *name1 = [first valueForKey:@"firstName"];
            NSString *name2 = [second valueForKey:@"firstName"];
            
            return [name1 compare:name2];
        }];
        
        _patientSearchResultsArray = [NSArray arrayWithArray:firstNameArray.array];
        
        // Display as cells in table view
        [_searchResultTableView reloadData];
    }
}


- (PatientObject *)selectPatient{
    
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
