//
//  PrescriptionObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/25/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#define INSTRUCTIONS    @"instructions"
#define MEDICATIONID    @"medicationId"
#define PRESCRIBETIME   @"prescribedTime"
#define TABLEPERDAY     @"tabletPerDay"
#define TIMEOFDAY       @"timeOfDay"
#define VISITID         @"visitId"


#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "PrescriptionObject.h"
#import "Prescription.h"
@interface PrescriptionObject : BaseObject{
    Prescription* prescription;
}
/**
 * Initializes the object while creating a new visitation object in the database
 * at the same time. Use this method if the object is expected to be a brand new entry
 * in the database
 */
-(id)initWithNewPrescription;

/**
 * Initializes the object with a previous visit. This can be used to initialize an object
 * to work with a visit that already exists and only needs updating.
 *@param info a core data Visitation object
 */
-(id)initWithPrescription:(Prescription*)info;

/**
 * Loads the current object with a previously existing visitation that resides locally on the client
 *@param visitID represents the id of the object that you want to find
 */
-(BOOL)loadPrescriptionWithPrescriptionID:(NSString *)prescriptionID;

@end
