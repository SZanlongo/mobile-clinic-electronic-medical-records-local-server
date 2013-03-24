//
//  UserObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/5/13.
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
#import "BaseObjectProtocol.h"
#import "CommonObjectProtocol.h"
@protocol UserObjectProtocol <NSObject>

-(void)SyncAllUsersToLocalDatabase:(ObjectResponse)responder;
@end
