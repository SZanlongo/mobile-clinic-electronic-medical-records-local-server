//
//  PatientObject.h
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/11/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#define SAVE_USER @"savedUser"
#import <Foundation/Foundation.h>

#import "BaseObject.h"
#import "VisitationObject.h"
#import "Patients.h"
@interface PatientObject : BaseObject

//----> 0 = Female, 1 = Male <---//
@property(nonatomic, strong)        Patients* patient;
@property(nonatomic, strong)        NSMutableArray* visits;

-(void)addVisitToPatient:(VisitationObject*)visit;
@end
