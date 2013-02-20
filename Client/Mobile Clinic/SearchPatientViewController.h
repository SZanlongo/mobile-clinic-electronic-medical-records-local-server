//
//  SearchPatientViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientObject.h"
#import "ScreenNavigationDelegate.h"

@interface SearchPatientViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    ScreenHandler handler;
    BOOL shouldDismiss;
}

@property (nonatomic, strong) NSArray* patientSearchResultsArray;
@property (nonatomic, strong) PatientObject *patientData;

@property (strong, nonatomic) IBOutlet UITextField *patientNameField;
@property (strong, nonatomic) IBOutlet UITextField *familyNameField;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;

@property (strong, nonatomic) UIButton * patientFound;

- (void)setScreenHandler:(ScreenHandler) myHandler;
//- (IBAction)cancelSearching:(id)sender;

- (IBAction)searchByNameButton:(id)sender;
- (IBAction)searchByNFCButton:(id)sender;
- (IBAction)searchByFingerprintButton:(id)sender;
- (PatientObject *) selectPatient;
@end

@interface SearchPatientViewControllerCell : UITableViewCell{
}
@property (weak, nonatomic) IBOutlet UILabel *patientName;
@property (weak, nonatomic) IBOutlet UIImageView *patientPic;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;        //dob
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;         //patient age
@end
