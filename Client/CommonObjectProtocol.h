//
//  CommonObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommonObjectProtocol <NSObject>

-(BOOL)loadObjectWithID:(NSString *)ObjectID;

-(void)associateObjectToItsSuperParent:(NSString *)parentID;

-(NSArray *)FindAllObjectsLocallyFromParentObject:(NSDictionary*)parentObject;

-(void)FindAllObjectsOnServerFromParentObject:(NSDictionary*)parentObject OnCompletion:(ObjectResponse)eventResponse;

-(void)UpdateObjectAndShouldLock:(BOOL)shouldLock onComplete:(ObjectResponse)response;

@end
