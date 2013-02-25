//
//  LoginViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize usernameTextField,passwordTextField,user;

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

- (IBAction)loginButton:(id)sender {
    
    // if user doesn't exist, instantiate the user
    if (!user)
        user = [[UserObject alloc]initWithNewUser];
    
    // Attempt to login the user based on username and password
    [user loginWithUsername:usernameTextField.text andPassword:passwordTextField.text onCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
        if (error) {
            
            [FIUAppDelegate getNotificationWithColor:AJNotificationTypeRed Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription inView:self.view];
        }else{
            // Listens for the logout button
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogOffDevice) name:LOGOFF object:nil];
            [self navigateToMainScreen];
        }
    }];
    
}
-(void)LogOffDevice{
    [self dismissViewControllerAnimated:YES completion:^{
        // Stops listening
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }];
}
-(void)navigateToMainScreen{
    
    id screen = [self getViewControllerFromiPadStoryboardWithName:@"userSelectScreen"];
    [self presentViewController:screen animated:YES completion:nil];
}
- (void)viewDidUnload {
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
}
@end
