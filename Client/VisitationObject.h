//
//  VisitationObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
@interface VisitationObject : BaseObject

@property(weak,nonatomic)NSDate* checkInTime;
@property(weak,nonatomic)NSDate* checkOutTime;
@property(weak,nonatomic)NSString* diagnosisNotes;
@property(weak,nonatomic)NSString* diagnosisTitle;
@property(weak,nonatomic)NSString* complaint;
@property(weak,nonatomic)NSString* physicianUsername;
@property(assign,nonatomic)double weight;
@property(assign,nonatomic)BOOL isGraphic;

-(id)initWithVisit:(NSDictionary*)info;
@end
