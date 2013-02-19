//
//  Users.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/17/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patients;

@interface Users : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * usertype;
@property (nonatomic, retain) NSOrderedSet *patient;
@end

@interface Users (CoreDataGeneratedAccessors)

- (void)insertObject:(Patients *)value inPatientAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPatientAtIndex:(NSUInteger)idx;
- (void)insertPatient:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePatientAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPatientAtIndex:(NSUInteger)idx withObject:(Patients *)value;
- (void)replacePatientAtIndexes:(NSIndexSet *)indexes withPatient:(NSArray *)values;
- (void)addPatientObject:(Patients *)value;
- (void)removePatientObject:(Patients *)value;
- (void)addPatient:(NSOrderedSet *)values;
- (void)removePatient:(NSOrderedSet *)values;
@end
