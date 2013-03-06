//
//  GenericStartViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 3/6/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "GenericStartViewController.h"
#import "TriagePatientViewController.h"
#import "DoctorPatientViewController.h"
#import "PharmacyPatientViewController.h"

@interface GenericStartViewController ()

@end

@implementation GenericStartViewController

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
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor clearColor]];
    
    // Rotate table horizontally (-90 degrees)
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);
    _tableView.rowHeight = 768;
    _tableView.transform = transform;
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.frame = self.view.frame;
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    // Create controllers for each view
    _registerControl = [self getViewControllerFromiPadStoryboardWithName:@"registerPatientViewController"];
    _searchControl = [self getViewControllerFromiPadStoryboardWithName:@"searchPatientViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setToolbar:nil];
    [self setSegmentedControl:nil];
    [super viewDidUnload];
}
@end
