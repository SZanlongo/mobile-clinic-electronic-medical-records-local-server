//
//  CurrentDiagnosisViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/22/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationViewHandlerProtocol.h"
#import "PatientObject.h"

@interface CurrentDiagnosisViewController : UIViewController {
    ScreenHandler handler;
}

@property (weak, nonatomic) IBOutlet UITextView *diagnosisTextbox;

- (IBAction)submitButton:(id)sender;

- (void)setScreenHandler:(ScreenHandler)myHandler;

@end
