//
//  UserObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

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

@interface UserObject : BaseObject<UserObjectProtocol,CommonObjectProtocol>{
    Users* user;
}

//@property(nonatomic, strong)      Users* user;

@end
