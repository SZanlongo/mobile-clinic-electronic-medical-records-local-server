//
//  PatientVisitation.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitationObject.h"
#import "ScreenNavigationDelegate.h"
@interface PatientVisitation : UIViewController<UIPopoverControllerDelegate>{
    ScreenHandler handler;
    BOOL shouldDismiss;
}

-(void)setScreenHandler:(ScreenHandler) myHandler;
- (IBAction)cancelCommit:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) VisitationObject* visitation;
@property (weak, nonatomic) IBOutlet UILabel *commitDateLbl;
@property (weak, nonatomic) IBOutlet UITextView *complaintField;
@property (weak, nonatomic) IBOutlet UITextField *diagnosisInput;
@property (weak, nonatomic) IBOutlet UITextView *diagnosisNoteField;

@end
