//
//  SystemBackup.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 4/15/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "SystemBackup.h"
#import "PatientObject.h"
#import "UserObject.h"
#import "VisitationObject.h"
#import "PrescriptionObject.h"
#import "MedicationObject.h"

#define BACK_UP         @"MC-EMR BACKUP"
@implementation SystemBackup

+(NSError*)BackupEverything{
    
    PatientObject* patient = [[PatientObject alloc]init];
    UserObject* user = [[UserObject alloc]init];
    VisitationObject* visit = [[VisitationObject alloc]init];
    PrescriptionObject* prescript = [[PrescriptionObject alloc]init];
    MedicationObject* medic = [[MedicationObject alloc]init];

    NSMutableDictionary* Container = [[NSMutableDictionary alloc]initWithCapacity:4];
    
    [Container setObject:[patient covertAllSavedObjectsToJSON] forKey:[PatientObject DatabaseName]];
    [Container setObject:[user covertAllSavedObjectsToJSON] forKey:[UserObject DatabaseName]];
    [Container setObject:[visit covertAllSavedObjectsToJSON] forKey:[VisitationObject DatabaseName]];
    [Container setObject:[prescript covertAllSavedObjectsToJSON] forKey:[PrescriptionObject DatabaseName]];
    [Container setObject:[medic covertAllSavedObjectsToJSON] forKey:[MedicationObject DatabaseName]];
    
    return [SystemBackup overWritePList:Container];
}

+(NSError*)overWritePList:(NSDictionary*)file{
    NSString* plistPath = nil;
    NSFileManager* manager = [NSFileManager defaultManager];
    plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@".plist"];
    
    NSError* error = nil;
    
    if (plistPath)
    {
        if ([manager isWritableFileAtPath:plistPath])
        {
            NSMutableDictionary* infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            [infoDict setObject:file forKey:BACK_UP];
            [infoDict writeToFile:plistPath atomically:NO];
            
            [manager setAttributes:[NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate] ofItemAtPath:[[NSBundle mainBundle] bundlePath] error:&error];
        }
        
    }
    return error;
}
@end
