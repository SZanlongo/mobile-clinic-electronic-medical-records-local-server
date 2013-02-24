//
//  TriagePatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "TriagePatientViewController.h"

@interface TriagePatientViewController ()

@end

@implementation TriagePatientViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Populate the patient's data to the static text fields (top of screen)
    _patientNameField.text = _patientData.patient.firstName;
    _familyNameField.text = _patientData.patient.familyName;
    _villageNameField.text = _patientData.patient.villageName;
    _patientSexField.text = [_patientData getSex:_patientData.patient.sex];
    
    // Rotate table horizontally (-90 degrees)
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);
    _tableView.rowHeight = 768;
    _tableView.transform = transform;
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    // Create controllers for each view (Search & Register)
    _currentVisitControl = [self getViewControllerFromiPadStoryboardWithName:@"currentVisitVC"];
    _previousVisitControl = [self getViewControllerFromiPadStoryboardWithName:@"previousVisitsVC"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPatientNameField:nil];
    [self setFamilyNameField:nil];
    [self setVillageNameField:nil];
    [self setPatientAgeButton:nil];
    [self setPatientSexField:nil];
    [self setPatientWeightLabel:nil];
    [self setPatientBPLabel:nil];
    [self setTableView:nil];
    [self setToolBar:nil];
    [self setSegmentedControl:nil];
    [super viewDidUnload];
}

// Defines number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Defines number of cells in table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

// Defines the cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    static NSString * currentVisitCellIdentifier = @"currentVisitCell";
    static NSString * previousVisitsCellIdentifier = @"previousVisitsCell";
    
    if(indexPath.row == 0)
    {
        CurrentVisitTableCell * cell = [tableView dequeueReusableCellWithIdentifier:currentVisitCellIdentifier];
        
        // Instantiate cell for appropriate view
        if(!cell) {
            cell = [[CurrentVisitTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:currentVisitCellIdentifier];
            cell.viewController = _currentVisitControl;
        }
        
        // Rotate view vertically on the screen
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(0, 0, 685, 768);
    
        // Remove previous view (for memory mgmt)
        for(UIView *mView in [cell.contentView subviews]) {
            [mView removeFromSuperview];
        }
        
        //Populate view in cell
        [cell.contentView addSubview:cell.viewController.view];
//        [cell.viewController setScreenHandler:handler];         // NOT SURE WHAT THIS DOES
        
        _segmentedControl.selectedSegmentIndex = 0;
        
        return cell;
    }
    else {
        PreviousVisitTableCell * cell = [tableView dequeueReusableCellWithIdentifier:previousVisitsCellIdentifier];
        
        // Instantiate cell for appropriate view
        if(!cell) {
            cell = [[PreviousVisitTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:previousVisitsCellIdentifier];
            cell.viewController = _previousVisitControl;
        }
        
        // Rotate cell vertically on the screen
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(384, 574, 768, 685);
        
        // Removes previous view (for memory mgmt)
        for(UIView *mView in [cell.contentView subviews]) {
            [mView removeFromSuperview];
        }
        
        // Populate views in cell
        [cell addSubview:cell.viewController.view];
//        [cell.viewController setScreenHandler:handler];         // NOT SURE WHAT THIS DOES
        
        _segmentedControl.selectedSegmentIndex = 1;
        
        return cell;
    }
}

///* FROM SEBASTIAN */
//
//// Allows user to user segment to switch views (cells)
//- (IBAction) segmentedControlIndexChanged {
//    switch (self.segmentedControl.selectedSegmentIndex) {
//        case 0:
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//            break;
//        case 1:
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//            break;
//        default:
//            break;
//    }
//    
//    [self.tableView reloadData];
//}

//- (void)setScreenHandler:(ScreenHandler)myHandler {
//    handler = myHandler;
//}

@end
