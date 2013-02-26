//
//  BaseObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define DATABASEOBJECT @"Database Object"

#import <Foundation/Foundation.h>
#import "DatabaseDriver.h"
#import "BaseObjectProtocol.h"
#import "DataProcessor.h"
#import "NSString+StringExt.h"

@interface BaseObject : DatabaseDriver <BaseObjectProtocol>{
   /* This is a callback block variable 
    * Its type can be found int he BaseObjectProtocol
    */
    ObjectResponse respondToEvent;
}

@property(nonatomic, weak)      id client;
@property(nonatomic, assign)    ObjectTypes objectType;
@property(nonatomic, assign)    RemoteCommands commands;
@property(strong, nonatomic)    NSManagedObject* databaseObject;
/**
 * <<This method SHOULD NOT be used by anyone. This method will be hidden in future releases.>>
 This method checks to see if the device is connected to the server before it attempts to send data. 
 @param data the data that should be sent to the server
 @param negativeResponse if the client is not connect to the server then the methods wihin this block will be fired. This will give the user a chance to run their method even if the server is unable to respond to the request.
 */
-(void)tryAndSendData:(NSDictionary*)data withErrorToFire:(ObjectResponse)negativeResponse;
@end
