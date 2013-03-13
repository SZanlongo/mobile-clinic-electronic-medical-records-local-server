//
//  PrescriptionObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#define INSTRUCTIONS    @"instructions"
#define MEDICATIONID    @"medicationId"
#define PRESCRIBETIME   @"prescribedTime"
#define TABLEPERDAY     @"tabletPerDay"
#define TIMEOFDAY       @"timeOfDay"
#define PRESCRIPTIONID  @"prescriptionId"

#import <Foundation/Foundation.h>

@protocol PrescriptionObjectProtocol <NSObject>
+(NSString *)DatabaseName;

/**
 * Loads the current object with a previously existing visitation that resides locally on the client
 *@param visitID represents the id of the object that you want to find
 */
-(BOOL)loadPrescriptionWithPrescriptionID:(NSString *)prescriptionID;

-(void)associatePrescriptionToVisit:(NSString *)visitID;

-(NSArray *)FindAllPrescriptionForCurrentVisitLocally:(NSDictionary*)visit;

-(void)FindAllPrescriptionsOnServerForVisit:(NSDictionary*)visit OnCompletion:(ObjectResponse)eventResponse;

-(void)UpdateObjectAndShouldLock:(BOOL)shouldLock onComplete:(ObjectResponse)response;
@end
