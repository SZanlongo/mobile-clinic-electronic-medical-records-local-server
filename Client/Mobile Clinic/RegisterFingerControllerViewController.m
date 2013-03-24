//
//  RegisterFingerControllerViewController.m
//  Mobile Clinic
//
//  Created by Carlos Corvaia on 3/23/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "RegisterFingerControllerViewController.h"

@interface RegisterFingerControllerViewController ()

@end

@implementation RegisterFingerControllerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(150.0, 140.0);
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
