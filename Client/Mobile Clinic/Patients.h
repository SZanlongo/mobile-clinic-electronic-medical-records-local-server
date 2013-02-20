//
//  Patients.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/20/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Visitation;

@interface Patients : NSManagedObject

@property (nonatomic, retain) NSDate * age;
@property (nonatomic, retain) NSString * familyName;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * patientId;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * villageName;
@property (nonatomic, retain) NSString * physician;
@property (nonatomic, retain) NSSet *hasVisitations;
@end

@interface Patients (CoreDataGeneratedAccessors)

- (void)addHasVisitationsObject:(Visitation *)value;
- (void)removeHasVisitationsObject:(Visitation *)value;
- (void)addHasVisitations:(NSSet *)values;
- (void)removeHasVisitations:(NSSet *)values;

@end
