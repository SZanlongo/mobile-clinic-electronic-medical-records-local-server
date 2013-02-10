//
//  FIUSearchViewController.h
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FIUSearchPatientViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
- (IBAction)searchByNameButton:(id)sender;
- (IBAction)searchByNFCButton:(id)sender;
- (IBAction)searchByFingerprintButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *patientResultTableView;


@end
