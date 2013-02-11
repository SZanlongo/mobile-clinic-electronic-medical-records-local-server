//
//  Triage.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/7/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "Triage.h"

@interface Triage ()

@end

@implementation Triage

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

- (IBAction)logout:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:LOGOFF object:nil];
}

- (IBAction)CreateNewPatient:(id)sender {
    
    UIButton* button = sender;
    
    FIUPatientRegistrationViewController* vc = [self getViewControllerFromiPadStoryboardWithName:@"Registration"];
    [vc setScreenHandler:^(id object, NSError *error) {
        //Should check for when the error is true
        [popover dismissPopoverAnimated:YES];
        
        // if there was no error and there is an object
        // redisplay information
        if (object) {
            //Redisplay Method here
        }
    }];
   // when creating a new patient, it needs to be nil
    [vc setPatient:nil];
    
    popover = [[UIPopoverController alloc]initWithContentViewController:vc];
    
    [popover setDelegate:vc];
    
    [popover presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
@end
