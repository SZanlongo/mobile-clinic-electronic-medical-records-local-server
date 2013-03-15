//
//  MedicationObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/15/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define DATABASE    @"Medication"
#import "MedicationObject.h"

NSString* medicationID;

@implementation MedicationObject

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
    
    self.COMMONID =  MEDICATIONID;
    self.CLASSTYPE = kMedicationType;
    self.COMMONDATABASE = DATABASE;
}
-(void)ServerCommand:(NSDictionary *)dataToBeRecieved withOnComplete:(ServerCommand)response{
    [super ServerCommand:nil withOnComplete:response];
    [self unpackageFileForUser:dataToBeRecieved];
    [self CommonExecution];
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    medicationID = [data objectForKey:MEDICATIONID];
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
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:MEDNAME]];
}
@end
