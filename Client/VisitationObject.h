//
//  VisitationObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "Visitation.h"
@interface VisitationObject : BaseObject

@property(weak,nonatomic)Visitation* visit;

-(id)initWithNewVisit;
-(id)initWithVisit:(Visitation*)info;
-(BOOL)loadVisitWithVisitationID:(NSString *)visitID;
@end
