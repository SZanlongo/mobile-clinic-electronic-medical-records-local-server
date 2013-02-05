//
//  BaseObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/1/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#define OBJECTTYPE        @"objectType"
#define OBJECTCOMMAND     @"userCommand" //The different user types (look at enum)

#import <Foundation/Foundation.h>

/* These are all the classes the server and client will know how to handle */
typedef enum {
    kUserType       = 1,
    kStatusType     = 2,
}ObjectTypes;

/* These are all the commands the server and client will understand */
typedef enum {
    kCreateNewUser  = 0,
    kLoginUser      = 1,
    kLogoutUser     = 2,
    kStatusClientWillRecieve     = 3,
    kStatusServerWillRecieve     = 4,
}RemoteCommands;

@protocol BaseObjectProtocol <NSObject>

typedef void (^ObjectResponse)(id <BaseObjectProtocol> data, NSError* error);

@optional
//-(void) unpackageDatabaseFileForUser:(NSManagedObject*)object;

@required
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

@end

