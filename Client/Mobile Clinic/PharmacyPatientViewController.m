//
//  PharmacyPatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/24/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "MobileClinicFacade.h"
#import "PharmacyPatientViewController.h"

@interface PharmacyPatientViewController ()

@end

@implementation PharmacyPatientViewController

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
    
    // Rotate table horizontally (-90 degrees)
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);
    _tableView.rowHeight = 768;
    _tableView.transform = transform;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [_tableView setScrollEnabled:NO];

    
    _precriptionViewController = [self getViewControllerFromiPadStoryboardWithName:@"prescriptionFormViewController"];
    [_precriptionViewController view];
    [_precriptionViewController deactivateControllerFields];
    _medicineViewController = [self getViewControllerFromiPadStoryboardWithName:@"searchMedicineViewController"];
    [_medicineViewController view];

    _patientNameField.text = [_patientData objectForKey:FIRSTNAME];
    _familyNameField.text = [_patientData objectForKey:FAMILYNAME];
    _villageNameField.text = [_patientData objectForKey:VILLAGE];
    _patientAgeField.text = [NSString stringWithFormat:@"%i",[[_patientData objectForKey:DOB]getNumberOfYearsElapseFromDate]];
    _patientSexField.text = ([_patientData objectForKey:SEX]==0)?@"Female":@"Male";
    id data = [_patientData objectForKey:PICTURE];
    [_patientPhoto setImage:[UIImage imageWithData:([data isKindOfClass:[NSData class]])?data:nil]];
    
    MobileClinicFacade * mobileFacede = [[MobileClinicFacade alloc]init];
    [mobileFacede findAllPrescriptionForCurrentVisit:_visitationData AndOnCompletion:^(NSArray *allObjectsFromSearch, NSError *error) {
        _prescriptionData = [allObjectsFromSearch objectAtIndex:0];
        [_precriptionViewController setPatientData:_patientData];
        [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPatientNameField:nil];
    [self setFamilyNameField:nil];
    [self setVillageNameField:nil];
    [self setPatientAgeField:nil];
    [self setPatientSexField:nil];
    [self setPatientPhoto:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * currentVisitCellIdentifier = @"prescriptionCell";
//    static NSString * previousVisitsCellIdentifier = @"medicineSearchCell";
    
//    if(indexPath.item == 0) {
        PharamcyPrescriptionCell * cell = [tableView dequeueReusableCellWithIdentifier:currentVisitCellIdentifier];
        
        if (!cell) {
            cell = [[PharamcyPrescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:currentVisitCellIdentifier];
            cell.viewController = _precriptionViewController;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(-20, -15, 768, 700);
        
        for(UIView *mView in [cell.contentView subviews]) {
            [mView removeFromSuperview];
        }
        
        [cell addSubview:cell.viewController.view];
        
        return cell;

}


-(void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
}
@end
