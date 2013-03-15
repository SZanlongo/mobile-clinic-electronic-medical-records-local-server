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


#define STATUS      @"status"
#define EMAIL       @"email"
#define FIRSTNAME   @"firstName"
#define LASTNAME    @"lastName"
#define USERNAME    @"userName"
#define PASSWORD    @"password"
#define USERTYPE    @"userType"
#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "Users.h"
#import "UserObjectProtocol.h"
/* Users of the system */
typedef enum {
    kTriageNurse    = 0,
    kDoctor         = 1,
    kPharmacist     = 2,
    kAppAdmin       = 3,
    kRecordKeeper   = 4,
}UserTypes;

@interface UserObject : BaseObject<UserObjectProtocol,CommonObjectProtocol>{
    Users* user;
}    


@end
