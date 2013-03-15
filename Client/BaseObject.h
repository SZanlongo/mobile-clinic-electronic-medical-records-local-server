//
//  BaseObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DatabaseDriver.h"
#import "BaseObjectProtocol.h"
#import "DataProcessor.h"
#import "NSString+StringExt.h"
#import "NSObject+CustomTools.h"

@interface BaseObject : DatabaseDriver <BaseObjectProtocol>{
   /* This is a callback block variable 
    * Its type can be found int he BaseObjectProtocol
    */
    ObjectResponse respondToEvent;
}

/** This needs to be set everytime information is recieved
 * by the serverCore, so it knows how to send information
 * back
 */
@property(nonatomic, weak)      id client;

/** This needs to be set (during unpackageFileForUser:(NSDictionary*)data
 * method) so that any recieving device knows how to unpack the
 * information
 */
@property(nonatomic, assign)    ObjectTypes objectType;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
@property(nonatomic, assign)    RemoteCommands commands;

/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
@property(strong, nonatomic)NSManagedObject* databaseObject;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
@property(nonatomic, weak)      NSString* COMMONDATABASE;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
@property(nonatomic, weak)      NSString* COMMONID;
/** This needs to be set during the unpackageFileForUser:(NSDictionary*)data
 * method so the recieving device knows how to execute the request via
 * the CommonExecution method
 */
@property(nonatomic, assign)    NSInteger CLASSTYPE;

+(NSString*)getCurrenUserName;
@end
