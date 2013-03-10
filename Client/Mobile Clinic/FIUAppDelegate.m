//
//  FIUAppDelegate.m
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/2/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "FIUAppDelegate.h"
#import "ServerCore.h"


@implementation FIUAppDelegate
@synthesize ServerManager;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

+(AJNotificationView *)getNotificationWithColor:(int)color Animation:(int)animate WithMessage:(NSString *)msg{
    UIView *topMostView = [[FIUAppDelegate topMostController]view];
    return [AJNotificationView showNoticeInView:topMostView type:color title:msg linedBackground:animate hideAfter:10];
}

+(AJNotificationView *)getNotificationWithColor:(int)color Animation:(int)animate WithMessage:(NSString *)msg inView:(UIView *)view{
    return [AJNotificationView showNoticeInView:view type:color title:msg linedBackground:animate hideAfter:10];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    #define TESTING 1
        #ifdef TESTING
            [TestFlight setDeviceIdentifier:[[NSUUID UUID]UUIDString]];
        #endif
    
        [TestFlight takeOff:@"afc6ff4013b9e807e5a97743e2a8d270_MTg2NjAwMjAxMy0wMi0xMiAxODozOTozOS41NzU1OTk"];
    
    //RIGO - FOR TESTING PURPOSES ONLY
    //MANUALLY ENTERS DATA INTO THE DATABASE
//    NSError *error;
//    NSManagedObjectContext *context = [self managedObjectContext];

    /*
    // Delete all entries in the Core Data table (ex. Patients)
    NSFetchRequest *fetchRecords = [[NSFetchRequest alloc] init];
    [fetchRecords setEntity:[NSEntityDescription entityForName:@"Patients" inManagedObjectContext:context]];

    NSArray *currentRecords = [context executeFetchRequest:fetchRecords error:&error];
     
    for(NSManagedObject *entries in currentRecords) {
    [context deleteObject:entries];
    }
    */

    /*
     // Delete all entries in the Core Data table (ex. Patients)
     NSFetchRequest *fetchRecords = [[NSFetchRequest alloc] init];
     [fetchRecords setEntity:[NSEntityDescription entityForName:@"Patients" inManagedObjectContext:context]];
     
     NSArray *currentRecords = [context executeFetchRequest:fetchRecords error:&error];
     
     for(NSManagedObject *entries in currentRecords) {
     [context deleteObject:entries];
     }
     */
    
    // Print (to NSLog) content of table (ex. Patients)
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Patients" inManagedObjectContext:context]];
//    
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//   

   
    // Add sample patients if database is empty
    
    // ADD SAMPLE PATIENTS INTO DB
    // PATIENT #1
//    PatientObject *pData = [[PatientObject alloc] init];
//    VisitationObject *vData = [[VisitationObject alloc] init];
//    
//    // Get everything that's on the server
//    NSArray *myArray = [pData FindAllPatientsLocallyWithFirstName:nil andWithLastName:nil];
//
//    if(myArray.count == 0){
//
//    [pData setObject:@"Rigo" withAttribute:FIRSTNAME];
//    [pData setObject:@"Hernandez" withAttribute:FAMILYNAME];
//    [pData setObject:@"Little Havana" withAttribute:VILLAGE];
//    [pData setObject:[NSDate date] withAttribute:DOB];
//    [pData setObject:[NSNumber numberWithInt:1] withAttribute:SEX];
//    
//    [vData setObject:[NSNumber numberWithDouble:185.0] withAttribute:WEIGHT];
//    [vData setObject:@"135/85" withAttribute:BLOODPRESSURE];
//    [vData setObject:@"Patient complains of chest pains that coincide with exertion and pass with rest.  He describes the pain as a tight, squeezing sensation in the middle of the chest, rating the pain an 8 on a scale of 1 to 10." withAttribute:CONDITION];
//    [vData setObject:@"Patient presents with episodes of chest pain, signs and symptoms indicating stable angina.  Patient has been ordered to stop all sort of exercise till further notice." withAttribute:OBSERVATION];
//    
//    [pData addVisitToCurrentPatient:vData];
    
//
//    // PATIENT #2
//    pData = [[PatientObject alloc] init];
//    vData = [[VisitationObject alloc] init];
//    
//    [pData setObject:@"Sebastian" withAttribute:FIRSTNAME];
//    [pData setObject:@"Zanlongo" withAttribute:FAMILYNAME];
//    [pData setObject:@"Pinecrest" withAttribute:VILLAGE];
//    [pData setObject:[NSDate date] withAttribute:DOB];
//    [pData setObject:[NSNumber numberWithInt:1] withAttribute:SEX];
//    
//    [vData setObject:[NSNumber numberWithDouble:122.0] withAttribute:WEIGHT];
//    [vData setObject:@"115/65" withAttribute:BLOODPRESSURE];
//    [vData setObject:@"Patient reports uneven markings on his skin.  Markings have increased in size in the past 3 weeks." withAttribute:CONDITION];
//    [vData setObject:@"Patient shows many signs and symptoms of unmanaged diabetes (type I), including, ketosis, polyuria, polydipsia, polyphagia, and dry, itchy skin." withAttribute:OBSERVATION];
//    
//    [pData addVisitToCurrentPatient:vData];
//    
//    
//    // PATIENT #3
//    pData = [[PatientObject alloc] init];
//    vData = [[VisitationObject alloc] init];
//    
//    [pData setObject:@"Steven" withAttribute:FIRSTNAME];
//    [pData setObject:@"Berlanga" withAttribute:FAMILYNAME];
//    [pData setObject:@"South Miami" withAttribute:VILLAGE];
//    [pData setObject:[NSDate date] withAttribute:DOB];
//    [pData setObject:[NSNumber numberWithInt:1] withAttribute:SEX];
//    
//    [vData setObject:[NSNumber numberWithDouble:178.0] withAttribute:WEIGHT];
//    [vData setObject:@"125/85" withAttribute:BLOODPRESSURE];
//    [vData setObject:@"Patient reports pain that spreads to his left shoulder, arm, and hand, alarming him, bringing him here today.  The patient has had four episodes of chest pain (one with arm pain), each episode occurring while shoveling the snow.  Patient reports that the pain lasts no more than a couple of minutes, with the exception of this last episode which seemed to last just a little bit longer." withAttribute:CONDITION];
//    [vData setObject:@"Performed stress test and echo cardio.  Lab results seems to give no signs of underlying issues.  Ordered a follow up examination in 6 months." withAttribute:OBSERVATION];
//    
//    [pData addVisitToCurrentPatient:vData];
//    
//    
//    // PATIENT #4
//    pData = [[PatientObject alloc] init];
//    vData = [[VisitationObject alloc] init];
//    
//    [pData setObject:@"Michael" withAttribute:FIRSTNAME];
//    [pData setObject:@"Montaque" withAttribute:FAMILYNAME];
//    [pData setObject:@"Homestead" withAttribute:VILLAGE];
//    [pData setObject:[NSDate date] withAttribute:DOB];
//    [pData setObject:[NSNumber numberWithInt:1] withAttribute:SEX];
//    
//    [vData setObject:[NSNumber numberWithDouble:195] withAttribute:WEIGHT];
//    [vData setObject:@"130/80" withAttribute:BLOODPRESSURE];
//    [vData setObject:@"Patient was in a frontend collision.  He suffers of neck pain and suffered minor cuts to his forarm.  No signs of loss of motor movements were detected at check in." withAttribute:CONDITION];
//    [vData setObject:@"Ran x-rays and MRI.  No signed of brain injury are visible.  Patient was given 7 stitches to close a wound on his forarm." withAttribute:OBSERVATION];
//    
//    [pData addVisitToCurrentPatient:vData];
//    
//    
//    // PATIENT #5
//    pData = [[PatientObject alloc] init];
//    vData = [[VisitationObject alloc] init];
//    
//    [pData setObject:@"Carlos" withAttribute:FIRSTNAME];
//    [pData setObject:@"Corvaia" withAttribute:FAMILYNAME];
//    [pData setObject:@"Doral" withAttribute:VILLAGE];
//    [pData setObject:[NSDate date] withAttribute:DOB];
//    [pData setObject:[NSNumber numberWithInt:1] withAttribute:SEX];
//    
//    [vData setObject:[NSNumber numberWithDouble:175] withAttribute:WEIGHT];
//    [vData setObject:@"115/65" withAttribute:BLOODPRESSURE];
//    [vData setObject:@"Patient presented a fractured wrist.  He reports a pain level of 4 on a scale of 1-10." withAttribute:CONDITION];
//    [vData setObject:@"Ran x-rays and observed hairline fracture.  Ordered a cast be place for 6 weeks.  Follow up in 6 weeks to remove cast." withAttribute:OBSERVATION];
//    
//    [pData addVisitToCurrentPatient:vData];
//    }
   
    
    [self saveContext];
    
    // Override point for customization after application launch.
    ServerManager = [ServerCore sharedInstance];
    [ServerManager startClient];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [ServerManager stopClient];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Mobile_Clinic.sqlite"];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
