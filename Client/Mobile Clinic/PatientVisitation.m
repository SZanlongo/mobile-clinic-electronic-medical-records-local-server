//
//  PatientVisitation.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "PatientVisitation.h"

@interface PatientVisitation ()

@end

@implementation PatientVisitation

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
   // [_scrollView setContentSize:CGSizeMake(360, 800)];
   // [_scrollView setScrollEnabled:YES];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    return shouldDismiss;
}
-(void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
    shouldDismiss = NO;
}
-(void)cancelCommit:(id)sender{
    shouldDismiss = YES;
    handler(nil,nil);
}
- (void)viewDidUnload {
    [self setCommitDateLbl:nil];
    [self setComplaintField:nil];
    [self setDiagnosisInput:nil];
    [self setDiagnosisNoteField:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
