//
//  MobileClinicFacadeProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/1/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

/**
 * WorkFLow
 *	- Triage:
 *		Note 1: Before editing a visitation record you need to lock the record @see updateVisitRecord and @see LockVisit.
 *		Note 2: Currently you do not need to lock patients becuase of the unique workflow it is moot to do so.
 *		Note 3: if an object is already locked by another user then you will have to allow the user to query for the object until it becomes unlocked.
 *		1. You can always search without the need to lock. Only when an object can be modified should the locks be taken into consideration.
 *		2. If you are working with a patient and modifying any of their records make sure you pass the appropriate Bool attribute to lock the patient.(See Note 2 & 3)
 *		3. All(Most) the objects return from the Block response of the methods will be updated values take from the server. So if you tried to lock the object under your userprofile but it was already locked by another user, your returned object from the server will reflect the other user's information and changes. This is to help mitigate RACE conditions
 */
#import "PatientObjectProtocol.h"
#import "VisitationObjectProtocol.h"
#import <Foundation/Foundation.h>

typedef void (^MobileClinicCommandResponse)(NSDictionary* object, NSError* error);
typedef void (^MobileClinicSearchResponse)(NSArray* allObjectsFromSearch, NSError* error);
@protocol MobileClinicFacadeProtocol <NSObject>

@required
/**
 * This method creates a LOCAL patient. This patient will not be synced to the server immediately. 
 * This on completion this method will return the object it saves.
 * @param patietnInfo The patient's information in a dictionary form
 */
-(void) createAndCheckInPatient:(NSDictionary*)patientInfo onCompletion:(MobileClinicCommandResponse)Response;
/**
 * Not Implemented: Do not use this method yet.
 */
-(void) loadAndLockPatient:(NSDictionary*)patientInfo onCompletion:(MobileClinicCommandResponse)Response;
/**
 * Locates the patient by First and/or Family name. This method fetches the query from the server and caches it to the device. Then it queries the cache to return a complete list objects that matches the criteria
 * @param firstname the firstname of the patient
 * @param lastname the family name of the patient
 */
-(void) findPatientWithFirstName:(NSString*)firstname orLastName:(NSString*)lastname onCompletion:(MobileClinicSearchResponse)Response;
/**
 * Adds a new visitation record for the given patient. This method will not lock the patient but. This method is meant to be called at the end of the triage workflow. 
 * This method will store the visitation object locally and on the server. It will also update the patient's information on the server as well. 
 * @response Block call that, on completion, will return the visitation object
 * @param visitInfo The visitation information 
 * @param patientInfo The patient to associate the visitation to
 */
-(void)addNewVisit:(NSDictionary *)visitInfo ForCurrentPatient:(NSDictionary *)patientInfo onCompletion:(MobileClinicCommandResponse)Response;
/**
 * Locks the visit from the other users. This lock will not release by itself. The lock will only respond to the user which means that the lock will not work if the user is not logged in.
 * The lock needs to be called whenever the user needs to manipulate data that already exists on the server. 
 * To lock the visit, just pass this method the user's visit information (in a dictionary of course) and the Response block will return whether or not it was successfull via the error variable. 
 * Whether the lock was successful or not the block will always return the updated visit value from the server;
 * @param VisitInfo the visitation dictionary that needs to be locked
 */
-(void) LockVist:(NSDictionary*)VisitInfo onCompletion:(MobileClinicCommandResponse)Response;
/**
 * This will update the give visit in local and remote database. 
 * If the visit is locked by another user the server will not update the visit but instead will throw an error message.
 * You must successfully lock the object before you can call this method.
 * This method has the power to lock the object, but the object must not be in user by another user.
 * This method will returned the updated value to you through the block call. 
 * @param visitRecord the record you want to lock
 * @param unlock TRUE means that the object will be unlocked when the update is completed FALSE will leave the object locked after the update;
 */
-(void) updateVisitRecord:(NSDictionary*)visitRecord andShouldUnlock:(BOOL)unlock onCompletion:(MobileClinicCommandResponse)Response;
/**
 * Using information from the given patient, this method will find all visits related to them.
 * @param patientInfo the patient you want the visits from.
 */
-(void) findAllVisitsForCurrentPatient:(NSDictionary*)patientInfo AndOnCompletion:(MobileClinicSearchResponse)Response;
/**
 * This method will return all open visits. 
 * When a Visit is created in triage it is automatically deemed Open, which means that it should be tracked by the system till the patien leaves.
 * All of the the open visits form a queue that should be used to populate the doctor and pharmacist search list.
 * This is great to help them narrow down who is next and how many is left.
 * If the user selects the visit from the queue it MUST BE LOCKED USING THE @see UpdateVisitRecord or @see LockVisit methods
 * The block returns an array of Visitation ManageObject objects;
 */
-(void) findAllOpenVisitsAndOnCompletion:(MobileClinicSearchResponse)Response;
/**
 * Not Implemented yet
 */
-(void) updateCurrentPatientAndShouldLock:(BOOL)lock onCompletion:(MobileClinicCommandResponse)Response;
/**
 * Not Implemented yet
 */
-(void) findAllPrescriptionForCurrentVisitAndOnCompletion:(MobileClinicSearchResponse)Response;
/**
 * Not Implemented yet
 */
-(void) addNewPrescriptionForCurrentPatientAndUnlockPatient:(NSDictionary*)PrescriptionInfo onCompletion:(MobileClinicCommandResponse)Response;
/**
 * Not Implemented yet
 */
-(void) loadMobileClinicWithPrescriptionRecordForCurrentVisit:(NSDictionary*)visitInfo onCompletion:(MobileClinicCommandResponse)Response;
/**
 * Not Implemented yet
 */
-(void) updatePrescriptionRecord:(NSDictionary*)prescriptionRecord andShouldUnlock:(BOOL)unlock onCompletion:(MobileClinicCommandResponse)Response;
@end
