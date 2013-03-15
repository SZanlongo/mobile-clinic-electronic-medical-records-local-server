//
//  CommonObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#import "BaseObjectProtocol.h"
#import <Foundation/Foundation.h>

@protocol CommonObjectProtocol <NSObject>

+(NSString*)DatabaseName;

-(void)associateObjectToItsSuperParent:(NSDictionary *)parent;

-(void)createNewObject:(NSDictionary*) object Locally:(ObjectResponse)onSuccessHandler;

-(NSArray *)FindAllObjectsLocallyFromParentObject:(NSDictionary*)parentObject;

-(void)FindAllObjectsOnServerFromParentObject:(NSDictionary*)parentObject OnCompletion:(ObjectResponse)eventResponse;

@end
