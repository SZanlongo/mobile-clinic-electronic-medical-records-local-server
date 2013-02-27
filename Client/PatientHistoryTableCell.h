//
//  PatientHistoryTableCell.h
//  Mobile Clinic
//
//  Created by Rigo Hernandez on 2/25/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientHistoryTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *patientDOBLabel;
//@property (weak, nonatomic) IBOutlet UILabel *patientAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientBPLabel;
@property (weak, nonatomic) IBOutlet UITextView *patientConditionsTextView;
@property (weak, nonatomic) IBOutlet UITextView *patientMedicationTextView;

@end
