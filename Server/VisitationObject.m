//
//  VisitationObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "VisitationObject.h"
#define TRIAGEIN    @"triageIn"
#define TRIAGEOUT   @"triageOut"
#define DOCTORID    @"doctorId"
#define PATIENTID   @"patientId"
#define DOCTORIN    @"doctorIn"
#define DOCTOROUT   @"doctorOut"
#define CONDITION   @"condition"
#define DTITLE      @"diagnosisTitle"
#define GRAPHIC     @"isGraphic"
#define WEIGHT          @"weight" //The different user types (look at enum)
#define OBSERVATION     @"observation"
#define NURSEID         @"nurseId"
#define BLOODPRESSURE   @"bloodPressure"
#define VISITID         @"visitationId"

#define DATABASE    @"Visitation"
#define ISOPEN      @"isOpen"
#define ALLVISITS   @"all visits"

#import "UserObject.h"
#import "StatusObject.h"
#import "Visitation.h"

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
        [self linkDatabaseObject];
        [self unpackageFileForUser:info];
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
    
    switch (self.commands) {
        case kCreateNewObject:
            self.databaseObject = [self CreateANewObjectFromClass:DATABASE isTemporary:NO];
            break;
        case kToggleObjectLock:
        case kUpdateObject:
            [self loadObjectForID:[[data objectForKey:DATABASEOBJECT]objectForKey:VISITID] inDatabase:DATABASE forAttribute:VISITID];
            break;
        case kFindObject:
            
            break;
        default:
            break;
    }
    [self linkDatabaseObject];
    [visit setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
    patientID = [data objectForKey:PATIENTID];
    isLockedBy = [data objectForKey:ISLOCKEDBY];
}

-(void)associateCurrentUserToVisit{
    
}

-(void)saveObject:(ObjectResponse)eventResponse
{
    // First check to see if a databaseObject is present
    if (visit){
        
        [self SaveCurrentObjectToDatabase:visit];
        
        if (eventResponse)
            eventResponse(self, nil);
    }else{
        //        if (eventResponse)
        //            eventResponse(self, nil);
    }
}

/* Depending on the RemoteCommands it will execute a different Command */
-(void)CommonExecution
{
    switch (self.commands) {
        case kCreateNewObject:
            [self createNewVisit];
            break;
            
        case kUpdateObject:
            [self ClientSidePatientLockToggleWithError:@"Server could not update patient"  orPositiveErro:@"Server successfully updated your information"];
            break;
            
        case kFindObject:
            [self FindVisitByPatients];
            break;
            
        case kFindOpenObjects:
            [self FindAllOpenVisits];
            break;
            
        case kToggleObjectLock:
            [self ClientSidePatientLockToggleWithError:@"Server failed to release/lock the patient" orPositiveErro:@"Server locked the patient"];
            
        default:
            break;
    }
}



#pragma mark - Private Methods
#pragma mark-


-(void)createNewVisit{
    
    if ([self isVisitUniqueForVisitID]) {
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            if (!error) {
                [self sendInformation:[data getDictionaryValuesFromManagedObject] toClientWithStatus:kSuccess andMessage:@"Server successfully saved your information"];
            }else{
                [self sendInformation:[data getDictionaryValuesFromManagedObject] toClientWithStatus:kError andMessage:@"Server could not save your information"];
            }
        }];
    }else{
        [self sendInformation:[self getDictionaryValuesFromManagedObject] toClientWithStatus:kError andMessage:@"A Visit with this ID already Exists"];
        [appDelegate.managedObjectContext deleteObject:self.databaseObject];
    }
}

-(void)FindVisitByPatients{
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",ISOPEN,visit.isOpen];
    
  NSArray* arr = [NSArray arrayWithArray:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:TRIAGEIN]];
    
    NSMutableArray* arrayToSend = [[NSMutableArray alloc]initWithCapacity:arr.count];
    
    for (Visitation* obj in arr) {
        [arrayToSend addObject:[obj dictionaryWithValuesForKeys:obj.attributeKeys]];
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    [dict setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];
    
    [dict setValue:arrayToSend forKey:ALLVISITS];
    
    [self sendInformation:dict toClientWithStatus:kSuccess andMessage:@"Server search completed"];
}
-(void)FindAllOpenVisits{
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",PATIENTID,patientID];
    
    NSArray* arr = [NSArray arrayWithArray:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:TRIAGEIN]];
    
    NSMutableArray* arrayToSend = [[NSMutableArray alloc]initWithCapacity:arr.count];
    
    for (Visitation* obj in arr) {
        [arrayToSend addObject:[obj dictionaryWithValuesForKeys:obj.attributeKeys]];
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    [dict setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];
    
    [dict setValue:arrayToSend forKey:ALLVISITS];
    
    [self sendInformation:dict toClientWithStatus:kSuccess andMessage:@"Server search completed"];

}
-(void)ClientSidePatientLockToggleWithError:(NSString*)negError orPositiveErro:(NSString*)posError{
    // Load old patient in global object and save new patient in variable
    Visitation* oldVisit = (Visitation*)[self loadObjectWithID:visit.visitationId inDatabase:nil forAttribute:VISITID];
    
    if ([oldVisit.isLockedBy isEqualToString:isLockedBy] || oldVisit.isLockedBy.length == 0) {
        // Update the old patient
        [oldVisit setValuesForKeysWithDictionary:[visit dictionaryWithValuesForKeys:visit.attributeKeys]];
        // save to local database
        [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            if (!error) {
                [self sendInformation:nil toClientWithStatus:kSuccess andMessage:posError];
            }else{
                [self sendInformation:nil toClientWithStatus:kError andMessage:negError];
            }
        }];
    }else{
        // Patient was already locked
        [self sendInformation:nil toClientWithStatus:kError andMessage:[NSString stringWithFormat:@"Patient is being used by %@",isLockedBy]];
    }
}

-(BOOL)isVisitUniqueForVisitID
{
   NSArray* pastVisits = [self FindObjectInTable:DATABASE withName:visit.visitationId forAttribute:VISITID];
    
    if (pastVisits.count > 1) {
        return NO;
    }
    
    return YES;
}
-(NSManagedObject *)loadObjectWithID:(NSString *)objectID inDatabase:(NSString *)database forAttribute:(NSString *)attribute{
   return [super loadObjectWithID:objectID inDatabase:DATABASE forAttribute:attribute];
}
-(void)linkDatabaseObject{
    visit = (Visitation*)self.databaseObject;
}
@end
