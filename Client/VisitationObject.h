//
//  VisitationObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#define CHECKIN     @"checkInTime"
#define CHECKOUT    @"checkOutTime"
#define PHYSICIAN   @"physician"
#define PATIENTID   @"patientId"
#define DNOTES      @"diagnosisNotes"
#define DTITLE      @"diagnosisTitle"
#define GRAPHIC     @"isGraphic"
#define WEIGHT      @"weight" //The different user types (look at enum)
#define COMPLAINT   @"complaint"
#define VISITID     @"visitationId"

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "PrescriptionObject.h"
#import "Visitation.h"
@interface VisitationObject : BaseObject{
    Visitation* visit;
}
@property(nonatomic, strong)    PrescriptionObject* currentPrescription;
/**
 * Initializes the object while creating a new visitation object in the database
 * at the same time. Use this method if the object is expected to be a brand new entry 
 * in the database
 */
-(id)initWithNewVisit;

/**
 * Initializes the object with a previous visit. This can be used to initialize an object
 * to work with a visit that already exists and only needs updating.
 *@param info a core data Visitation object
 */
-(id)initWithVisit:(Visitation*)info;

/**
 * Loads the current object with a previously existing visitation that resides locally on the client
 *@param visitID represents the id of the object that you want to find
 */
-(BOOL)loadVisitWithVisitationID:(NSString *)visitID;


/**
 * Adds a prescription to the visit of the patient. Call this method when you have a brand new prescription for the visit and you are going to save it for the first time. This method will add the visit's ID to the prescription and associate the prescription with the visit by adding it to the visit's relationship. NOTE: This method does not save the prescription. You will have to call SaveObject method still in the patient object
 @param prescription the prescription you want to associate with the visit
 */
-(void)addPrescriptionToCurrentVisit:(PrescriptionObject*)prescription;
@end
