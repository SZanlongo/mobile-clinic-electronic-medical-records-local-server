//
//  MedicationObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#define MEDICATIONID    @"medicationId"
#import <Foundation/Foundation.h>
#import "CommonObjectProtocol.h"

@protocol MedicationObjectProtocol <NSObject>

-(BOOL)loadPrescriptionWithPrescriptionID:(NSString *)prescriptionID;

-(void)associatePrescriptionToVisit:(NSString *)visitID;

-(NSArray *)FindAllPrescriptionForCurrentVisitLocally:(NSDictionary*)visit;

-(void)FindAllPrescriptionsOnServerForVisit:(NSDictionary*)visit OnCompletion:(ObjectResponse)eventResponse;

-(void)UpdateObjectAndShouldLock:(BOOL)shouldLock onComplete:(ObjectResponse)response;
@end
