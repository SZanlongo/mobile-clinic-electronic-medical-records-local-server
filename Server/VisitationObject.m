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

- (id)init
{
    self = [super init];
    if (self) {
        [self linkDatabaseObject];
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
    
    [self linkDatabaseObject];
    
    [visit setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
    
    patientID = [data objectForKey:PATIENTID];
    
    isLockedBy = [data objectForKey:ISLOCKEDBY];
}

-(void)saveObject:(ObjectResponse)eventResponse
{
    [self linkDatabaseObject];
    
        [super saveObject:eventResponse inDatabase:DATABASE forAttribute:VISITID];
}

-(void)CommonExecution
{
    switch (self.commands) {
        case kUpdateObject:
            [self UpdateVisitationWithError:@"Server could not update patient"  orPositiveErro:@"Server successfully updated your information"];
            break;
            
        case kFindObject:
            [self FindVisitByPatients];
            break;
            
        case kFindOpenObjects:
            [self FindAllOpenVisits];
            break;  
        default:
            break;
    }
}

-(void)UpdateVisitationWithError:(NSString*)negError orPositiveErro:(NSString*)posError{
    // Load old patient in global object and save new patient in variable
    Visitation* oldVisit = (Visitation*)[self loadObjectWithID:visit.visitationId inDatabase:nil forAttribute:VISITID];
    
    BOOL isNotLockedUp = (!oldVisit || [oldVisit.isLockedBy isEqualToString:isLockedBy] || oldVisit.isLockedBy.length == 0);
    
    
    if (isNotLockedUp) {
        
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            if (!error) {
                [self sendInformation:[self getDictionaryValuesFromManagedObject] toClientWithStatus:kSuccess andMessage:posError];
            }else{
                [self sendInformation:nil toClientWithStatus:kError andMessage:negError];
            }
        }];
    }else{
        [self loadObjectForID:visit.visitationId inDatabase:DATABASE forAttribute:VISITID];
        
        [self sendInformation:[self getDictionaryValuesFromManagedObject] toClientWithStatus:kError andMessage:[NSString stringWithFormat:@"Patient is being used by %@",[self.databaseObject valueForKey:ISLOCKEDBY]]];

    }
}
-(NSArray*)getVisitsForPatientWithID:(NSString*)pID{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",PATIENTID,pID];
    
    return [NSArray arrayWithArray:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:TRIAGEIN]];
}
#pragma mark - Private Methods
#pragma mark-
-(BOOL)isObject:(id)obj UniqueForKey:(NSString*)key{
    return [super isObject:obj UniqueForKey:key inDatabase:DATABASE];
}

-(void) FindAllOpenVisits{
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",ISOPEN,visit.isOpen];
    
  NSArray* arr = [NSArray arrayWithArray:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:TRIAGEIN]];
    
    NSMutableArray* arrayToSend = [[NSMutableArray alloc]initWithCapacity:arr.count];
    
    for (Visitation* obj in arr) {
        [arrayToSend addObject:[obj dictionaryWithValuesForKeys:obj.attributeKeys]];
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    [dict setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];
    
    [dict setValue:arrayToSend forKey:ALLITEMS];
    
    [self sendInformation:dict toClientWithStatus:kSuccess andMessage:@"Server search completed"];
}

-(void)FindVisitByPatients{
    NSArray* arr = [self getVisitsForPatientWithID:patientID];
    
    NSMutableArray* arrayToSend = [[NSMutableArray alloc]initWithCapacity:arr.count];
    
    for (Visitation* obj in arr) {
        [arrayToSend addObject:[obj dictionaryWithValuesForKeys:obj.attributeKeys]];
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    [dict setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];
    
    [dict setValue:arrayToSend forKey:ALLITEMS];
    
    [self sendInformation:dict toClientWithStatus:kSuccess andMessage:@"Server search completed"];

}

-(NSManagedObject *)loadObjectWithID:(NSString *)objectID inDatabase:(NSString *)database forAttribute:(NSString *)attribute{
   return [super loadObjectWithID:objectID inDatabase:DATABASE forAttribute:attribute];
}

-(void)linkDatabaseObject{
    visit = (Visitation*)self.databaseObject;
}
@end
