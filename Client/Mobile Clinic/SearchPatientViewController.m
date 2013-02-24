//
//  SearchPatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "SearchPatientViewController.h"
#import "FIUAppDelegate.h"

//@implementation SearchPatientViewControllerCell
//@end

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

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!_patientData)
        _patientData = [[PatientObject alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {    
//    // Create controllers for each view (Search & Register)
//    _resultControl = [self getViewControllerFromiPadStoryboardWithName:@"patientResultViewController"];
}

- (void)setScreenHandler:(ScreenHandler)myHandler {
    // Responsible for dismissing the screen
    handler = myHandler;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

/* Deals with cells in Table View */

// Defines number of sections in the table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Defines number of row in the table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _patientSearchResultsArray.count;
}


// Defines content of cells

// RIGO IMPLEMENTATION
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"TEST-IN");
    
    static NSString * CellIdentifier = @"resultCell";
    
    PatientResultTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        cell = [[PatientResultTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UINib * mNib = [UINib nibWithNibName:@"PatientResultTableCellView" bundle:nil];
        cell = [mNib instantiateWithOwner:nil options:nil][0];
    }
    
    _patientData.patient = (Patients *)[_patientSearchResultsArray objectAtIndex:indexPath.row];
    
    
//    // TESTING SOMETHING (RIGO)
//    NSLog(@"!!!!!!!!!");
//    NSLog(@"Name: %@", [NSString stringWithFormat:@"%@ %@", _patientData.patient.firstName, _patientData.patient.familyName]);
//    NSLog(@"DOB: %@", [NSString stringWithFormat:@"%i Years Old", _patientData.patient.age.getNumberOfYearsElapseFromDate]);
//    NSLog(@"Age: %@", _patientData.patient.age.convertNSDateFullBirthdayString);
//    NSLog(@"!!!!!!!!!");
    

    // Display contents of cells
    [cell.patientImage setImage:_patientData.getPhoto];
    cell.patientName.text = [NSString stringWithFormat:@"%@ %@", _patientData.patient.firstName, _patientData.patient.familyName];
    cell.patientAge.text = [NSString stringWithFormat:@"%i Years Old", _patientData.patient.age.getNumberOfYearsElapseFromDate];
    cell.patientDOB.text = _patientData.patient.age.convertNSDateFullBirthdayString;

//    NSLog(@"TEST-OUT");
    
    return cell;
}




//// MIKE'S IMPLEMENTATION
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"SearchCell";
//    
//    SearchPatientViewControllerCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[SearchPatientViewControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    _patientData.patient = (Patients *)[_patientSearchResultsArray objectAtIndex:indexPath.row];
//    
//    // Display contents of cells
//    cell.patientName.text = [NSString stringWithFormat:@"%@ %@", _patientData.patient.firstName, _patientData.patient.familyName];
//    [cell.patientPic setImage:_patientData.getPhoto];
//    cell.ageLabel.text = [NSString stringWithFormat:@"%i Years Old", _patientData.patient.age.getNumberOfYearsElapseFromDate];
//    cell.dateLabel.text = _patientData.patient.age.convertNSDateFullBirthdayString;
//    
//    return cell;
//}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    // Gets the object at the corresponding index
//    _patientData.patient = (Patients *)[_patientSearchResultsArray objectAtIndex:indexPath.row];
//    
//    // Return object to main screen and dismiss view
//    // handler(_patientData, nil);
//    
////    [_patientFound sendActionsForControlEvents:UIControlEventTouchUpInside];
//    
//    
//}


/* Logic for search buttons */

// 
- (IBAction)searchByNameButton:(id)sender {
    // TEMPORARY CODE TO DO SEARCH
    // Check if there is at least one name
    if (_patientNameField.text.isNotEmpty || _familyNameField.text.isNotEmpty) {

        NSError *error;
        NSManagedObjectContext *context = [[FIUAppDelegate alloc] managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        [request setEntity:[NSEntityDescription entityForName:@"Patients" inManagedObjectContext:context]];
        [request setPredicate:[NSPredicate predicateWithFormat: @"(firstName contains[cd] %@)", _patientNameField.text]];
        
        _patientSearchResultsArray = [NSMutableArray arrayWithArray:[context executeFetchRequest:request error:&error]];
        
        // Redisplay the information
        [_searchResultTableView reloadData];
    }
    
// MIKE'S STUFF
//    // Check if there is at least one name 
//    if (_patientNameField.text.isNotEmpty || _familyNameField.text.isNotEmpty) {
//        
//        //Search the server and save all the results to the Clients database
//        [_patientData FindAllPatientsOnServerWithFirstName:_patientNameField.text andWithLastName:_familyNameField.text onCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
//            if (error) {
//                [FIUAppDelegate getNotificationWithColor:AJNotificationTypeOrange Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription inView:self.view];
//            }
//            
//            // Get all the result from the query
//            _patientSearchResultsArray  = [NSArray arrayWithArray:[_patientData FindAllPatientsLocallyWithFirstName:_patientNameField.text andWithLastName:_familyNameField.text]];
//            
//            // Redisplay the information
//            [_searchResultTableView reloadData];
//        }];
//    }

    

// FOR MY OWN TESTING (RIGO)
    if([_patientSearchResultsArray count] == 0) {
        NSLog(@"ARRAY IS EMPTY!!!!!!!!!");
    }
    else{
        NSLog(@"ARRAY HAS STUFF INSIDE IT!!!!!!!!");
    
        for(Patients * obj in _patientSearchResultsArray) {
            NSLog(@"NAME: %@ %@", obj.firstName, obj.familyName);
        }
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
