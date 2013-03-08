//
//  SearchPatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "SearchPatientViewController.h"
#import "BaseObject.h"
#import "MobileClinicFacade.h"
@interface SearchPatientViewController (){
    NSManagedObjectContext *context;
    MobileClinicFacade* mobileFacade;
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
        _patientData = [[NSMutableDictionary alloc]init];
    mobileFacade = [[MobileClinicFacade alloc]init];
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
    
    NSDictionary* base = [[NSDictionary alloc]initWithDictionary:[_patientSearchResultsArray objectAtIndex:indexPath.row]];
    

    
    // Display contents of cells
    if ([[base objectForKey:PICTURE]isKindOfClass:[NSData class]]) {
        UIImage* image = [UIImage imageWithData: [base objectForKey:PICTURE]];
        [cell.patientImage setImage:image];
    }
    
    
    cell.patientName.text = [NSString stringWithFormat:@"%@ %@", [base objectForKey:FIRSTNAME], [base objectForKey:FAMILYNAME]];
    NSDate* date = [base objectForKey:DOB];
    BOOL doesDOBExist = ([date isKindOfClass:[NSDate class]] && date);
    cell.patientAge.text = [NSString stringWithFormat:@"%i Years Old",(doesDOBExist)?date.getNumberOfYearsElapseFromDate:0];
    
    cell.patientDOB.text = (doesDOBExist)?[[base objectForKey:DOB]convertNSDateFullBirthdayString]:@"Not Available";
    
    
    NSLog(@"SIZE OF ARRAY: %u", _patientSearchResultsArray.count);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!mobileFacade) {
        mobileFacade = [[MobileClinicFacade alloc]init];
    }
    
    NSString * lockedBy = [[NSMutableDictionary dictionaryWithDictionary:[_patientSearchResultsArray objectAtIndex:indexPath.row]] objectForKey:ISLOCKEDBY];
                            
    if (![lockedBy isEqualToString:mobileFacade.GetCurrentUsername]) {
        [[[tableView cellForRowAtIndexPath:indexPath]contentView]setBackgroundColor:[UIColor yellowColor]];
    } else {
        [[[tableView cellForRowAtIndexPath:indexPath]contentView]setBackgroundColor:[UIColor whiteColor]];
    }
}

//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Sets color of cell when selected
    [[[tableView cellForRowAtIndexPath:indexPath]contentView]setBackgroundColor:[UIColor grayColor]];
    
    // TODO: MAKE SURE THAT THIS OBJECT IS NOT IN USE AND THAT YOU LOCK IT WHEN YOU USE IT.

    _patientData = [NSMutableDictionary dictionaryWithDictionary:[_patientSearchResultsArray objectAtIndex:indexPath.row]];
    
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
    switch (_mode) {
        case kTriageMode:
            [self BroadSearchForPatient];
            break;
        default:
             [self BroadSearchForPatient];
            break;
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
-(void)BroadSearchForPatient{
    //this will remove spaces BEFORE AND AFTER the string. I am leaving spaces in the middle because we might have names that are 2 words
    //this also updates the fields with the new format so the user knows that its being trimmed
    //also, keep in mind that adding several spaces after text adds a period
    
    _patientNameField.text = [_patientNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _familyNameField.text = [_familyNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (_patientNameField.text.isNotEmpty || _familyNameField.text.isNotEmpty) {
        [mobileFacade findPatientWithFirstName:_patientNameField.text orLastName:_familyNameField.text onCompletion:^(NSArray *allObjectsFromSearch, NSError *error) {
            // Get all the result from the query
            _patientSearchResultsArray  = [NSArray arrayWithArray:allObjectsFromSearch];
            
            // Redisplay the information
            [_searchResultTableView reloadData];
            
        }];
    }
}
-(void)narrowSearchInQueue{

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
    [_patientData removeAllObjects];
    [_familyNameField setText:@""];
    [_patientNameField setText:@""];
    _patientSearchResultsArray = nil;
    [_searchResultTableView reloadData];
}
@end
