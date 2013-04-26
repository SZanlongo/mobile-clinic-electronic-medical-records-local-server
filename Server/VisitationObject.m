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
        case kAbort:
            break;
        case kUpdateObject:
            [super UpdateObjectAndSendToClient];
            break;
        case kConditionalCreate:
            [self checkForExisitingOpenVisit];
            break;
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
   
    if (filtered.count <= 1) {
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

-(NSAttributedString *)printFormattedObject:(NSDictionary *)object{

    NSString* titleString = [NSString stringWithFormat:@"Visitation Information \n\n"];
    
    NSMutableAttributedString* title = [[NSMutableAttributedString alloc]initWithString:titleString];
    
    [title addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"HelveticaNeue-Bold" size:20.0] range:[titleString rangeOfString:titleString]];
    
   // [title setAlignment:NSCenterTextAlignment range:[titleString rangeOfString:titleString]];
    
    
    NSMutableAttributedString* container = [[NSMutableAttributedString alloc]initWithAttributedString:title];

    
NSString* main = [NSString stringWithFormat:@" Blood Pressure:\t%@ \n Heart Rate:\t%@ \n Respiration:\t%@ \n Weight:\t%@ \n Condition:\t%@ \n Diagnosis:\t%@ \n Triage In:\t%@ \n Triage Out:\t%@ \n Doctor In:\t%@ \n Doctor Out:\t%@ \n\n",[object objectForKey:BLOODPRESSURE],[object objectForKey:HEARTRATE],[object objectForKey:RESPIRATION],[object objectForKey:WEIGHT],[object objectForKey:CONDITION],[object objectForKey:OBSERVATION],[self convertDateNumberForPrinting:[object objectForKey:TRIAGEIN]],[self convertDateNumberForPrinting:[object objectForKey:TRIAGEOUT]],[self convertDateNumberForPrinting:[object objectForKey:DOCTORIN]],[self convertDateNumberForPrinting:[object objectForKey:DOCTOROUT]]];
    
    NSMutableAttributedString* line1 = [[NSMutableAttributedString alloc]initWithString:main];
    
    [line1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"HelveticaNeue" size:16.0] range:[main rangeOfString:main]];
    
    [container appendAttributedString:line1];
    
    return container;
}
-(NSString*)convertDateNumberForPrinting:(NSNumber*)number{
    if (number) {
        return [[NSDate convertSecondsToNSDate:number]convertNSDateToMonthNumDayString];
    }
    return @"N/A";
}
-(NSArray *)FindAllObjects{
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:TRIAGEIN]];
}

-(void)UnlockVisit:(ObjectResponse)onComplete{
    [self setObject:@"" withAttribute:ISLOCKEDBY];
    [self saveObject:onComplete];
}
#pragma mark - Private Methods
#pragma mark-

-(NSArray*)FindAllOpenVisits{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == YES",ISOPEN];
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:TRIAGEIN]];
}

-(NSArray *)covertAllSavedObjectsToJSON{
    
    NSArray* allPatients= [self FindObjectInTable:COMMONDATABASE withCustomPredicate:[NSPredicate predicateWithFormat:@"%K == YES",ISDIRTY] andSortByAttribute:VISITID];
    NSMutableArray* allObject = [[NSMutableArray alloc]initWithCapacity:allPatients.count];
    
    for (NSManagedObject* obj in allPatients) {
        [allObject addObject:[obj dictionaryWithValuesForKeys:[obj attributeKeys]]];
    }
    return  allObject;
}

@end
