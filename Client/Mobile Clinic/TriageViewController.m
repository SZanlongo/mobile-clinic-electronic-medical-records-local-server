//
//  TriageViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "TriageViewController.h"
#import "RegisterPatientTableCell.h"
#import "SearchPatientViewController.h"
#import "SearchPatientTableCell.h"

@interface TriageViewController (){
    PatientObject * p;
    RegisterPatientViewController * control;
    SearchPatientViewController * control_2;
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);
    _tableView.rowHeight = 768;
    _tableView.transform = transform;
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    control = [([UIStoryboard storyboardWithName:@"NewStoryboard"
                                          bundle: nil]) instantiateViewControllerWithIdentifier:@"registerViewController"];
    if([control view]){
        [control.createPatientButton addTarget:self action:@selector(createPatient) forControlEvents:UIControlEventTouchUpInside];
    }
    
    control_2 = [([UIStoryboard storyboardWithName:@"NewStoryboard"
                                            bundle: nil]) instantiateViewControllerWithIdentifier:@"searchViewController"];
    
    if([control_2 view]){
        [control_2.patientFound addTarget:self action:@selector(searchPatient) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)createPatient{
    PatientObject * bob = [control createPatient];
    [self performSegueWithIdentifier:@"someIden" sender:bob];
}

-(void)searchPatient{
    PatientObject * bob = control_2.patientData;
    [self performSegueWithIdentifier:@"semeIden" sender:bob];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setToolBar:nil];
    [self setViewSelectorSegment:nil];
    [super viewDidUnload];
}
- (IBAction)viewSelectorSegment:(id)sender {
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
    
    if(indexPath.item == 0){
        RegisterPatientTableCell * cell = [tableView dequeueReusableCellWithIdentifier:registerCellIdentifier];
        
        if(!cell){
            cell = [[RegisterPatientTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:registerCellIdentifier];
            
            cell.viewController = control;
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
    else{
        SearchPatientTableCell * cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
            
        if(!cell){
            cell = [[SearchPatientTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellIdentifier];
                
            cell.viewController = control_2;
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
