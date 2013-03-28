//
//  VisitationObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//


#import "VisitationObject.h"
#import "UserObject.h"
#import "StatusObject.h"
#import "Visitation.h"
#import "BaseObject+Protected.h"

#define DATABASE    @"Visitation"
NSString* patientID;
NSString* isLockedBy;
@implementation VisitationObject

+(NSString *)DatabaseName{
    return DATABASE;
}

- (id)init
{
    [self setupObject];
    return [super init];
}
-(id)initAndMakeNewDatabaseObject
{
    [self setupObject];
    return [super initAndMakeNewDatabaseObject];
}
- (id)initAndFillWithNewObject:(NSDictionary *)info
{
    [self setupObject];
    return [super initAndFillWithNewObject:info];
}
-(id)initWithCachedObjectWithUpdatedObject:(NSDictionary *)dic
{
    [self setupObject];
    return [super initWithCachedObjectWithUpdatedObject:dic];
}

-(void)setupObject{
    
    self->COMMONID =  VISITID;
    self->CLASSTYPE = kVisitationType;
    self->COMMONDATABASE = DATABASE;
}

-(void)ServerCommand:(NSDictionary *)dataToBeRecieved withOnComplete:(ServerCommand)response{
    [super ServerCommand:nil withOnComplete:response];
    [self unpackageFileForUser:dataToBeRecieved];
    [self CommonExecution];
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    patientID = [self->databaseObject valueForKey:PATIENTID];
}


-(void)CommonExecution
{
    switch (self->commands) {
        case kUpdateObject:
            [super UpdateObjectAndSendToClient];
            break;
        case kConditionalCreate:
            [self checkForExisitingOpenVisit];
        case kFindObject:
            [self sendSearchResults:[self FindAllObjectsLocallyFromParentObject]];
            break;
        case kFindOpenObjects:
            [self sendSearchResults:[self FindAllOpenVisits]];
            break;
        default:
            break;
    }
}
#pragma mark - COMMON OBJECT Methods
#pragma mark -
-(void)checkForExisitingOpenVisit{
    NSArray* allVisits = [self FindAllOpenVisits];
    
    NSArray* filtered = [allVisits filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@",PATIENTID,patientID]];
   
    if (filtered.count == 0) {
        [super UpdateObjectAndSendToClient];
    }
    else
    {
        [super sendInformation:nil toClientWithStatus:kError andMessage:@"This Patient already has an open visit"];
    }
}
-(NSArray *)FindAllObjectsLocallyFromParentObject{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",PATIENTID,patientID];
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:TRIAGEIN]];
}

-(NSArray *)FindAllObjectsUnderParentID:(NSString *)parentID{
    patientID = parentID;
    return [self FindAllObjectsLocallyFromParentObject];
}

-(NSString *)printFormattedObject:(NSDictionary *)object{
    
   return [NSString stringWithFormat:@" Blood Pressure:\t%@ \n Heart Rate:\t%@ \n Respiration:\t%@ \n Weight:\t%@ \n Condition:\t%@ \n Diagnosis:\t%@ \n Triage In:\t%@ \n Triage Out:\t%@ \n Doctor In:\t%@ \n Doctor Out:\t%@ \n",[object objectForKey:BLOODPRESSURE],[object objectForKey:HEARTRATE],[object objectForKey:RESPIRATION],[object objectForKey:WEIGHT],[object objectForKey:CONDITION],[object objectForKey:OBSERVATION],[[NSDate convertSecondsToNSDate:[object objectForKey:TRIAGEIN]]convertNSDateToMonthNumDayString],[[NSDate convertSecondsToNSDate:[object objectForKey:TRIAGEOUT]]convertNSDateToMonthNumDayString],[[NSDate convertSecondsToNSDate:[object objectForKey:DOCTORIN]]convertNSDateToMonthNumDayString],[[NSDate convertSecondsToNSDate:[object objectForKey:DOCTOROUT]]convertNSDateToMonthNumDayString]];
}
#pragma mark - Private Methods
#pragma mark-

-(NSArray*)FindAllOpenVisits{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == YES",ISOPEN];
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:TRIAGEIN]];
}


@end
