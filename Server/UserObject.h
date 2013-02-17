//
//  UserObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#define SAVE_USER @"savedUser"
#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "Users.h"
typedef enum {
    kTriageNurse    = 0,
    kDoctor         = 1,
    kPharmacists    = 2,
    kAppAdmin       = 3,
    kRecordKeeper   = 4
}UserTypes;



@interface UserObject : BaseObject<BaseObjectProtocol>

@property(nonatomic, strong)      Users* user;
@property(nonatomic, weak)      NSString* lastname;
@property(nonatomic, weak)      NSString* firstname;
@property(nonatomic, weak)      NSString* email;
@property(nonatomic, assign)    BOOL      status;
@property(nonatomic, weak)      NSString* username;
@property(nonatomic, weak)      NSString* password;
@property(nonatomic, assign)    UserTypes type;

-(void)CreateANewUser:(ObjectResponse)onSuccessHandler;

-(BOOL)loadUserWithUsername:(NSString*)usersName;
@end
