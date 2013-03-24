//
//  RegisterFingerControllerViewController.h
//  Mobile Clinic
//
//  Created by Carlos Corvaia on 3/23/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#import "PBEnrollmentController.h"
#import "PBVerificationController.h"

#import "PBBiometry.h"
#import "PBBiometryDatabase.h"
#import "PBBiometryUser.h"
#import "ScreenNavigationDelegate.h"
#import <UIKit/UIKit.h>

@interface RegisterFingerControllerViewController : UIViewController <PBEnrollmentDelegate, PBVerificationDelegate, UIActionSheetDelegate, UISplitViewControllerDelegate>{
   
    IBOutlet UIImageView* leftHandImage;
    IBOutlet UIImageView* rightHandImage;
    
    IBOutlet UIButton* leftLittle;
    IBOutlet UIButton* leftRing;
    IBOutlet UIButton* leftMiddle;
    IBOutlet UIButton* leftIndex;
    IBOutlet UIButton* leftThumb;
    IBOutlet UIButton* rightLittle;
    IBOutlet UIButton* rightRing;
    IBOutlet UIButton* rightMiddle;
    IBOutlet UIButton* rightIndex;
    IBOutlet UIButton* rightThumb;
    
    IBOutlet UIButton* scrollToLeftHandImage;
    IBOutlet UIButton* scrollToRightHandImage;
    
    IBOutlet UIScrollView* scrollView;
    
    IBOutlet UILabel* noFingersLabel;
    
    NSArray* fingerButtons;
    id<PBBiometryDatabase> database;
    PBBiometryUser* user;
    
    NSInteger pageCurrentlyShown;
    
    BOOL isAnimatingScroll;

    /** The config parameters for the enrollment. If nil, the default config
     * parameters will be used. */
    PBBiometryEnrollConfig* enrollConfig;
    
    /** Tells if the verification is done against all of the enrolled fingers or if the
     * user has to choose finger to verify against. E.g. for match on card it is better
     * to only verify against one finger, since otherwise it is likely that fingers are
     * accidently locked by the card itself. */
    BOOL verifyAgainstAllFingers;
    
    /** The fingers that may be enrolled. If not set, then all 10 fingers may be
     *  enrolled. */
    NSArray* enrollableFingers;
    
}
- (IBAction)registerFinger:(id)sender;

@property (nonatomic, retain) PBBiometryEnrollConfig* enrollConfig;
@property (nonatomic) BOOL verifyAgainstAllFingers;
@property (nonatomic, retain) NSArray* enrollableFingers;

/** Initiates the manage fingers controller with a database and a user. */
- (id) initWithDatabase: (id<PBBiometryDatabase>) aDatabase
                andUser: (PBBiometryUser*) aUser;

/** Refreshes the manage fingers controller. Updates the enrolled fingers and sets the
 * state back to normal (in case in edit state).
 * Call this method e.g. if the enrolled fingers are stored on a smartcard and the
 * smartcard is inserted or removed from the card reader. */
- (void)refresh;

- (IBAction)enrollFinger: (id) sender;

- (IBAction)scrollLeft;

- (IBAction)scrollRight;


@end
