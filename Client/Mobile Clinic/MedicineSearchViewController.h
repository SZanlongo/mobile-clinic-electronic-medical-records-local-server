//
//  MedicineSearchViewController.h
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/24/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicineSearchViewController : UIViewController
- (IBAction)moveBackToPrescription:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *medicineField;
- (IBAction)searchMedicine:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
