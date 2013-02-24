//
//  TriageViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "TriageViewController.h"
#import "TriagePatientViewController.h"

@interface TriageViewController ()

@end

@implementation TriageViewController

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
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor orangeColor]];
    
    // Rotate table horizontally (-90 degrees)
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);
    _tableView.rowHeight = 768;
    _tableView.transform = transform;
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    // Create controllers for each view (Search & Register)
    _registerControl = [self getViewControllerFromiPadStoryboardWithName:@"registerPatientViewController"];
    _searchControl = [self getViewControllerFromiPadStoryboardWithName:@"searchPatientViewController"];
    
    // Notifications that receive patient data from registration & search view controllers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferPatientData:) name:CREATE_NEW_PATIENT object:_patientData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferPatientData:) name:SEARCH_FOR_PATIENT object:_patientData];
    
    [_registerControl.createPatientButton addTarget:self action:@selector(moveKay) forControlEvents:UIControlEventTouchUpInside];
    
    // Create a button that returns to root view controller
//    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self.navigationController.self action:@selector(popToRootViewControllerAnimated:)];
//    [self.navigationItem setLeftBarButtonItem:backButton];
}

-(void)moveKay{
    [self performSegueWithIdentifier:@"iWin" sender:_registerControl.patient];
}

// Transfers the patient's data to the next view controller
- (void)transferPatientData:(NSNotification *)note {
    _patientData = note.object;
    
    TriagePatientViewController *newView = [self getViewControllerFromiPadStoryboardWithName:@"triagePatientViewController"];
    
    newView.patientData = _patientData;
    
    [self.navigationController pushViewController:newView animated:YES];
}

//- (void)back {
//    [self.navigationController popToRootViewControllerAnimated:YES]
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setToolBar:nil];
    [super viewDidUnload];
}

// Defines number of sections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Defines number of cells in table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

// Defines the cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    static NSString * registerCellIdentifier = @"registerCell";
    static NSString * searchCellIdentifier = @"searchCell";
    
    if(indexPath.item == 0) {
        RegisterPatientTableCell * cell = [tableView dequeueReusableCellWithIdentifier:registerCellIdentifier];
        
        if(!cell) {
            cell = [[RegisterPatientTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:registerCellIdentifier];
            cell.viewController = _registerControl;
        }
        
        // Rotate view vertically on the screen
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(0, 0, 916, 768);
        
        // Removes previous view (for memory mgmt)
        for(UIView *mView in [cell.contentView subviews]){
            [mView removeFromSuperview];
        }
        
        // Populate view in cell
        [cell addSubview: cell.viewController.view];
        [cell.viewController setScreenHandler:handler];         // NOT SURE WHAT THIS DOES
        
        _segmentedControl.selectedSegmentIndex = 0;
        
        return cell;
    }
    else {
        SearchPatientTableCell * cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
        
        if(!cell) {
            cell = [[SearchPatientTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellIdentifier];
            cell.viewController = _searchControl;
        }
        
        // Rotate view vertically on the screen
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(0, 0, 916, 768);
        
        // Removes previous view (for memory mgmt)
        for(UIView *mView in [cell.contentView subviews]){
            [mView removeFromSuperview];
        }
        
        // Populate view in cell
        [cell addSubview: cell.viewController.view];
        [cell.viewController setScreenHandler:handler];         // NOT SURE WHAT THIS DOES
        
        _segmentedControl.selectedSegmentIndex = 1;
        
        return cell;
    }
}

// Allows user to user segment to switch views (cells)
- (IBAction) segmentedControlIndexChanged {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        case 1:
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (void)setScreenHandler:(ScreenHandler)myHandler {
    handler = myHandler;
}

@end
