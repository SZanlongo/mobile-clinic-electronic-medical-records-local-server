//
//  PrescriptionObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/11/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "PrescriptionObject.h"
#define DATABASE    @"Prescription"
NSString* visitID;
NSString* isLockedBy;
@implementation PrescriptionObject

#pragma mark - BaseObjectProtocol Methods
#pragma mark -

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
    
    self.COMMONID =  PRESCRIPTIONID;
    self.CLASSTYPE = kPrescriptionType;
    self.COMMONDATABASE = DATABASE;
}

-(void)ServerCommand:(NSDictionary *)dataToBeRecieved withOnComplete:(ServerCommand)response{
    [super ServerCommand:nil withOnComplete:response];
    [self unpackageFileForUser:dataToBeRecieved];
    [self CommonExecution];
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    visitID = [self.databaseObject valueForKey:VISITID];
}


-(void)CommonExecution
{
    switch (self.commands) {
        case kUpdateObject:
            [super UpdateObjectAndSendToClient];
            break;
            
        case kFindObject:
            [self sendSearchResults:[self FindAllObjectsLocallyFromParentObject]];            break;
            
        default:
            break;
    }
}

#pragma mark - COMMON OBJECT Methods
#pragma mark -
-(NSArray *)FindAllObjectsLocallyFromParentObject{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",VISITID,visitID];
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:PRESCRIBETIME]];
}

-(NSArray *)FindAllObjectsUnderParentID:(NSString *)parentID{
    visitID = parentID;
    return [self FindAllObjectsLocallyFromParentObject];
}
-(NSString *)printFormattedObject:(NSDictionary *)object{
    return [NSString stringWithFormat:@" Medication Name:\t%@ \n Dose:\t%@ \n Notes:\t%@ \n ",[object objectForKey:MEDICATIONID],[object objectForKey:TABLEPERDAY],[object objectForKey:INSTRUCTIONS]];
}
@end
