//
//  DateController.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "DateController.h"
#import "DataProcessor.h"
@interface DateController ()

@end

@implementation DateController

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
    [_datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
	// Do any additional setup after loading the view.
}
- (IBAction)saveNewDate:(id)sender {
    handler(_datePicker.date,nil);
    [_datePicker removeTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
}

-(void)setScreenHandler:(ScreenHandler)screenDelegate{
    handler = screenDelegate;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dateChanged{
    [_dateLbl setText:[NSString stringWithFormat:@"%i Years Old",_datePicker.date.getNumberOfYearsElapseFromDate]];
}
- (void)viewDidUnload {
    [self setDatePicker:nil];
    [self setDateLbl:nil];
    [super viewDidUnload];
}
@end
