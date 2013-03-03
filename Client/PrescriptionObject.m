//
//  PrescriptionObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/25/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#define PRESCRIPTIONID  @"prescriptionId"
#define DATABASE    @"Prescription"
#import "PrescriptionObject.h"

@implementation PrescriptionObject


-(NSDictionary *)consolidateForTransmitting:(NSManagedObject *)object{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting]];
    
    [consolidate setValue:[NSNumber numberWithInt:kPrescriptionType] forKey:OBJECTTYPE];
    
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    [prescription setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
}


-(void)saveObject:(ObjectResponse)eventResponse
{
    NSLog(@"This does nothing. Please use the PatientObject's <addVisitToCurrentPatient:(VisitationObject *)visitation> method");
}

-(void)CommonExecution
{
    NSLog(@"This does nothing client-side");
}

-(BOOL)loadPrescriptionWithPrescriptionID:(NSString *)prescriptionID{
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:DATABASE withName:prescriptionID forAttribute:prescriptionID];
    
    if (arr.count == 1) {
        prescription = [arr objectAtIndex:0];
        return  YES;
    }
    return  NO;
}
@end
