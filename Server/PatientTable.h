//
//  PatientTable.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PatientObject.h"
#import "VisitationObject.h"
#import "PrescriptionObject.h"
@interface PatientTable : NSViewController<NSTableViewDataSource,NSTableViewDelegate,NSBrowserDelegate>{
    PatientObject* patientsHandler;
    VisitationObject* visitsHandler;
    PrescriptionObject* prescriptionHandler;
    NSArray* patientList;
    NSMutableArray* visitList;
    NSMutableArray* allItems;
    NSManagedObject* patient;
    int selectedRow;
}
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSTableView *patientTable;
@property (weak) IBOutlet NSBrowser *patientDirectory;

- (IBAction)refreshPatients:(id)sender;
- (IBAction)unblockPatients:(id)sender;
- (IBAction)pushPatientsIntoCloud:(id)sender;

@end
