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
        _visit = (Visitation*)[self CreateANewObjectFromClass:DATABASE];
    }
    return self;
}
- (id)initWithVisit:(Visitation *)info
{
    self = [super init];
    if (self) {
        _visit = info;
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
    [_visit setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
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
    NSArray* pastVisits = [self FindObjectInTable:DATABASE withName:_visit.visitationId forAttribute:VISITID];
    
    if (pastVisits.count > 0) {
        return NO;
    }
    
    return YES;
}
-(BOOL)loadVisitWithVisitationID:(NSString *)visitID{
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:DATABASE withName:visitID forAttribute:VISITID];
    
    if (arr.count == 1) {
        _visit = [arr objectAtIndex:0];
        return  YES;
    }
    return  NO;
}

-(void)setObject:(id)object withAttribute:(NSString *)attribute{
    if (_visit) {
        [_visit setValue:object forKey:attribute];
    }
}

-(id)getObjectForAttribute:(NSString *)attribute{
    return [self getValueForKey:attribute fromObject:_visit];
}
@end
