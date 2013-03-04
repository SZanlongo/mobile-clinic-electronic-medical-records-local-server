//
//  CurrentVisitViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "CurrentVisitViewController.h"
#import "MobileClinicFacade.h"
@interface CurrentVisitViewController ()

@end

@implementation CurrentVisitViewController

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
    currentVisit = [[NSMutableDictionary alloc]initWithCapacity:10];
    [currentVisit setValue:[NSDate date] forKey:TRIAGEIN];

}

- (void)viewWillAppear:(BOOL)animated {
}

// Assigns patientData from Notification
- (void)assignPatientData:(NSNotification *)note {
    _patientData = note.object;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPatientWeightField:nil];
    [self setPatientBPField:nil];
    [self setConditionsTextbox:nil];
    [super viewDidUnload];
}

// Creates a visit for the patient and checks them in
- (IBAction)checkInButton:(id)sender {
    // Assigning vitals & condition
    
    MobileClinicFacade* mobileFacade = [[MobileClinicFacade alloc]init];
    [currentVisit setValue:[NSNumber numberWithInt:[_patientWeightField.text intValue]] forKey:WEIGHT];
    [currentVisit setValue:_patientBPField.text forKey:BLOODPRESSURE];
    [currentVisit setValue:_conditionsTextbox.text forKey:CONDITION];
    [currentVisit setValue:[NSDate date] forKey:TRIAGEOUT];
    [currentVisit setValue:mobileFacade.GetCurrentUsername forKey:NURSEID];

    [mobileFacade addNewVisit:currentVisit ForCurrentPatient:_patientData onCompletion:^(NSDictionary *object, NSError *error) {
        if (!object) {
            [FIUAppDelegate getNotificationWithColor:AJNotificationTypeOrange Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription inView:self.view];
        }else{
            handler(object,error);
        }
    }];
}

// Allows nurse to check-out a patient without going thru doctor/pharmacy
- (IBAction)quickCheckOutButton:(id)sender {
    
}

-(void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
}

@end
