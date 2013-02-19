//
//  CreateNewUserViewController.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/4/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObject.h"
typedef void (^HowToReturn)(BOOL succesfull);
@interface CreateNewUserViewController : UIViewController{
    HowToReturn returnHandler;
}

@property (strong, nonatomic) UserObject* user;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userType;
@property (weak, nonatomic) IBOutlet UITextField *firstname;
@property (weak, nonatomic) IBOutlet UITextField *lastname;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *initialPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

- (IBAction)createNewUser:(id)sender;
- (IBAction)cancelProcess:(id)sender;

// This needs to be called after instatiating this class!!!!
// You have to instruct this screen how to disappear when done
- (void)setReturnHandler:(HowToReturn)handler;

@end
