//
//  CreateNewUserViewController.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/4/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "CreateNewUserViewController.h"

@interface CreateNewUserViewController ()

@end

@implementation CreateNewUserViewController

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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _username.text = _user.username;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setReturnHandler:(HowToReturn)handler{
    returnHandler = handler;
}

- (void)viewDidUnload {
    [self setUserType:nil];
    [self setFirstname:nil];
    [self setLastname:nil];
    [self setEmail:nil];
    [self setUsername:nil];
    [self setInitialPassword:nil];
    [self setConfirmPassword:nil];
    [super viewDidUnload];
}

- (IBAction)createNewUser:(id)sender {
    if ([_initialPassword.text isEqualToString:_confirmPassword.text]) {
        _user.username = _username.text;
        _user.password = _confirmPassword.text;
        _user.email = _email.text;
        _user.firstname = _firstname.text;
        _user.lastname = _lastname.text;
        _user.status = NO;
        _user.type = [self getUserType];
        
        [_user CreateANewUser:^(id<BaseObjectProtocol> data, NSError* error) {
            if (!error) {
                // Exit off the page
                 returnHandler(YES);
            }else{
                // Create error Message 
                [self displayErrorWithMessage:error.localizedDescription];
            }
        }];
    }else{
        [self displayErrorWithMessage:@"Passwords are not the same"];
    }
    
    
}
-(void)displayErrorWithMessage:(NSString*)message{
    [FIUAppDelegate getNotificationWithColor:AJNotificationTypeOrange Animation:AJLinedBackgroundTypeAnimated WithMessage:message];
}
-(UserTypes)getUserType{
    switch (_userType.selectedSegmentIndex) {
        case kTriageNurse:
            return kTriageNurse;
            break;
        case kDoctor:
            return kDoctor;
            break;
        case kAppAdmin:
            return kAppAdmin;
            break;
        case kPharmacist:
            return kPharmacist;
            break;
        case kRecordKeeper:
            return kRecordKeeper;
            break;
        default:
            return kTriageNurse;
            break;
    }
}
- (IBAction)cancelProcess:(id)sender {
    returnHandler(NO);
}
@end
