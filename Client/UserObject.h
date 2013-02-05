//
//  UserObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

/*
 * Listeners That should be set:
 *
 *
 */

#define SAVECOMPLETE @"savedone"

#import <Foundation/Foundation.h>
#import "BaseObject.h"

/* Users of the system */
typedef enum {
    kTriageNurse    = 0,
    kDoctor         = 1,
    kPharmacist     = 2,
    kAppAdmin       = 3,
    kRecordKeeper   = 4,
}UserTypes;

@interface UserObject : BaseObject
@property(nonatomic, weak)      NSString* lastname;
@property(nonatomic, weak)      NSString* firstname;
@property(nonatomic, weak)      NSString* email;
@property(nonatomic, assign)    BOOL      status;
@property(nonatomic, weak)      NSString* username;
@property(nonatomic, weak)      NSString* password;
@property(nonatomic, assign)    UserTypes type;
/* call to send this object to be verified by the server */
-(void)login:(ObjectResponse)onSuccessHandler;

/* call to send this object to be create a new user to be authorized */
-(void)CreateANewUser:(ObjectResponse)onSuccessHandler;
@end
