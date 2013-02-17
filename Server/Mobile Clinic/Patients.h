//
//  Patients.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/17/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Visitation;

@interface Patients : NSManagedObject

@property (nonatomic, retain) NSDate * age;
@property (nonatomic, retain) NSString * familyName;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * patientId;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * villageName;
@property (nonatomic, retain) NSOrderedSet *visitation;
@end

@interface Patients (CoreDataGeneratedAccessors)

- (void)insertObject:(Visitation *)value inVisitationAtIndex:(NSUInteger)idx;
- (void)removeObjectFromVisitationAtIndex:(NSUInteger)idx;
- (void)insertVisitation:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeVisitationAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInVisitationAtIndex:(NSUInteger)idx withObject:(Visitation *)value;
- (void)replaceVisitationAtIndexes:(NSIndexSet *)indexes withVisitation:(NSArray *)values;
- (void)addVisitationObject:(Visitation *)value;
- (void)removeVisitationObject:(Visitation *)value;
- (void)addVisitation:(NSOrderedSet *)values;
- (void)removeVisitation:(NSOrderedSet *)values;
@end
