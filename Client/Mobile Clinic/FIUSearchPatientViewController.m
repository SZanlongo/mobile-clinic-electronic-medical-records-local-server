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

@interface FIUSearchPatientViewController ()
@end

@implementation FIUSearchPatientViewController

/*
- (id)init
{
    self = [super init];
    if (self) {
        _patientNameField = [[UITextField alloc] init];
    }
    return self;
}
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_patientData)
        _patientData = [[PatientObject alloc]init];
}

- (void)setScreenHandler:(ScreenHandler)myHandler{
    // Responsible for dismissing the screen
    handler = myHandler;
    shouldDismiss = NO;
}

- (CGSize)contentSizeForViewInPopover{
    return CGSizeMake(460, 600);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

// Determines the number of rows that appear in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _patientSearchResultsArray.count;
}

// Specifes contents of each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    FIUSearchPatientViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[FIUSearchPatientViewControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    NSManagedObject * obj = [_patientSearchResultsArray objectAtIndex:indexPath.row];
    
    [_patientData unpackageDatabaseFileForUser:obj];
    //cell.PatientName.text = _patientData.firstName;
    cell.PatientName.text = [NSString stringWithFormat:@"%@ %@", _patientData.firstName, _patientData.familyName];
    cell.PatientName.text =  _patientData.firstName;
    [cell.PatientPic setImage:_patientData.picture];
    
    return cell;
}

// 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    return shouldDismiss;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    shouldDismiss = YES;
    
    // Gets the object at the corresponding index
    NSManagedObject* obj = [_patientSearchResultsArray objectAtIndex:indexPath.row];
    
    // Unpackage the object for use
    [_patientData unpackageDatabaseFileForUser:obj];
    
    // Return object to main screen and dismiss view
    handler(_patientData, nil);
}

// Search manually by patient name
- (IBAction)searchByNameButton:(id)sender {
    
    if (_patientNameField.text.isNotEmpty) {
        // Gather results from firstName only
        // patientSearchResultsArray = [NSArray arrayWithArray:[_patientData FindObjectInTable:@"Patients" withName:_patientNameField.text forAttribute:@"firstName"]];
        
        // Gather results from firstName & familyName
        NSMutableOrderedSet *firstNameArray = [NSMutableOrderedSet orderedSetWithArray:[_patientData FindObjectInTable:@"Patients" withName:_patientNameField.text forAttribute:@"firstName"]];
        NSMutableOrderedSet *lastNameArray = [NSMutableOrderedSet orderedSetWithArray:[_patientData FindObjectInTable:@"Patients" withName:_patientNameField.text forAttribute:@"familyName"]];
        
        // Sort & union both arrays
        [firstNameArray unionOrderedSet:lastNameArray];
        [firstNameArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

            NSManagedObject *first = obj1;
            NSManagedObject *second = obj2;
            
            NSString *name1 = [first valueForKey:@"firstName"];
            NSString *name2 = [second valueForKey:@"firstName"];
            
            return [name1 compare:name2];
        }];
        
        _patientSearchResultsArray = [NSArray arrayWithArray:firstNameArray.array];
        
        // Display as cells in table view
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
