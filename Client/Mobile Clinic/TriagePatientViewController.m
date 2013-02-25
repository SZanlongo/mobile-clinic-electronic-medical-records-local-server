//
//  TriagePatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "TriagePatientViewController.h"
#import "TriageViewController.h"

@interface TriagePatientViewController ()

@end

@implementation TriagePatientViewController

@synthesize segmentedControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UINavigationBar *bar =[self.navigationController navigationBar];
    [bar setTintColor:[UIColor orangeColor]];
    
    // Rotate table horizontally (90 degrees)
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);
    _tableView.rowHeight = 768;
    _tableView.transform = transform;
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // Create controllers for each view (Previous Visits & current visit)
    
    _control1 = [self getViewControllerFromiPadStoryboardWithName:@"currentVisitViewController"];
    _control2 = [self getViewControllerFromiPadStoryboardWithName:@"previousVisitsViewController"];
    if([_control1 view]){
//    _control1.visitationObject.triageIn = timestamp;
//    _control1.visitationObject.patientId = self.patientData.patient.patientId;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    _patientNameField.text = _patientData.patient.firstName;
    _familyNameField.text = _patientData.patient.familyName;
    _villageNameField.text = _patientData.patient.villageName;
//    _patientAgeField.text = ;
    _patientSexField.text = [_patientData getSex:_patientData.patient.sex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setToolBar:nil];
    [self setPatientNameField:nil];
    [self setFamilyNameField:nil];
    [self setVillageNameField:nil];
    [self setPatientAgeField:nil];
    [self setPatientSexField:nil];
    [super viewDidUnload];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * currentVisitCellIdentifier = @"currentVisitCell";
    static NSString * previousVisitsCellIdentifier = @"previousVisitsCell";
    
    if(indexPath.item == 0) {
        CurrentVisitTableCell * cell = [tableView dequeueReusableCellWithIdentifier:currentVisitCellIdentifier];
        
        if (!cell) {
            cell = [[CurrentVisitTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:currentVisitCellIdentifier];
            
            cell.viewController = _control1;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(0, 0, 768, 685);
//        cell.viewController.view.frame = CGRectMake(0, 0, 685, 768);
//        cell.viewController.view.frame = CGRectMake(0, 0, 916, 768);
        
        for(UIView *mView in [cell.contentView subviews]){
            [mView removeFromSuperview];
        }
        
        [cell addSubview:cell.viewController.view];
        [cell.viewController setScreenHandler:handler];
        
        return cell;
    }
    else {
        PreviousVisitsTableCell * cell = [tableView dequeueReusableCellWithIdentifier:previousVisitsCellIdentifier];
        
        if(!cell){
            cell = [[PreviousVisitsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:previousVisitsCellIdentifier];
            
            cell.viewController = _control2;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(0, 0, 768, 685);
//        cell.viewController.view.frame = CGRectMake(0, 0, 916, 768);
        
        for(UIView *mView in [cell.contentView subviews]){
            [mView removeFromSuperview];
        }
        
        [cell addSubview: cell.viewController.view];
        
        return cell;
    }
}

-(void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
}

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

@end
