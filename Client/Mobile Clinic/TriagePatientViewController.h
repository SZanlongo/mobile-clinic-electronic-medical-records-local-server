//
//  TriagePatientViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TriagePatientViewController : UIViewController

//Patient Info Labels
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *villageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientSexLabel;

//Vitals Labels
@property (weak, nonatomic) IBOutlet UILabel *patientWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientBPLabel;

@end
