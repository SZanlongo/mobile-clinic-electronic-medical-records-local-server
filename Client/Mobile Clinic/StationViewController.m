//
//  StationViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#import "PatientObject.h"
#import "StationViewController.h"
#import "StationViewHandlerProtocol.h"
#import "GenericStartViewController.h"

@interface StationViewController ()

@end

@implementation StationViewController

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

-(void)viewWillAppear:(BOOL)animated {
    UINavigationBar *bar =[self.navigationController navigationBar];
    [bar setTintColor:[UIColor lightGrayColor]];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logout:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:LOGOFF object:nil];
}

- (IBAction)triageButton:(id)sender {
    [self goToGenericStart:1];
}

- (IBAction)doctorButton:(id)sender {
    [self goToGenericStart:2];
}

- (IBAction)pharmacyButton:(id)sender {
    [self goToGenericStart:3];
}

- (void)goToGenericStart:(int)station {
    GenericStartViewController *newView = [self getViewControllerFromiPadStoryboardWithName:@"genericStartViewController"];
    switch (station) {
        case 1:
            [newView setStationChosen:[NSNumber numberWithInt:1]];
            break;
        case 2:
            [newView setStationChosen:[NSNumber numberWithInt:2]];
            break;
        case 3:
            [newView setStationChosen:[NSNumber numberWithInt:3]];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:newView animated:YES];
}


@end
