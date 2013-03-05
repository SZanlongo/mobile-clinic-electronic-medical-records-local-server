//
//  PatientObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/1/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#define FIRSTNAME   @"firstName"
#define FAMILYNAME  @"familyName"
#define VILLAGE     @"villageName"
#define HEIGHT      @"height"
#define SEX         @"sex"
#define DOB         @"age"
#define PICTURE     @"photo"
#import "DataProcessor.h"
#import "BaseObjectProtocol.h"
@protocol PatientObjectProtocol <NSObject>

/**
 * Stores the new patient in the local and remote database
 @onSuccHandler Block call that is fired after the patient is stored in the local database
 */
-(void)createNewPatientLocally:(ObjectResponse)onSuccessHandler;
/**
 *Searches the local database (Client-side) for patient that has any combination of the first and last name
 @param firstname the firstname of the patient you are looking for
 @param lastname the lastname of the patient you are looking for
 @return All the patients the has the specified first or last name
 */
-(NSArray *)FindAllPatientsLocallyWithFirstName:(NSString *)firstname andWithLastName:(NSString *)lastname;
/**
 *Searches the Remote database (Server-side) for patient that has any combination of the first and last name and stores it in local database
 @param firstname the firstname of the patient you are looking for
 @param lastname the lastname of the patient you are looking for
 @param eventResponse called when the client updated the database with the server's completed search. You should call, within the block method, FindAllPatientsLocallyWith... method to get the list of patients you are searching for.
 */
-(void)FindAllPatientsOnServerWithFirstName:(NSString *)firstname andWithLastName:(NSString *)lastname onCompletion:(ObjectResponse)eventResponse;

-(NSManagedObject *)getDBObject;
/**
 * Loads this object with the patient that matches the ID
 @param patientID the ID of the patient that you are looking for
 @return if the patient loaded successful then it returns TRUE
 */
-(BOOL)loadPatientWithPatientID:(NSString *)patientId;
/**
 * This will update any existing patient.
 * If the patient is locked an error message will be sent. If the patient was locked under the current user's care, then the patient will be unlocked. So make sure that this is the last method you call before updating a patient.
 *@Param response the block that will be call once the server completes the update
 */
-(void)UpdateAndLockPatientObject:(BOOL)shouldLock onComplete:(ObjectResponse)response;
@end
