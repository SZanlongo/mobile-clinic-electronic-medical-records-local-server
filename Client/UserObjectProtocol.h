//
//  UserObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/15/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonObjectProtocol.h"

@protocol UserObjectProtocol <NSObject>

/* call to send this object to be verified by the server */
-(void)loginWithUsername:(NSString*)username andPassword:(NSString*)password onCompletion:(ObjectResponse)onSuccessHandler;

@end
