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



#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "Users.h"
/* Users of the system */
typedef enum {
    kTriageNurse    = 0,
    kDoctor         = 1,
    kPharmacist     = 2,
    kAppAdmin       = 3,
    kRecordKeeper   = 4,
}UserTypes;

@interface UserObject : BaseObject
@property(nonatomic, strong)      Users* user;

-(id)initWithNewUser;
/* call to send this object to be verified by the server */
-(void)loginWithUsername:(NSString*)username andPassword:(NSString*)password onCompletion:(ObjectResponse)onSuccessHandler;

/* call to send this object to be create a new user to be authorized */
-(void)CreateANewUser:(ObjectResponse)onSuccessHandler;

-(BOOL)loadUserWithUsername:(NSString *)usersName;
@end
