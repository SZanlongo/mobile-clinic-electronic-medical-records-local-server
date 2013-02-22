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
    
    // Rotate table horizontally (90 degrees)
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);
    _tableView.rowHeight = 768;
    _tableView.transform = transform;
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    // Create controllers for each view (Search & Register)
//    _control2 = [([UIStoryboard storyboardWithName:@"NewStoryboard" bundle: nil]) instantiateViewControllerWithIdentifier:@"searchPatientViewController"];
    
    _control1 = [self getViewControllerFromiPadStoryboardWithName:@"registerPatientViewController"];
    _control2 = [self getViewControllerFromiPadStoryboardWithName:@"searchPatientViewController"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createPatient:) name:CREATE_NEW_PATIENT object:_patientData];
//    if([_control1 view])
//        [_control1.createPatientButton addTarget:self action:@selector(createPatient) forControlEvents:UIControlEventTouchUpInside];
    
    if([_control2 view])
        [_control2.patientFound addTarget:self action:@selector(searchPatient) forControlEvents:UIControlEventTouchUpInside];
}

-(void)createPatient:(NSNotification *)note {
    _patientData = note.object;
    
    TriagePatientViewController *newView = [self getViewControllerFromiPadStoryboardWithName:@"triagePatientViewController"];
    
    newView.patientData = _patientData;
    
    [self.navigationController pushViewController:newView animated:YES];
    
//    PatientObject * newPatient = [_control1 createPatient];
//    [self performSegueWithIdentifier:@"triagePatientViewController" sender:_patientData];
}

-(void)searchPatient{
    PatientObject * newPatient = _control2.patientData;
    [self performSegueWithIdentifier:@"triagePatientViewController" sender:newPatient];
}


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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * registerCellIdentifier = @"registerCell";
    static NSString * searchCellIdentifier = @"searchCell";
    
    if(indexPath.item == 0) {
        RegisterPatientTableCell * cell = [tableView dequeueReusableCellWithIdentifier:registerCellIdentifier];
        
        if(!cell){
            cell = [[RegisterPatientTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:registerCellIdentifier];
            
            cell.viewController = _control1;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(0, 0, 916, 768);
        
        for(UIView *mView in [cell.contentView subviews]){
            [mView removeFromSuperview];
        }
        
        [cell addSubview: cell.viewController.view];
        [cell.viewController setScreenHandler:handler];
        return cell;
    }
    else {
        SearchPatientTableCell * cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
            
        if(!cell){
            cell = [[SearchPatientTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellIdentifier];
                
            cell.viewController = _control2;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(0, 0, 916, 768);

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

@end
