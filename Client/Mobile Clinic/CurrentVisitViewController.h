//
//  CurrentVisitViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentVisitViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *patientWeightField;
@property (strong, nonatomic) IBOutlet UITextField *patientBPField;
@property (strong, nonatomic) IBOutlet UITextView *patientConditionsTextbox;

- (IBAction)submitButton:(id)sender;

@end
