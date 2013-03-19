//
//  PatientObjectTest.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/6/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "PatientObject.h"
#import "ServerCore.h"

@interface PatientObjectTest: GHAsyncTestCase {
   
    ServerCore* server;
    PatientObject* testObject;
    NSMutableDictionary* testPatient;
}

@end

@implementation PatientObjectTest

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return NO;
}

- (void)setUpClass {
   // server = [[ServerCore alloc]init];
   // [server startClient];
    // - DO NOT COMMENT: IF YOUR RESTART YOUR SERVER IT WILL PLACE DEMO PATIENTS INSIDE TO HELP ACCELERATE YOUR TESTING
    // - YOU CAN SEE WHAT PATIENTS ARE ADDED BY CHECKING THE PatientFile.json file

    NSError* err = nil;
    
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"PatientFile" ofType:@"json"];
    
    NSArray* patients = [NSArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]options:0 error:&err]];
    
    NSLog(@"Imported Patients For Testing: %@", patients);
    
    [patients enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj];
        PatientObject *base = [[PatientObject alloc]init];
        
        NSDateFormatter *format =[[NSDateFormatter alloc]init];
        
        [format setDateFormat:@"yyyy-MMMM-dd"];
        
        [dic setValue:[format dateFromString:[dic valueForKey:@"age"]] forKey:DOB];
        
        [base setValueToDictionaryValues:dic];
        
        [base saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            
        }];
//        if (idx == 6) {
//            [self notify:GHTestStatusNone];
//        }
    }];
}

- (void)tearDownClass {
    // - YOU CAN SEE WHAT PATIENTS ARE ADDED BY CHECKING THE PatientFile.json file
    NSError* err = nil;
    
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"PatientFile" ofType:@"json"];
    
    NSArray* patients = [NSArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]options:0 error:&err]];
    
    NSLog(@"Imported Patients For Testing: %@", patients);
    
    [patients enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        PatientObject *base = [[PatientObject alloc]init];
        
        [base deleteDatabaseDictionaryObject:obj];
    }];
    
}

- (void)setUp {
    testObject = [[PatientObject alloc]init];
    [testPatient setValue:@"Tiffy" forKey:FIRSTNAME];
    [testPatient setValue:@"Cinder" forKey:FAMILYNAME];
    [testPatient setValue:@"Alaska" forKey:VILLAGE];
    [testPatient setValue:[NSDate dateWithTimeIntervalSince1970:30000] forKey:DOB];
    [testPatient setValue:[NSNumber numberWithInteger:0] forKey:SEX];
}

- (void)tearDown {
    testObject = nil;
}
- (void)testFindAllOpenPatientsLocally {

	NSArray* array = [testObject FindAllOpenPatientsLocally];
    
    NSDictionary* patientOne = [array objectAtIndex:0];
    NSString* pOneName = [patientOne objectForKey:FIRSTNAME];
    
    GHAssertEqualStrings(@"Starla", pOneName, @"The name should be equal to Starla");
    
    NSDictionary* patientTwo = [array objectAtIndex:1];
    NSString* pTwoName = [patientTwo objectForKey:FIRSTNAME];
    
    GHAssertEqualStrings(@"Jay", pTwoName, @"The name should be equal to Jay");
    [self tearDown];
}
- (void)testCreateNewObject{
    
    [testObject createNewObject:testPatient onCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
      // NSArray* array = [data loadObjectWithID:<#(NSString *)#>]
      //  NSManagedObject* patientDatabaseObject = array.lastObject;
       // NSString* pName = [patientDatabaseObject valueForKey:FIRSTNAME];
       // GHAssertEqualStrings(@"Tiffy", pName, @"Should be Tiffy");
    }];
}
- (void)testSimpleFail {
	GHAssertTrue(NO, nil);
}
// simple test to ensure building, linking,
// and running test case works in the project

@end