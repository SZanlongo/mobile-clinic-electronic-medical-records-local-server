//
//  UserObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define STATUS      @"status"
#define EMAIL       @"email"
#define FIRSTNAME   @"firstName"
#define LASTNAME    @"lastName"
#define USERNAME    @"userName"
#define PASSWORD    @"password"
#define USERTYPE    @"userType" //The different user types (look at enum)
#define SAVE_USER @"savedUser"
#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "Users.h"
#import "UserObjectProtocol.h"
typedef enum {
    kTriageNurse    = 0,
    kDoctor         = 1,
    kPharmacists    = 2,
    kAppAdmin       = 3,
    kRecordKeeper   = 4
}UserTypes;



@interface UserObject : BaseObject<UserObjectProtocol>{
    Users* user;
}

//@property(nonatomic, strong)      Users* user;
- (id)initWithExistingWithID:(NSString*)username;
-(id)init;
-(void)SyncAllUsersToLocalDatabase:(ObjectResponse)responder;
-(NSArray*)getAllUsersFromDatabase;
-(BOOL)loadUserWithUsername:(NSString*)usersName;
@end
