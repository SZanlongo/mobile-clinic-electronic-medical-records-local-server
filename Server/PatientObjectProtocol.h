//
//  PatientObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/10/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#define FIRSTNAME       @"firstName"
#define FAMILYNAME      @"familyName"
#define VILLAGE         @"villageName"
#define HEIGHT          @"height"
#define SEX             @"sex"
#define DOB             @"age"
#define PICTURE         @"picture"
#define VISITS          @"visits"
#define PATIENTID       @"patientId"
#define ISLOCKEDBY      @"isLockedBy"
#define DATABASE        @"Patients"
#import <Foundation/Foundation.h>
#import "CommonObjectProtocol.h"
@protocol PatientObjectProtocol <NSObject>


-(NSArray*)FindAllOpenPatients;
-(void)UnlockPatient:(ObjectResponse)onComplete;

@end
