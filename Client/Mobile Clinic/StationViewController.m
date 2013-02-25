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
//    PatientObject* myPatient = [[PatientObject alloc]initWithNewPatient];
//    
//    VisitationObject* myVisit = [[VisitationObject alloc]initWithNewVisit];
//    
//    [myVisit setObject:@"Fake Diagnosis Notes" withAttribute:DNOTES];
//    [myVisit setObject:@"Fake Diagnosis Title" withAttribute:DTITLE];
//    [myVisit setObject:@"Fake Complaint" withAttribute:COMPLAINT];
//    [myVisit setObject:[NSDate date] withAttribute:CHECKIN];
//    [myVisit setObject:[NSDate date] withAttribute:CHECKOUT];
//    [myVisit setObject:@"FakeVisitID" withAttribute:VISITID];
//    
//    [myPatient setObject:@"Tuba" withAttribute:FIRSTNAME];
//    [myPatient setObject:@"Jubu" withAttribute:FAMILYNAME];
//    [myPatient setObject:@"Pufu" withAttribute:VILLAGE];
//    
//    [myPatient addVisitToCurrentPatient:myVisit];
//    
//    [myPatient createNewPatient:^(id<BaseObjectProtocol> data, NSError *error) {
//        PatientObject* p = data;
//        NSLog(@"Save Complete: %@",[p description]);
//    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logout:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:LOGOFF object:nil];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
//    #warning Create validation for users that have the potential to go into areas they are not allowed
//    
//    id potentialDestination = segue.destinationViewController;
//    id <StationViewHandlerProtocol>destination;
//    
//    if ([potentialDestination isKindOfClass:[UINavigationController class]]) {
//        UINavigationController* navCtrl = potentialDestination;
//        destination = [navCtrl.viewControllers lastObject];
//    }else{
//        destination = potentialDestination;
//    }
//    
//    [destination setScreenHandler:^(id object, NSError *error) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
}

@end
