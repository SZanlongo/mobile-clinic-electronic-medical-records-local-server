//
//  FIULoginViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "ServerCore.h"
#import "FIULoginViewController.h"
#import "CreateNewUserViewController.h"
#import "UserObject.h"


@interface FIULoginViewController ()

@end

@implementation FIULoginViewController
@synthesize user;
- (id)init
{
    self = [super init];
    if (self) {
        if (!user) {
            user = [[UserObject alloc]init];
        }
    }
    return self;
}
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
-(void)viewWillAppear:(BOOL)animated{
    user = [[UserObject alloc]init];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserNameField:nil];
    [self setUserNameField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
}

/* If you want to login, use the following information (case-sensitive)
 * Username: mick
 * Password: 616
 */
- (IBAction)loginButton:(id)sender {
    [user setUsername: _userNameField.text];
    [user setPassword:_passwordField.text];

    [user login:^(id<BaseObjectProtocol> data, NSError* error) {

        if (!error) {
            id navCtrl = [self getViewControllerFromiPadStoryboardWithName:@"mainNavigationController"];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogOffDevice) name:LOGOFF object:nil];
            [self presentViewController:navCtrl animated:YES completion:^{
                
                [FIUAppDelegate getNotificationWithColor:AJNotificationTypeGreen Animation:AJLinedBackgroundTypeAnimated WithMessage:@"You Succesfully Logged In"];
            }];
        }else{
            [FIUAppDelegate getNotificationWithColor:AJNotificationTypeRed Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription inView:self.view];
        }
        
    }];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id var = segue.destinationViewController;
    
    if ([var isKindOfClass:[CreateNewUserViewController class]]) {
        CreateNewUserViewController* dvc = var;
        if ([dvc view]) {
            [dvc setReturnHandler:^(BOOL succesfull) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                    if (succesfull)
                    {
                        [FIUAppDelegate getNotificationWithColor:AJNotificationTypeDefault Animation:AJLinedBackgroundTypeAnimated WithMessage:@"The application administrator needs to verify your account"];
                    }
                }];
            }];
            
            dvc.user = user;
        }
    }
}

-(void)LogOffDevice{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
