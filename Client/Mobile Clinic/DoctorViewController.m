//
//  DoctorViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/22/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "DoctorViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
}

@end
