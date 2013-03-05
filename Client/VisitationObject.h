//
//  VisitationObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "PrescriptionObject.h"
#import "Visitation.h"
#import "VisitationObjectProtocol.h"
@interface VisitationObject : BaseObject<VisitationObjectProtocol>{
    Visitation* visit;
}

@property(nonatomic, strong)    PrescriptionObject* currentPrescription;

-(void)linkVisit;

+(NSString*)DatabaseName;
@end
