//
//  VisitationObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/3/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#define TRIAGEIN    @"triageIn"
#define TRIAGEOUT   @"triageOut"
#define DOCTORID    @"doctorId"
#define PATIENTID   @"patientId"
#define DOCTORIN    @"doctorIn"
#define DOCTOROUT   @"doctorOut"
#define CONDITION   @"condition"
#define DTITLE      @"diagnosisTitle"
#define GRAPHIC     @"isGraphic"
#define WEIGHT          @"weight" 
#define OBSERVATION     @"observation"
#define NURSEID         @"nurseId"
#define BLOODPRESSURE   @"bloodPressure"
#define VISITID         @"visitationId"
#define PRIORITY        @"priority"
#import <Foundation/Foundation.h>
#import "BaseObjectProtocol.h"
@protocol VisitationObjectProtocol <NSObject>

/**
 *
 */
-(void)associatePatientToVisit:(NSString*)patientFirstName;

/**
 *
 */
-(NSArray *)FindAllVisitsForCurrentPatientLocally:(NSDictionary*)patient;
/**
 *
 */
-(void)FindAllVisitsOnServerForPatient:(NSDictionary*)patient OnCompletion:(ObjectResponse)eventResponse;

/**
 *
 */
-(void)UpdateObjectAndShouldLock:(BOOL)shouldLock onComplete:(ObjectResponse)response;

/**
 *
 */
-(void) SyncAllOpenVisitsOnServer:(ObjectResponse)Response;
/**
 *
 */
-(NSArray*) FindAllOpenVisitsLocally;
/**
 *
 */
-(void)shouldSetCurrentVisitToOpen:(BOOL)shouldOpen;
@end
