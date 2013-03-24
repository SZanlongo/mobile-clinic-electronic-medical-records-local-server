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
@interface PatientTable : NSViewController<NSTableViewDataSource,NSTableViewDelegate>{
    
    NSArray* patientList;
    NSMutableArray* visitList;
    NSMutableArray* allItems;
    NSInteger selectedRow;
}
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSTableView *patientTableView;
@property (weak) IBOutlet NSTableView *visitTableView;
@property (weak) IBOutlet NSButton *details;


- (IBAction)showDetails:(id)sender;

- (IBAction)refreshPatients:(id)sender;
- (IBAction)unblockPatients:(id)sender;
- (IBAction)getPatientsFromCloud:(id)sender;

@end
