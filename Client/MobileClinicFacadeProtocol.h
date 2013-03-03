//
//  MobileClinicFacadeProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/1/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "PatientObjectProtocol.h"
#import "VisitationObjectProtocol.h"
#import <Foundation/Foundation.h>

typedef void (^MobileClinicCommandResponse)(NSDictionary* object, NSError* error);
typedef void (^MobileClinicSearchResponse)(NSArray* allObjectsFromSearch, NSError* error);
@protocol MobileClinicFacadeProtocol <NSObject>

/**
 *	- Triage:
 *		Note 1: if you create any record, you do not need to call the respective load method because it will already be loaded.
 *		Note 2: Before loading a patient, check if the patient is unlocked, otherwise an error will be thrown @see isPatientLocked
 *		Note 3: if the patient is already locked by another user then you will have to allow the user to query for the patient until they become unlocked.
 *		Note 4: You cannot Find Visits without a Patient loaded and you cannot find prescriptions without a visit loaded. An error will occur.
 *		---
 *		1. You always need to search and load the information before you can use it. There is only 1 exception -> (See Note 1)
 *		2. If you are working with a patient and modifying any of their records make sure you pass the appropriate Bool attribute to lock the patient.(See Note 2 & 3)
 *		3. To Find Visits a patient needs to be loaded and to find prescriptions the Visit needs to be loaded. These items depend on item before it. (see Note 4)
 */
@required
-(void) createAndCheckInPatient:(NSDictionary*)patientInfo onCompletion:(MobileClinicCommandResponse)Response;
-(void) loadAndLockPatient:(NSDictionary*)patientInfo onCompletion:(MobileClinicCommandResponse)Response;
-(void) findPatientWithFirstName:(NSString*)firstname orLastName:(NSString*)lastname onCompletion:(MobileClinicSearchResponse)Response;

-(void)addNewVisit:(NSDictionary *)visitInfo ForCurrentPatient:(NSDictionary *)patientInfo onCompletion:(MobileClinicCommandResponse)Response;
-(void) LockVist:(NSDictionary*)VisitInfo onCompletion:(MobileClinicCommandResponse)Response;
-(void) updateVisitRecord:(NSDictionary*)visitRecord andShouldUnlock:(BOOL)unlock onCompletion:(MobileClinicCommandResponse)Response;

-(void) findAllVisitsForCurrentPatient:(NSDictionary*)patientInfo AndOnCompletion:(MobileClinicSearchResponse)Response;

-(void) updateCurrentPatientAndShouldLock:(BOOL)lock onCompletion:(MobileClinicCommandResponse)Response;

-(void) findAllPrescriptionForCurrentVisitAndOnCompletion:(MobileClinicSearchResponse)Response;
-(void) addNewPrescriptionForCurrentPatientAndUnlockPatient:(NSDictionary*)PrescriptionInfo onCompletion:(MobileClinicCommandResponse)Response;
-(void) loadMobileClinicWithPrescriptionRecordForCurrentVisit:(NSDictionary*)visitInfo onCompletion:(MobileClinicCommandResponse)Response;
-(void) updatePrescriptionRecord:(NSDictionary*)prescriptionRecord andShouldUnlock:(BOOL)unlock onCompletion:(MobileClinicCommandResponse)Response;
-(BOOL) isPatientLocked;
@end
