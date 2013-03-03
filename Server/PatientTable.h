//
//  PatientTable.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PatientTable : NSViewController
@property (weak) IBOutlet NSScrollView *patientTable;
- (IBAction)refreshPatients:(id)sender;
- (IBAction)unblockPatients:(id)sender;
- (IBAction)pushPatientsIntoCloud:(id)sender;

@end
