//
//  MedicineSearchViewController.h
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/24/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicineSearchResultCell.h"

@interface MedicineSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
- (IBAction)moveBackToPrescription:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *medicineField;
- (IBAction)searchMedicine:(id)sender;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * data;
@property (strong, nonatomic) NSMutableArray * data2;

@end
