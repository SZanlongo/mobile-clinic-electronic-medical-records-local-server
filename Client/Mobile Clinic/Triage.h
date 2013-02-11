//
//  Triage.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/7/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FIUPatientRegistrationViewController.h"
@interface Triage : UIViewController{
    UIPopoverController* popover;

}
@property(nonatomic, strong)PatientObject* patient;

- (IBAction)logout:(id)sender;
- (IBAction)CreateNewPatient:(id)sender;
@end
