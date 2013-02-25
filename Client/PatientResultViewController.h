//
//  PatientResultViewController.h
//  Mobile Clinic
//
//  Created by Rigo Hernandez on 2/23/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *patientPhoto;
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientDOBLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientAgeLabel;

@end
