//
//  PharmacyPatientViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/24/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientObject.h"
#import "PharamcyPrescriptionViewController.h"
#import "PharamcyPrescriptionCell.h"
#import "MedicineSearchViewController.h"
#import "PrescriptionObject.h"
#import "MedicineSearchCell.h"

@interface PharmacyPatientViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) PatientObject * patientData;
@property (strong, nonatomic) PrescriptionObject * prescriptionData;
@property (weak, nonatomic) IBOutlet UITextField *patientName;
@property (weak, nonatomic) IBOutlet UITextField *familyName;
@property (weak, nonatomic) IBOutlet UITextField *villageName;
@property (weak, nonatomic) IBOutlet UIButton *patientAge;
@property (weak, nonatomic) IBOutlet UITextField *patientSex;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString * medName;

@property (nonatomic, strong) PharamcyPrescriptionViewController * precriptionViewController;
@property (nonatomic, strong) MedicineSearchViewController * medicineViewController;


@end