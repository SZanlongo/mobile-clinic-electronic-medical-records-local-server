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
    
    self.COMMONID =  VISITID;
    self.CLASSTYPE = kVisitationType;
    self.COMMONDATABASE = DATABASE;
}

-(void)ServerCommand:(NSDictionary *)dataToBeRecieved withOnComplete:(ServerCommand)response{
    [super ServerCommand:nil withOnComplete:response];
    [self unpackageFileForUser:dataToBeRecieved];
    [self CommonExecution];
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    patientID = [data objectForKey:PATIENTID];
}


-(void)CommonExecution
{
    switch (self.commands) {
        case kUpdateObject:
            [super UpdateObjectAndSendToClient];
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
-(NSArray *)FindAllObjectsLocallyFromParentObject{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",PATIENTID,patientID];    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:TRIAGEIN]];
}

-(NSArray *)serviceAllObjectsForParentID:(NSString *)parentID{
    patientID = parentID;
    return [self FindAllObjectsLocallyFromParentObject];
}
#pragma mark - Private Methods
#pragma mark-

-(NSArray*)FindAllOpenVisits{

    BOOL isOpen = [self.databaseObject valueForKey:ISOPEN];
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == YES",ISOPEN];

    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:TRIAGEIN]];
}

-(void)linkDatabaseObject{
    visit = (Visitation*)self.databaseObject;
}
@end
