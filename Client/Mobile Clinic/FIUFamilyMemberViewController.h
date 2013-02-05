//
//  FIUFamilyMemberViewController.h
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FIUFamilyMemberViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *patientSearchField;
@property (weak, nonatomic) IBOutlet UITableView *patientSearchTable;
@property (weak, nonatomic) IBOutlet UITableView *familyMembersTable;
- (IBAction)patientSearchButton:(id)sender;

@end
