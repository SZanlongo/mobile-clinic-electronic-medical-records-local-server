//
//  FIULoginViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObject.h"
@interface FIULoginViewController : UIViewController

@property (strong, nonatomic) UserObject *user;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)loginButton:(id)sender;

@end
