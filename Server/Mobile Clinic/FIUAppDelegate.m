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
#import "MedicationList.h"
#import "UserView.h"

#import "Database.h"
#define PTESTING @"Patients Testing"
#define MTESTING @"Medicine Testing"

ServerCore* connection;
UserView* userView;
MedicationList* medList;
PatientTable *pTable;
@implementation FIUAppDelegate

//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize managedObjectContext = _managedObjectContext;

- (void)showPatientsView:(id)sender {
    if(![_window isVisible] )
        [_window makeKeyAndOrderFront:sender];
    
    if (!pTable) {
         pTable = [[PatientTable alloc]initWithNibName:@"PatientTable" bundle:nil];
    }
 
    
    [_window setContentView:pTable.view];
}

- (IBAction)showUserView:(id)sender {
    if(![_window isVisible] )
        [_window makeKeyAndOrderFront:sender];
    
    if (!userView) {
        userView = [[UserView alloc]initWithNibName:@"UserView" bundle:nil];
    }
    
    [_window setContentView:userView.view];
}

- (void)showUsersView:(id)sender {
    if(![_window isVisible] )
        [_window makeKeyAndOrderFront:sender];
    
//    if (!pTable)
//        pTable = [[PatientTable alloc]initWithNibName:@"PatientTable" bundle:nil];
//    
//    [_window setContentView:pTable.view];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    connection = [ServerCore sharedInstance];
    
    [connection startServer];
    
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
   
    
    dataPath = [[NSBundle mainBundle] pathForResource:@"MedicationFile" ofType:@"json"];
    
    NSArray* Meds = [NSArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]options:0 error:&err]];
    
    NSLog(@"Imported Medications: %@", Meds.description);
    
    [Meds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MedicationObject* base = [[MedicationObject alloc]init];
        
        [base setValueToDictionaryValues:obj];
        
        [base saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
        }];
    }];
    
    NSUserDefaults* uDefault = [NSUserDefaults standardUserDefaults];
    
    [uDefault setBool:YES forKey:PTESTING];
    
    [_createPatientMenu setEnabled:NO];
    
    [uDefault setBool:YES forKey:MTESTING];
    
    [_createMedicineMenu setEnabled:NO];
}

- (IBAction)TearDownEnvironment:(id)sender {
    
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


- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{

    Database* database = [Database sharedInstance];
    
    if ([database shutdownDatabase]) {
        [_server stopServer];
        return NSTerminateNow;
    }
    return NSTerminateCancel;
}


- (IBAction)restartServer:(id)sender {
    if (connection.isServerRunning) {
        [connection stopServer];
    }
    
    [connection startServer];
}

- (IBAction)shutdownServer:(id)sender {
    if (connection.isServerRunning) {
        [connection stopServer];
    }

}

- (IBAction)showMedicineView:(id)sender {
    if(![_window isVisible] )
        [_window makeKeyAndOrderFront:sender];

    if (!medList) {
        medList = [[MedicationList alloc]initWithNibName:@"MedicationList" bundle:nil];
    }
    [_window setContentView:medList.view];

}
@end
