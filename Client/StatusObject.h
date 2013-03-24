//
//  StatusObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

/* 
 * Listeners That should be set: 
 * GLOBAL_STATUS_LISTENER - set if you expecting a message back from the server
 *
 */
 
#define DATA      @"data to transfer"
#define STATUS    @"status"

#import "NSObject+CustomTools.h"
#import "BaseObjectProtocol.h"
typedef enum {
    kSuccess                        = 0,
    kError                          = 1,
    kErrorDisconnected              = 3,
    kErrorObjectMisconfiguration    = 4,
    kErrorUserDoesNotExist          = 5,
    kErrorIncorrectLogin            = 6,
    kErrorPermissionDenied          = 7,
    kErrorIncompleteSearch          = 8,
} ServerStatus;

@interface StatusObject : NSObject <BaseObjectProtocol>


@property(nonatomic, weak)      NSString* errorMessage;
@property(nonatomic, weak)      NSDictionary* data;
@property(nonatomic, assign)    ServerStatus status;


#pragma mark - BaseObjectProtocol Variables
#pragma mark
 
@property(nonatomic, weak)      id client;
@property(nonatomic, assign)    ObjectTypes objectType;
@property(nonatomic, assign)    RemoteCommands commands;


@end
