//
//  BaseObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/1/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define DATABASEOBJECT      @"Database Object"
#define ISLOCKEDBY          @"isLockedBy"
#define SAVECOMPLETE        @"savedone"
#define OBJECTTYPE          @"objectType"
#define OBJECTCOMMAND       @"userCommand" //The different user types (look at enum)
#define ALLITEMS            @"ALL_ITEMS"

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ServerProtocol.h"
/* These are all the classes the server and client will know how to handle */
typedef enum {
    kUserType           = 1,
    kStatusType         = 2,
    kPatientType        = 3,
    kVisitationType     = 4,
    kPharmacyType       = 5,
    kPrescriptionType   = 6,
    kMedicationType     = 7,
}ObjectTypes;

/* These are all the commands the server and client will understand */
typedef enum {
    kPullAllUsers               = 0,
    kLoginUser                  = 1,
    kLogoutUser                 = 2,
    kStatusClientWillRecieve    = 3,
    kStatusServerWillRecieve    = 4,
    kUpdateObject               = 5,
    kFindObject                 = 6,
    kFindOpenObjects            = 7,
}RemoteCommands;

@protocol BaseObjectProtocol <NSObject>

typedef void (^ObjectResponse)(id <BaseObjectProtocol> data, NSError* error);

@optional

/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
- (id)init;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
- (id)initAndMakeNewDatabaseObject;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
- (id)initAndFillWithNewObject:(NSDictionary *)info;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
- (id)initWithCachedObjectWithUpdatedObject:(NSDictionary*)dic;

/** This should only take in a dictionary that contains information
 * for the object that is unpackaging it.
 *
 * This means that the if a Class called Face is unpackaging the 
 * dictionary, then the dictionary's type should be tested to see 
 * if it is of type Face. This can be done by looking at the object 
 * for key: OBJECTTYPE
 */
-(void) unpackageFileForUser:(NSDictionary*)data;

/** This only needs to be implemented if the object needs to save to
 * its local database
 */
-(void)saveObject:(ObjectResponse)eventResponse;

/** This needs to be implemented at all times. This is responsible for
 * carrying out the instructions that it was given.
 *
 * Instruction should be determined using switch statement on the 
 * variable RemoteCommands commands (see properties at the bottom).
 * during the unpackageFileForUser:(NSDictionary*)data method, make 
 * sure you save the method to the previously mentioned variable.
 * That way when CommonExecution method is called it knows what to 
 * execute.
 *
 * If you want to add more methods that you think the server needs to
 * interpret add it to the RemoteCommands typedef above and add it 
 * to the opposite systems typedef. (make sure you implement it in the
 * appropriate place in the both the Client & Server)
 */
-(void)CommonExecution;


/**
 * Use this to retrieve objects/values from the Patient object.
 *@param attribute the name of the attribute you want to retrieve.
 */
-(id)getObjectForAttribute:(NSString*)attribute;

/**
 * Use this to save attributes of the object. For instance, to the Patient's Firstname can be saved by passing the string of his name and the Attribute FIRSTNAME
 *@param object object that needs to be stored in the database
 *@param attribute the name of the attribute or the key to which the object needs to be saved
 */
-(void)setObject:(id)object withAttribute:(NSString*)attribute;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
-(void)tryAndSendData:(NSDictionary*)data withErrorToFire:(ObjectResponse)negativeResponse andWithPositiveResponse:(ServerCallback)posResponse;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
-(void)setValueToDictionaryValues:(NSDictionary*)values;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
-(NSMutableDictionary*)getDictionaryValuesFromManagedObject;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
-(void)UpdateObject:(ObjectResponse)response shouldLock:(BOOL)shouldLock andSendObjects:(NSMutableDictionary*)dataToSend withInstruction:(NSInteger)instruction;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
-(BOOL)loadObjectForID:(NSString *)objectID;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
-(NSManagedObject*)loadObjectWithID:(NSString *)objectID;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
-(NSMutableArray*)convertListOfManagedObjectsToListOfDictionaries:(NSArray*)managedObjects;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
-(void)SaveListOfObjectsFromDictionary:(NSDictionary*)patientList;
@end

