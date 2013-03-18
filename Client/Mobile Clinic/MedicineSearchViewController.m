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
    
    MobileClinicFacade* mobileFacade = [[MobileClinicFacade alloc]init];
    
    [mobileFacade findAllMedication:nil AndOnCompletion:^(NSArray *allObjectsFromSearch, NSError *error) {
        NSLog(@"All Medications:%@",allObjectsFromSearch.description);
        medicationArray = [NSArray arrayWithArray:allObjectsFromSearch];
       // [medicationArray filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K != nil",MEDNAME]];
        [self.tableView reloadData];
    }];
	// Do any additional setup after loading the view.
    
    // Request all medications in database

//    _data1 = [[NSMutableArray alloc] initWithObjects:@"Advil",@"Ibuprofen",@"Cephalexin",@"Ciprofloxacin",@"Doxycycline", nil];
//    _data2 = [[NSMutableArray alloc] initWithObjects:@"250mg",@"500mg",@"250mg",@"250mg",@"100mg", nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     
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
    return medicationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MedicineSearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:@"medicineResult"];

    if(!cell){
        cell = [[MedicineSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"medicineResult"];
        UINib * mNib = [UINib nibWithNibName:@"MedicineSearchResultView" bundle:nil];
        cell = [mNib instantiateWithOwner:nil options:nil][0];
    }

    NSDictionary *medDic = [medicationArray objectAtIndex:indexPath.row];
    
    cell.medicineName.text = [medDic objectForKey:MEDNAME];
    cell.medicineDose.text = [medDic objectForKey:DOSAGE];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Display get medication at the specified index
    NSDictionary *myDic = [medicationArray objectAtIndex:indexPath.row];
    
    // get desired values
    NSString *medName = [myDic objectForKey:MEDNAME];
    NSString *dosage = [myDic objectForKey:DOSAGE];
    
    // Construct a text
    _medicineField.text = [NSString stringWithFormat:@"%@ %@", medName, dosage];
    
    // Create PrescriptionObject
    NSMutableDictionary *prescriptionData = [[NSMutableDictionary alloc] init];
    
    // !!!: should reconsider implementation
    // Set Prescription data with medication ID
    [prescriptionData setValue:[myDic objectForKey:MEDICATIONID] forKey:MEDICATIONID];
    
    // Send prescription back
    [[NSNotificationCenter defaultCenter] postNotificationName:MOVE_FROM_SEARCH_FOR_MEDICINE object:prescriptionData];
}

// Hides keyboard when whitespace is pressed
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
