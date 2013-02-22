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
    _username.text = _user.user.username;
   
    if (!_user) {
        _user = [[UserObject alloc]initWithNewUser];
    }
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
        _user.user.username = _username.text;
        _user.user.password = _confirmPassword.text;
        _user.user.email = _email.text;
        _user.user.firstname = _firstname.text;
        _user.user.lastname = _lastname.text;
        _user.user.status = NO;
        _user.user.usertype = [NSNumber numberWithInt:_userType.selectedSegmentIndex];
        
//        [_user CreateANewUser:^(id<BaseObjectProtocol> data, NSError* error) {
//            if (!error) {
//                // Exit off the page
//                 returnHandler(YES);
//            }else{
//                // Create error Message 
//                [self displayErrorWithMessage:error.localizedDescription];
//            }
//        }];
    }else{
        [self displayErrorWithMessage:@"Passwords are not the same"];
    }
    
    
}
-(void)displayErrorWithMessage:(NSString*)message{
    [FIUAppDelegate getNotificationWithColor:AJNotificationTypeOrange Animation:AJLinedBackgroundTypeAnimated WithMessage:message];
}

- (IBAction)cancelProcess:(id)sender {
    returnHandler(NO);
}
@end
