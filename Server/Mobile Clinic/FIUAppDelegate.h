// 
//  FIUAppDelegate.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/23/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define APPDELEGATE_STARTED @"slow appdelegate"
#import <Cocoa/Cocoa.h>
#import "ServerCore.h"

@interface FIUAppDelegate : NSObject <NSApplicationDelegate>{
    
}
@property (weak) IBOutlet NSMenuItem *createPatientMenu;
@property (weak) IBOutlet NSMenuItem *createMedicineMenu;
@property (weak) IBOutlet NSMenuItem *resetAllMenu;

@property (nonatomic, strong) ServerCore *server;
@property (assign) IBOutlet NSWindow *window;

//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (IBAction)resetTestSettings:(id)sender;

- (IBAction)setupTestPatients:(id)sender;
- (IBAction)createTestMedications:(id)sender;

- (IBAction)saveAction:(id)sender;

- (IBAction)syncAllPatient:(id)sender;
- (IBAction)showPatientsView:(id)sender;

@end
