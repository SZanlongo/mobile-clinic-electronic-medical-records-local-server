//
//  VisitationObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "VisitationObject.h"
#define DATABASE    @"Visitation"

#import "StatusObject.h"
#import "Visitation.h"
@implementation VisitationObject
- (id)init
{
    self = [super init];
    if (self) {
        [self linkVisit];
    }
    return self;
}
-(id)initWithNewVisit{
    self = [super init];
    if (self) {
        self.databaseObject = (Visitation*)[super CreateANewObjectFromClass:DATABASE];
        [self linkVisit];
    }
    return self;
}
- (id)initWithVisit:(Visitation *)info
{
    self = [super init];
    if (self) {        
        self.databaseObject = info;
        [self linkVisit];
    }
    return self;
}

-(NSDictionary *)consolidateForTransmitting:(NSManagedObject *)object{
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting:object]];
    [consolidate setValue:[NSNumber numberWithInt:kVisitationType] forKey:OBJECTTYPE];
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    [visit setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
}



-(BOOL)isVisitUniqueForVisitID
{
    NSArray* pastVisits = [self FindObjectInTable:DATABASE withName:visit.visitationId forAttribute:VISITID];
    
    if (pastVisits.count > 0) {
        return NO;
    }
    
    return YES;
}

-(void)addPrescriptionToCurrentVisit:(PrescriptionObject *)prescription{
[self linkVisit];
    _currentPrescription = prescription;
    [visit addPrescriptionObject:(Prescription*)_currentPrescription.databaseObject];
    [_currentPrescription setObject:visit.visitationId withAttribute:PATIENTID];
}

-(BOOL)loadVisitWithVisitationID:(NSString *)visitID{
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:DATABASE withName:visitID forAttribute:VISITID];
    
    if (arr.count == 1) {
        visit = [arr objectAtIndex:0];
        return  YES;
    }
    return  NO;
}
-(void)SetTriageCheckinTime{
    [visit setTriageIn:[NSDate date]];
}

-(void)SetTriageCheckOutTime{
    [visit setTriageOut:[NSDate date]];
}

-(void)SetDoctorCheckinTime{
    [visit setDoctorIn:[NSDate date]];
}

-(void)SetDoctorCheckOutTime{
    [visit setDoctorOut:[NSDate date]];
}
-(void)associateUserToNurseId{
    [visit setNurseId:self.appDelegate.currentUserName];
}
-(void)associateUserToDoctorId{
    [visit setDoctorId:self.appDelegate.currentUserName];
}
-(void)linkVisit{
    visit = (Visitation*)self.databaseObject;
}
@end
