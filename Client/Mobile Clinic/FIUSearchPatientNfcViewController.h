//
//  FIUSearchNfcViewController.h
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientObject.h"
@interface FIUSearchPatientNfcViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    ScreenHandler handler;
    NSArray* patientSearchResultsArray;
}

@property(nonatomic, strong)PatientObject* patientData;
-(void)setScreenHandler:(ScreenHandler)myHandler;
@end

@interface FIUSearchPatientNfcViewControllerCell : UITableViewCell{

}

@property (weak, nonatomic) IBOutlet UILabel *PatientName;
@property (weak, nonatomic) IBOutlet UIImageView *PatientPic;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@end