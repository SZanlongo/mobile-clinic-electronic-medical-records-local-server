//
//  CommonObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#define ISDIRTY @"isDirty"

#import "BaseObjectProtocol.h"
#import <Foundation/Foundation.h>

@protocol CommonObjectProtocol <BaseObjectProtocol>

+(NSString*)DatabaseName;

-(NSArray*)FindAllObjects;

-(NSAttributedString *)printFormattedObject:(NSDictionary *)object;

-(NSArray*)FindAllObjectsUnderParentID:(NSString*)parentID;

-(void)pushToCloud:(CloudCallback)onComplete;

-(void)pullFromCloud:(CloudCallback)onComplete;

@end
