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
    BaseObject* base = [[BaseObject alloc]init];
    [base setDBObject:[_patientSearchResultsArray objectAtIndex:indexPath.row]];
    
    // Display contents of cells
    UIImage* image = [UIImage imageWithData:[base getObjectForAttribute:PICTURE]];
    [cell.patientImage setImage:image];
    cell.patientName.text = [NSString stringWithFormat:@"%@ %@", [base getObjectForAttribute:FIRSTNAME], [base getObjectForAttribute:FAMILYNAME]];
    NSDate* date = [base getObjectForAttribute:DOB];
    cell.patientAge.text = [NSString stringWithFormat:@"%i Years Old",date.getNumberOfYearsElapseFromDate];
    cell.patientDOB.text = [[base getObjectForAttribute:DOB]convertNSDateFullBirthdayString];
    
    NSLog(@"SIZE OF ARRAY: %u", _patientSearchResultsArray.count);
    
    return cell;
}

//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Sets color of cell when selected
    [[[tableView cellForRowAtIndexPath:indexPath]contentView]setBackgroundColor:[UIColor grayColor]];
    
    // TODO: MAKE SURE THAT THIS OBJECT IS NOT IN USE AND THAT YOU LOCK IT WHEN YOU USE IT.
    BaseObject* base = [[BaseObject alloc]init];
    
    [base setDatabaseObject:[_patientSearchResultsArray objectAtIndex:indexPath.row]];
    
    _patientData = [NSMutableDictionary dictionaryWithDictionary:base.getDictionaryValuesFromManagedObject];
    
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
        case kDoctorMode:
            [self narrowSearchInQueue];
            break;
        default:
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
    if (_patientNameField.text.isNotEmpty || _familyNameField.text.isNotEmpty) {
        [mobileFacade findPatientWithFirstName:_patientNameField.text orLastName:_familyNameField.text onCompletion:^(NSArray *allObjectsFromSearch, NSError *error) {
            if (error) {
                [FIUAppDelegate getNotificationWithColor:AJNotificationTypeOrange Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription];
            }
            // Get all the result from the query
            _patientSearchResultsArray  = [NSArray arrayWithArray:allObjectsFromSearch];
            
            // Redisplay the information
            [_searchResultTableView reloadData];
            
        }];
    }
}
-(void)narrowSearchInQueue{

    if (_patientNameField.text.isNotEmpty || _familyNameField.text.isNotEmpty) {
        [mobileFacade findAllOpenVisitsAndOnCompletion:^(NSArray *allObjectsFromSearch, NSError *error) {
            if (error) {
                [FIUAppDelegate getNotificationWithColor:AJNotificationTypeOrange Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription];
            }
            // Get all the result from the query
            _patientSearchResultsArray  = [NSArray arrayWithArray:allObjectsFromSearch];
            
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

-(void)resetData{
    [_patientData removeAllObjects];
    [_familyNameField setText:@""];
    [_patientNameField setText:@""];
    _patientSearchResultsArray = nil;
    [_searchResultTableView reloadData];
}
@end
