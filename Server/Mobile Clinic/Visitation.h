//
//  Visitation.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/17/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Visitation : NSManagedObject

@property (nonatomic, retain) NSDate * checkInTime;
@property (nonatomic, retain) NSDate * checkOutTime;
@property (nonatomic, retain) NSString * complaint;
@property (nonatomic, retain) NSString * diagnosisNotes;
@property (nonatomic, retain) NSString * diagnosisTitle;
@property (nonatomic, retain) NSNumber * isGraphic;
@property (nonatomic, retain) NSString * physicianUsername;
@property (nonatomic, retain) NSString * visitationId;
@property (nonatomic, retain) NSNumber * weight;

@end
