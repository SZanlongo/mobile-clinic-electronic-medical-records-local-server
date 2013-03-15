//
//  MedicineSearchViewController.m
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/24/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "MedicineSearchViewController.h"
#import "MobileClinicFacade.h"

@interface MedicineSearchViewController () {
    MobileClinicFacade *mobileFacade;
    NSMutableArray *medicationArray;
}

@end

@implementation MedicineSearchViewController

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
    
    // Request all medications in database
    mobileFacade = [[MobileClinicFacade alloc]init];
    NSDictionary *myDic = [[NSDictionary alloc]init];
    
    [mobileFacade findAllMedication:myDic AndOnCompletion:^(NSArray *allObjectsFromSearch, NSError *error) {
        NSLog(@"ALl Medications:%@",allObjectsFromSearch.description);
        medicationArray = [NSArray arrayWithArray:allObjectsFromSearch];
    }];

//    // TEMP LIST OF MEDICATIONS
//    _data1 = [[NSMutableArray alloc] initWithObjects:@"Advil",@"Ibuprofen", @"Cephalexin",@"Ciprofloxacin",@"Doxycycline", nil];
//    _data2 = [[NSMutableArray alloc] initWithObjects:@"250mg",@"500mg", @"250mg",@"250mg",@"100mg", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moveBackToPrescription:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:MOVE_FROM_SEARCH_FOR_MEDICINE object:_medicineField.text];
}
- (void)viewDidUnload {
    [self setMedicineField:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
- (IBAction)searchMedicine:(id)sender {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MedicineSearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:@"medicineResult"];

    if(!cell){
        cell = [[MedicineSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"medicineResult"];
        UINib * mNib = [UINib nibWithNibName:@"MedicineSearchResultView" bundle:nil];
        cell = [mNib instantiateWithOwner:nil options:nil][0];
    }

    NSDictionary *myDic = [medicationArray objectAtIndex:indexPath.row];
    
    cell.medicineName.text = [myDic objectForKey:@""];
//    cell.medicineDose.text = [];
    
//    cell.medicineName.text = (NSString *)[_data1 objectAtIndex:indexPath.row];
//    cell.medicineDose.text = (NSString *)[_data2 objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Display medication
    NSString *medName = (NSString *)[_data1 objectAtIndex:indexPath.row];
    NSString *dosage = (NSString *)[_data2 objectAtIndex:indexPath.row];
    _medicineField.text = [NSString stringWithFormat:@"%@ %@", medName, dosage];
    
    NSMutableDictionary *prescriptionData = [[NSMutableDictionary alloc] init];
    [prescriptionData setObject:(NSString *)[_data1 objectAtIndex:indexPath.row] forKey:@"medicationID"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MOVE_FROM_SEARCH_FOR_MEDICINE object:prescriptionData];
//    [[NSNotificationCenter defaultCenter] postNotificationName:MOVE_FROM_SEARCH_FOR_MEDICINE object:nil];
}

// Hides keyboard when whitespace is pressed
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
