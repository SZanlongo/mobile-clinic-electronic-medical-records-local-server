//
//  FIUAppDelegate.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/23/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "FIUAppDelegate.h"
#import "BaseObject.h"
#import "PatientTable.h"
#import "MedicationObject.h"
#import "Database.h"
#define PTESTING @"Patients Testing"
#define MTESTING @"Medicine Testing"
PatientTable *pTable;

@implementation FIUAppDelegate

//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize managedObjectContext = _managedObjectContext;

- (void)showPatientsView:(id)sender {
    if(![_window isVisible] )
        [_window makeKeyAndOrderFront:sender];
    
    if (!pTable)
        pTable = [[PatientTable alloc]initWithNibName:@"PatientTable" bundle:nil];
    
    [_window setContentView:pTable.view];
}
- (void)showUsersView:(id)sender {
    if(![_window isVisible] )
        [_window makeKeyAndOrderFront:sender];
    
    if (!pTable)
        pTable = [[PatientTable alloc]initWithNibName:@"PatientTable" bundle:nil];
    
    [_window setContentView:pTable.view];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
        NSUserDefaults* uDefault = [NSUserDefaults standardUserDefaults];
    
    [[CloudService cloud] getAccessToken:^(BOOL success) {
        if(success)
            [[CloudService cloud] getUserToken:^(BOOL success) {
                if(success)
                    NSLog(@"STARCRAFT TIME");
            }];
    }];
    
    [_createMedicineMenu setEnabled:![uDefault boolForKey:PTESTING]];
    [_createPatientMenu setEnabled:![uDefault boolForKey:MTESTING]];
    
    
    //[_server startServer];
}
- (IBAction)resetTestSettings:(id)sender {
    NSUserDefaults* uDefault = [NSUserDefaults standardUserDefaults];
    [uDefault removeObjectForKey:PTESTING];
    [uDefault removeObjectForKey:MTESTING];
}

- (IBAction)setupTestPatients:(id)sender {
    // - DO NOT COMMENT: IF YOUR RESTART YOUR SERVER IT WILL PLACE DEMO PATIENTS INSIDE TO HELP ACCELERATE YOUR TESTING
    // - YOU CAN SEE WHAT PATIENTS ARE ADDED BY CHECKING THE PatientFile.json file
    NSError* err = nil;
    
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"PatientFile" ofType:@"json"];
    
    NSArray* patients = [NSArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]options:0 error:&err]];
    
    NSLog(@"Imported Patients: %@", patients);
    
    [patients enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj];
        PatientObject *base = [[PatientObject alloc]init];
        
        NSDateFormatter *format =[[NSDateFormatter alloc]init];
        
        [format setDateFormat:@"yyyy-MMMM-dd"];
        
        [dic setValue:[format dateFromString:[dic valueForKey:@"age"]] forKey:DOB];
        
        [base setValueToDictionaryValues:dic];
        
        [base saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            
        }];
        
    }];
        NSUserDefaults* uDefault = [NSUserDefaults standardUserDefaults];
    [uDefault setBool:YES forKey:PTESTING];
}

- (IBAction)createTestMedications:(id)sender {
    NSError* err = nil;
    
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"MedicationFile" ofType:@"json"];
    
    NSArray* Meds = [NSArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]options:0 error:&err]];
    
    NSLog(@"Imported Medications: %@", Meds.description);
    
    [Meds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MedicationObject* base = [[MedicationObject alloc]init];
        
        [base setValueToDictionaryValues:obj];
        
        [base saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
        }];
    }];
    NSUserDefaults* uDefault = [NSUserDefaults standardUserDefaults];
    [uDefault setBool:YES forKey:MTESTING];
}


- (void) testCloud {
//    BaseObject * obj = [[BaseObject alloc] init];
//    
//    NSMutableDictionary * mDic = [[NSMutableDictionary alloc]init];
//    
//    [mDic setObject:@"pooop" forKey:@"userName"];
//    [mDic setObject:@"poooop" forKey:@"password"];
//    [mDic setObject:@"poop" forKey:@"firstName"];
//    [mDic setObject:@"poop" forKey:@"lastName"];
//    [mDic setObject:@"poop@popper.com" forKey:@"email"];
//    [mDic setObject:@"1" forKey:@"userType"];
//    [mDic setObject:@"1" forKey:@"status"];
//    //    [mDic setObject:@"asd" forKey:@"remember_token"];
//    [obj query:@"deactivate_user" parameters:mDic completion:^(NSError *error, NSDictionary *result) {
//    }];
}
/*
// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "FIU.Mobile_Clinic" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"FIU.Mobile_Clinic"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Mobile_Clinic" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Mobile_Clinic.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
 [[NSNotificationCenter defaultCenter]postNotificationName:APPDELEGATE_STARTED object:self];
    return _managedObjectContext;
}



// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

*/
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{

    Database* database = [Database sharedInstance];
    
    if ([database shutdownDatabase]) {
        [_server stopServer];
        return NSTerminateNow;
    }
    return NSTerminateCancel;
}

@end
