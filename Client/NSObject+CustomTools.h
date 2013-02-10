//
//  NSObject+CustomTools.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/5/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ScreenHandler)(id object, NSError* error);

@interface NSObject (CustomTools)
-(NSError *)createErrorWithDescription:(NSString *)description andErrorCodeNumber:(int)code inDomain:(NSString*)domain;
@end
