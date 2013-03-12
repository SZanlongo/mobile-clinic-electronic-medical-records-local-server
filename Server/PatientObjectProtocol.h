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
#define PICTURE         @"photo"
#define VISITS          @"visits"
#define PATIENTID       @"patientId"
#define ALL_PATIENTS    @"all patients"
#define ISLOCKEDBY      @"isLockedBy"
#define DATABASE        @"Patients"
#import <Foundation/Foundation.h>

@protocol PatientObjectProtocol <NSObject>
-(id)init;
-(void) UnlockPatient;
-(void) PushPatientsToCloud;
-(void) SyncPatientsWithCloud;
@end
