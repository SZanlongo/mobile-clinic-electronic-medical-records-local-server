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
-(id)initWithNewVisit{
    self = [super init];
    if (self) {
        
        self.databaseObject = (Visitation*)[self CreateANewObjectFromClass:DATABASE];
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
    [self linkVisit];
    [visit setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
}



-(void)saveObject:(ObjectResponse)eventResponse
{
    NSLog(@"This does nothing. Please use the PatientObject's <addVisitToCurrentPatient:(VisitationObject *)visitation> method");
}

-(void)CommonExecution
{
    NSLog(@"This does nothing client-side");
}


-(BOOL)isVisitUniqueForVisitID
{
    [self linkVisit];
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
    [self linkVisit];
    NSArray* arr = [self FindObjectInTable:DATABASE withName:visitID forAttribute:VISITID];
    
    if (arr.count == 1) {
        visit = [arr objectAtIndex:0];
        return  YES;
    }
    return  NO;
}
-(void)linkVisit{
    visit = (Visitation*)self.databaseObject;
}
@end
