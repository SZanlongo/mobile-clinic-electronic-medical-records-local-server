//
//  Prescription.h
//  Mobile Clinic
//
//  Created by Rigo Hernandez on 2/20/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Prescription : NSManagedObject

@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) NSString * medicationId;
@property (nonatomic, retain) NSString * prescribedTime;
@property (nonatomic, retain) NSNumber * tabletPerDay;
@property (nonatomic, retain) NSNumber * timeOfDay;
@property (nonatomic, retain) NSString * visitId;

@end
