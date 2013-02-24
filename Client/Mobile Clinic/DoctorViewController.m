//
//  DoctorViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "DoctorViewController.h"
#import "DoctorPatientViewController.h"

@interface DoctorViewController ()

@end

@implementation DoctorViewController

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
    [bar setTintColor:[UIColor blueColor]];
    
    _tableView.rowHeight = 960;
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    // Create controller for search
    _control = [self getViewControllerFromiPadStoryboardWithName:@"searchPatientViewController"];
    
    [_control.patientFound addTarget:self action:@selector(searchPatient) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)searchPatient{
    PatientObject * newPatient = _control.patientData;
    [self performSegueWithIdentifier:@"doctorPatientViewController" sender:newPatient];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * searchCellIdentifier = @"searchCell";
    
    SearchPatientTableCell * cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
    
    cell = [[SearchPatientTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellIdentifier];
    
    cell.viewController = _control;
    
    [cell addSubview: cell.viewController.view];
    
    return cell;    
}

-(void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
}

@end
