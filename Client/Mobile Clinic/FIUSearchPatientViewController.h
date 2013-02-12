//
//  FIUSearchViewController.h
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientObject.h"
#import "ScreenNavigationDelegate.h"

@interface FIUSearchPatientViewController :  UIViewController<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,ScreenNavigationDelegate>{
    ScreenHandler handler;
    NSArray* patientSearchResultsArray;
    BOOL shouldDismiss;
}

@property(nonatomic, strong)PatientObject * patientData;
@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UITableView *patientResultTableView;


-(void)setScreenHandler:(ScreenHandler) myHandler;
- (IBAction)searchByNameButton:(id)sender;
- (IBAction)searchByNFCButton:(id)sender;
- (IBAction)searchByFingerprintButton:(id)sender;
- (IBAction)cancelSearching:(id)sender;

@end


@interface FIUSearchPatientViewControllerCell : UITableViewCell{
}

@property (weak, nonatomic) IBOutlet UILabel *PatientName;
@property (weak, nonatomic) IBOutlet UIImageView *PatientPic;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@end