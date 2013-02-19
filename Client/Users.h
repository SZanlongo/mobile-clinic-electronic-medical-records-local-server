//
//  Users.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/14/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
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
@property (nonatomic, retain) NSSet *seenPatient;
@end

@interface Users (CoreDataGeneratedAccessors)

- (void)addSeenPatientObject:(Patients *)value;
- (void)removeSeenPatientObject:(Patients *)value;
- (void)addSeenPatient:(NSSet *)values;
- (void)removeSeenPatient:(NSSet *)values;

@end
