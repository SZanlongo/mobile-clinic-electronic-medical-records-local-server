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
    
    
    NSDictionary * patientDic = [_patientData objectForKey:OPEN_VISITS_PATIENT];
    
    id data = [patientDic objectForKey:PICTURE];
    [_patientPhoto setImage:[UIImage imageWithData:([data isKindOfClass:[NSData class]])?data:nil]];
    
    _patientNameField.text = [patientDic objectForKey:FIRSTNAME];
    _familyNameField.text = [patientDic objectForKey:FAMILYNAME];
    _villageNameField.text = [patientDic objectForKey:VILLAGE];
    _patientAgeField.text = [NSString stringWithFormat:@"%i",[[patientDic objectForKey:DOB]getNumberOfYearsElapseFromDate]];
    _patientSexField.text = ([patientDic objectForKey:SEX]==0)?@"Female":@"Male";

    MobileClinicFacade * mobileFacede = [[MobileClinicFacade alloc]init];
    [mobileFacede findAllPrescriptionForCurrentVisit:_visitationData AndOnCompletion:^(NSArray *allObjectsFromSearch, NSError *error) {
        self.prescriptions = allObjectsFromSearch;
        [mobileFacede findAllMedication:nil AndOnCompletion:^(NSArray *allObjectsFromSearch, NSError *error) {
            NSMutableString * myPredicate = [[NSMutableString alloc]init];
            for(int i = 0; i < [self.prescriptions count]; i++){
                NSDictionary * dic = [self.prescriptions objectAtIndex:i];
                [myPredicate appendFormat:@" %@ != %@ ",MEDICATIONID,[[self.prescriptions objectAtIndex:i] objectForKey:MEDICATIONID]];
                
                if (i+1 != [self.prescriptions count]) {
                    [myPredicate appendString:@" && "];
                }
            }
            [allObjectsFromSearch filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:myPredicate]];
            self.medName = [[allObjectsFromSearch objectAtIndex:0] objectForKey:MEDNAME];
            [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }];
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
    return self.prescriptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * currentVisitCellIdentifier = @"prescriptionCell";
    
        PharmacyPrescriptionCell * cell = [tableView dequeueReusableCellWithIdentifier:currentVisitCellIdentifier];
    
        if (!cell) {
            cell = [[PharmacyPrescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:currentVisitCellIdentifier];
            
            cell.viewController = [self getViewControllerFromiPadStoryboardWithName:@"PharmacyPrescriptionViewController"];
        }
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(-20, -15, 768, 700);
    
    if([[[self.prescriptions objectAtIndex:indexPath.row] objectForKey:TIMEOFDAY] integerValue] == 0){
        [cell.viewController.timeOfDayButton setBackgroundImage:[UIImage imageNamed:@"morning"] forState:UIControlStateDisabled];
        cell.viewController.timeOfDayLabel.text = @"Morning";
    }
    else if([[[self.prescriptions objectAtIndex:indexPath.row] objectForKey:TIMEOFDAY] integerValue] == 1){
            [cell.viewController.timeOfDayButton setBackgroundImage:[UIImage imageNamed:@"afternoon"] forState:UIControlStateDisabled];
        cell.viewController.timeOfDayLabel.text = @"Afternoon";
    }
    else if([[[self.prescriptions objectAtIndex:indexPath.row] objectForKey:TIMEOFDAY] integerValue] == 2){
        [cell.viewController.timeOfDayButton setBackgroundImage:[UIImage imageNamed:@"evening"] forState:UIControlStateDisabled];
        cell.viewController.timeOfDayLabel.text = @"Evening";
    }
    else if([[[self.prescriptions objectAtIndex:indexPath.row] objectForKey:TIMEOFDAY] integerValue] == 3){
        [cell.viewController.timeOfDayButton setBackgroundImage:[UIImage imageNamed:@"night"] forState:UIControlStateDisabled];
        cell.viewController.timeOfDayLabel.text = @"Night";
    }
    
    
    cell.viewController.drugNameLabel.text = self.medName;

    cell.viewController.numberOfPrescriptionLabel.text = [[self.prescriptions objectAtIndex:indexPath.row] objectForKey:TABLEPERDAY];
    
        for(UIView *mView in [cell.contentView subviews]) {
            [mView removeFromSuperview];
        }
        
        [cell addSubview:cell.viewController.view];
        
        return cell;
}

// Hides keyboard when whitespace is pressed
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)checkoutPatient:(id)sender {
}

- (void)setScreenHandler:(ScreenHandler)myHandler {
    handler = myHandler;
}

@end
