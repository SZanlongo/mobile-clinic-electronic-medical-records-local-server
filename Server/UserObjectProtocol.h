//
//  UserObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/5/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObjectProtocol.h"

@protocol UserObjectProtocol <NSObject>

-(void)saveObject:(ObjectResponse)eventResponse;
@end
