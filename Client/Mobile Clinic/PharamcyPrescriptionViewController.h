//
//  PharamcyPrescriptionViewController.h
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/24/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PharamcyPrescriptionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tabletsTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeOfDayTextFields;
@property (weak, nonatomic) IBOutlet UITextField *drugTextField;
- (IBAction)findDrugs:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *timeOfDayButtons;
- (IBAction)newTimeOfDay:(id)sender;

@end
