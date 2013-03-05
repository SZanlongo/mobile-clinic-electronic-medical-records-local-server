//
//  SearchPatientViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenNavigationDelegate.h"
#import "PatientResultTableCell.h"

typedef enum MobileClinicMode{
    kTriageMode,
    kDoctorMode,
    kPharmacistMode
} MCMode;

@interface SearchPatientViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    ScreenHandler handler;
    BOOL shouldDismiss;
}
@property (assign) MCMode mode;
@property (nonatomic, strong) NSMutableDictionary * patientData;
@property (nonatomic, strong) NSArray * patientSearchResultsArray;

@property (strong, nonatomic) IBOutlet UITextField *patientNameField;
@property (strong, nonatomic) IBOutlet UITextField *familyNameField;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;

@property (strong, nonatomic) UIButton *patientFound;

- (IBAction)searchByNameButton:(id)sender;
- (IBAction)searchByNFCButton:(id)sender;
- (IBAction)searchByFingerprintButton:(id)sender;

- (void)setScreenHandler:(ScreenHandler) myHandler;
-(void)resetData;
@end