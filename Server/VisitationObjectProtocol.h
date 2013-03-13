//
//  VisitationObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/10/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define TRIAGEIN    @"triageIn"
#define TRIAGEOUT   @"triageOut"
#define DOCTORID    @"doctorId"
#define PATIENTID   @"patientId"
#define DOCTORIN    @"doctorIn"
#define DOCTOROUT   @"doctorOut"
#define CONDITION   @"condition"
#define DTITLE      @"diagnosisTitle"
#define GRAPHIC     @"isGraphic"
#define WEIGHT          @"weight" //The different user types (look at enum)
#define OBSERVATION     @"observation"
#define NURSEID         @"nurseId"
#define BLOODPRESSURE   @"bloodPressure"
#define VISITID         @"visitationId"


#define ISOPEN      @"isOpen"
#define ALLVISITS   @"all visits"
#import <Foundation/Foundation.h>

@protocol VisitationObjectProtocol <NSObject>

-(NSArray*)getVisitsForPatientWithID:(NSString*)pID;
@end
