//
//  BaseObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/1/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define ISLOCKEDBY          @"isLockedBy"
#define OBJECTTYPE          @"objectType"
#define OBJECTCOMMAND       @"userCommand" //The different user types (look at enum)
#define ALLITEMS            @"ALL_ITEMS"

#import <Foundation/Foundation.h>

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
    kConditionalCreate          = 8,
}RemoteCommands;

@protocol BaseObjectProtocol <NSObject>

typedef void (^ObjectResponse)(id<BaseObjectProtocol> data, NSError* error);
typedef void (^ServerCommand)(NSDictionary* dataToBeSent);

@required
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

-(void)UpdateObjectAndSendToClient;

-(NSMutableArray*)convertListOfManagedObjectsToListOfDictionaries:(NSArray*)managedObjects;

-(void)sendSearchResults:(NSArray*)results;

- (void)ServerCommand:(NSDictionary*)dataToBeRecieved withOnComplete:(ServerCommand)response;
/* This method should take all the objects important information
 * and place them inside a dictionary with keys that should be
 * reflected in the server.
 *
 * Once packaged, return the dictionary
 */
-(NSDictionary*) consolidateForTransmitting;

/* This should only take in a dictionary that contains information
 * for the object that is unpackaging it.
 *
 * This means that the if a Class called Face is unpackaging the
 * dictionary, then the dictionary's type should be tested to see
 * if it is of type Face. This can be done by looking at the object
 * for key: OBJECTTYPE
 */
-(void) unpackageFileForUser:(NSDictionary*)data;

/* This only needs to be implemented if the object needs to save to
 * its local database
 */
-(void)saveObject:(ObjectResponse)eventResponse;

/* This needs to be implemented at all times. This is responsible for
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

/* This needs to be set everytime information is recieved
 * by the serverCore, so it knows how to send information
 * back
 */
@property(nonatomic, weak)      id client;

/* This needs to be set (during unpackageFileForUser:(NSDictionary*)data
 * method) so that any recieving device knows how to unpack the
 * information
 */
@property(nonatomic, assign)    ObjectTypes objectType;
/* This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
@property(nonatomic, assign)    RemoteCommands commands;

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

/**
 This is the setter for the databaseObject that all objects that implement this protocal must have
 @param databaseObject the coredata object that you want to manipulate
 */
-(void)setDBObject:(NSManagedObject*)DatabaseObject;

-(NSMutableDictionary*)getDictionaryValuesFromManagedObject;

-(BOOL)loadObjectForID:(NSString *)objectID;

-(NSManagedObject*)loadObjectWithID:(NSString *)objectID;

@property(strong, nonatomic)NSManagedObject* databaseObject;

-(void)sendInformation:(id)data toClientWithStatus:(int)kStatus andMessage:(NSString*)message;

-(BOOL)isObject:(id)obj UniqueForKey:(NSString*)key;

-(void)copyDictionaryValues:(NSDictionary*)dictionary intoManagedObject:(NSManagedObject*)mObject;

-(void)setValueToDictionaryValues:(NSDictionary*)values;

-(NSMutableDictionary*)getDictionaryValuesFromManagedObject:(NSManagedObject*)object;
@end
