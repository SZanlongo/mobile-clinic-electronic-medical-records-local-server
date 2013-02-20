//
//  Visitation.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/20/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Visitation : NSManagedObject

@property (nonatomic, retain) NSString * bloodPressure;
@property (nonatomic, retain) NSDate * checkInTime;
@property (nonatomic, retain) NSDate * checkOutTime;
@property (nonatomic, retain) NSString * complaint;
@property (nonatomic, retain) NSString * diagnosisNotes;
@property (nonatomic, retain) NSString * diagnosisTitle;
@property (nonatomic, retain) NSNumber * isGraphic;
@property (nonatomic, retain) NSString * patientId;
@property (nonatomic, retain) NSString * physicianUsername;
@property (nonatomic, retain) NSString * visitationId;
@property (nonatomic, retain) NSNumber * weight;

@end
