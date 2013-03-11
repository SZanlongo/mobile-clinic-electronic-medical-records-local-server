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

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithVisit:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        
        if ([info.allKeys containsObject:DATABASEOBJECT]) {
            [self unpackageFileForUser:info];
        }else{
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:info,DATABASEOBJECT, nil];
            [self unpackageFileForUser:dic];
        }
    }
    return self;
}

-(NSDictionary *)consolidateForTransmitting{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting]];
    
    [consolidate setValue:[NSNumber numberWithInt:kVisitationType] forKey:OBJECTTYPE];
    return consolidate;
}

-(void)ServerCommand:(NSDictionary *)dataToBeRecieved withOnComplete:(ServerCommand)response{
    commandPattern = response;
    [self unpackageFileForUser:dataToBeRecieved];
    [self CommonExecution];
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    
    self.databaseObject = [self CreateANewObjectFromClass:DATABASE isTemporary:YES];
    
    [self.databaseObject setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
    
    visitID = [data objectForKey:VISITID];
    
    isLockedBy = [data objectForKey:ISLOCKEDBY];
}

-(void)saveObject:(ObjectResponse)eventResponse
{
    [super saveObject:eventResponse inDatabase:DATABASE forAttribute:VISITID];
}

-(void)CommonExecution
{
    switch (self.commands) {
        case kUpdateObject:
            [self UpdateObjectWithError:@"Server could not update prescription"  orPositiveErro:@"Server successfully updated your information"];
            break;
            
        case kFindObject:
            [self FindObjects];
            break;
        default:
            break;
    }
}

-(void)UpdateObjectWithError:(NSString*)negError orPositiveErro:(NSString*)posError{
    // Load old patient in global object and save new patient in variable
    NSManagedObject* oldVisit = [self loadObjectWithID:[self.databaseObject valueForKey:PRESCRIPTIONID] inDatabase:nil forAttribute:VISITID];
    
    BOOL isNotLockedUp = (!oldVisit || ![[oldVisit valueForKey:ISLOCKEDBY] isEqualToString:isLockedBy]);
    
    
    if (isNotLockedUp) {
        
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            if (!error) {
                [self sendInformation:[self getDictionaryValuesFromManagedObject] toClientWithStatus:kSuccess andMessage:posError];
            }else{
                [self sendInformation:nil toClientWithStatus:kError andMessage:negError];
            }
        }];
    }else{
        [self loadObjectForID:[self.databaseObject valueForKey:ISLOCKEDBY] inDatabase:DATABASE forAttribute:PRESCRIPTIONID];
        
        [self sendInformation:[self getDictionaryValuesFromManagedObject] toClientWithStatus:kError andMessage:[NSString stringWithFormat:@"Prescription is being used by %@",[self.databaseObject valueForKey:ISLOCKEDBY]]];
        
    }
}

-(void)FindObjects{
    NSArray* arr = [self getObjectsWithID:visitID];
    
    NSMutableArray* arrayToSend = [[NSMutableArray alloc]initWithCapacity:arr.count];
    
    for (NSManagedObject* obj in arr) {
        [arrayToSend addObject:[obj dictionaryWithValuesForKeys:obj.attributeKeys]];
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    [dict setValue:[NSNumber numberWithInt:kPrescriptionType] forKey:OBJECTTYPE];
    
    [dict setValue:arrayToSend forKey:ALLITEMS];
    
    [self sendInformation:dict toClientWithStatus:kSuccess andMessage:@"Server search completed"];

}

-(NSArray*)getObjectsWithID:(NSString*)pID{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",PRESCRIPTIONID,pID];
    
    return [NSArray arrayWithArray:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:PRESCRIBETIME]];
}
@end
