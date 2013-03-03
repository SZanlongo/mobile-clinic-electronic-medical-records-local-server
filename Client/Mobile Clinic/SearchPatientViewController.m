//
//  SearchPatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "SearchPatientViewController.h"
#import "FIUAppDelegate.h"

@interface SearchPatientViewController (){
    NSManagedObjectContext *context;
}

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
    
    // Set height of rows of result table
    _searchResultTableView.rowHeight = 75;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"resultCell";
    
    PatientResultTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        cell = [[PatientResultTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UINib * nib = [UINib nibWithNibName:@"PatientResultTableCellView" bundle:nil];
        cell = [nib instantiateWithOwner:nil options:nil][0];
    }
    
    [_patientData setDatabaseObject:[_patientSearchResultsArray objectAtIndex:indexPath.row]];

    // Display contents of cells
    [cell.patientImage setImage:_patientData.getPhoto];
    cell.patientName.text = [NSString stringWithFormat:@"%@ %@", [_patientData getObjectForAttribute:FIRSTNAME], [_patientData getObjectForAttribute:FAMILYNAME]];
    cell.patientAge.text = [NSString stringWithFormat:@"%i Years Old",_patientData.getAge];
    cell.patientDOB.text = [[_patientData getObjectForAttribute:DOB]convertNSDateFullBirthdayString];
    
    NSLog(@"SIZE OF ARRAY: %u", _patientSearchResultsArray.count);
    
    return cell;
}

// 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    // Gets the object at the corresponding index
    [_patientData setDatabaseObject:[_patientSearchResultsArray objectAtIndex:indexPath.row]];

    // Sets color of cell when selected
    [[[tableView cellForRowAtIndexPath:indexPath]contentView]setBackgroundColor:[UIColor grayColor]];
   
    handler(_patientData, nil);
}

/* Logic for search buttons */

// 
- (IBAction)searchByNameButton:(id)sender {
    // TEMPORARY CODE TO DO SEARCH
    // Check if there is at least one name
//    if (_patientNameField.text.isNotEmpty || _familyNameField.text.isNotEmpty) {
//
//        NSError *error;
//        context = [[FIUAppDelegate alloc] managedObjectContext];
//        NSFetchRequest *request = [[NSFetchRequest alloc] init];
//        
//        [request setEntity:[NSEntityDescription entityForName:@"Patients" inManagedObjectContext:context]];
//        [request setPredicate:[NSPredicate predicateWithFormat: @"(firstName beginswith[cd] %@) OR (familyName beginswith[cd] %@)", _patientNameField.text, _familyNameField.text]];
//        
//        _patientSearchResultsArray = [NSMutableArray arrayWithArray:[context executeFetchRequest:request error:&error]];
//        
//        // Redisplay the information
//        [_searchResultTableView reloadData];
//    }
    
// MIKE'S SEARCH (WILL EVENTUALLY IMPLEMENT WHEN ITS WORKING) ( DO NO DELETE!)
    // Check if there is at least one name
    if (_patientNameField.text.isNotEmpty || _familyNameField.text.isNotEmpty) {
        
        //this will remove spaces BEFORE AND AFTER the string. I am leaving spaces in the middle because we might have names that are 2 words
        //this also updates the fields with the new format so the user knows that its being trimmed
        //also, keep in mind that adding several spaces after text adds a period
        
        _patientNameField.text = [_patientNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        _familyNameField.text = [_familyNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //Search the server and save all the results to the Clients database
        [_patientData FindAllPatientsOnServerWithFirstName:_patientNameField.text andWithLastName:_familyNameField.text onCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
            if (error) {
                [FIUAppDelegate getNotificationWithColor:AJNotificationTypeOrange Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription];
            }

            // Get all the result from the query
            _patientSearchResultsArray  = [NSArray arrayWithArray:[_patientData FindAllPatientsLocallyWithFirstName:_patientNameField.text andWithLastName:_familyNameField.text]];
            
            // Redisplay the information
            [_searchResultTableView reloadData];
        }];
    }
    
    
    
//// FOR MY OWN TESTING (RIGO)
//    if([_patientSearchResultsArray count] == 0) {
//        NSLog(@"ARRAY IS EMPTY!!!!!!!!!");
//    }
//    else{
//        NSLog(@"ARRAY HAS STUFF INSIDE IT!!!!!!!!");
//    
//        for(Patients * obj in _patientSearchResultsArray) {
//            NSLog(@"NAME: %@ %@", obj.firstName, obj.familyName);
//        }
//    }
}

- (IBAction)searchByNFCButton:(id)sender {
}

- (IBAction)searchByFingerprintButton:(id)sender {
}

- (IBAction)cancelSearching:(id)sender {
    shouldDismiss = YES;
    handler(nil,nil);
}

-(void)resetData{
    _patientData = [[PatientObject alloc]initWithNewPatient];
    [_familyNameField setText:@""];
    [_patientNameField setText:@""];
    _patientSearchResultsArray = nil;
    [_searchResultTableView reloadData];
}
@end
