//
//  VisitationObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "PrescriptionObject.h"
#import "Visitation.h"
#import "VisitationObjectProtocol.h"
@interface VisitationObject : BaseObject<VisitationObjectProtocol>{
    Visitation* visit;
}
@property(nonatomic, strong)    PrescriptionObject* currentPrescription;

/**
 * Loads the current object with a previously existing visitation that resides locally on the client
 *@param visitID represents the id of the object that you want to find
 */
-(BOOL)loadVisitWithVisitationID:(NSString *)visitID;

-(void)linkVisit;

-(void)createVisitationIDForPatient:(NSString*)patientFirstName;

-(void)createNewVisitOnClientAndServer:(ObjectResponse)onSuccessHandler
;

-(NSArray *)FindAllVisitsForCurrentPatientLocally:(NSDictionary*)patient;

-(void)FindAllVisitsOnServerForPatient:(NSDictionary*)patient OnCompletion:(ObjectResponse)eventResponse;

-(void)shouldLockVisit:(BOOL)lockVisit onCompletion:(ObjectResponse)Response;

+(NSString*)DatabaseName;
@end
