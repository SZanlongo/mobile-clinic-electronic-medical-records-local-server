//
//  PatientTable.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PatientObject.h"
@interface PatientTable : NSViewController<NSTableViewDataSource,NSTableViewDelegate>{
    PatientObject* patientsHandler;
    NSArray* patientList;
}
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSTableView *patientTable;

- (IBAction)refreshPatients:(id)sender;
- (IBAction)unblockPatients:(id)sender;
- (IBAction)pushPatientsIntoCloud:(id)sender;

@end
