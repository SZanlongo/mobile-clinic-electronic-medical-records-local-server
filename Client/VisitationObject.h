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
#import "Visitation.h"
@interface VisitationObject : BaseObject

@property(weak,nonatomic)Visitation* visit;

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
 * Use this to save attributes of the object. For instance, to the Doctor's Diagnosis can be saved by passing the string and the Attribute DNOTES
 *@param object object that needs to be stored in the database
 *@param attribute the name of the attribute or the key to which the object needs to be saved
 */
-(void)setObject:(id)object withAttribute:(NSString*)attribute;

/**
 * Use this to retrieve objects/values from the visitation object. 
 *@param attribute the name of the attribute you want to retrieve.
 */
-(id)getObjectForAttribute:(NSString*)attribute;
@end
