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

-(NSArray *)FindAllObjectsLocallyFromParentObject;

-(NSString *)printFormattedObject:(NSDictionary *)object;

-(NSArray*)serviceAllObjectsForParentID:(NSString*)parentID;
@end
