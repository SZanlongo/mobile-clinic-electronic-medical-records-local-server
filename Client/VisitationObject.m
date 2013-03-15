//
//  VisitationObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "VisitationObject.h"
#define ISOPEN      @"isOpen"
#define DATABASE    @"Visitation"
#define ALLVISITS   @"all visits"

#import "StatusObject.h"
#import "Visitation.h"
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
#pragma mark- Private Methods
#pragma mark-


-(void)createNewObject:(NSDictionary*) object Locally:(ObjectResponse)onSuccessHandler
{
    
    if (object) {
        [self setValueToDictionaryValues:object];
    }
    
    
    // Check for patientID
    if (![self.databaseObject valueForKey:VISITID] || ![self.databaseObject valueForKey:PATIENTID]) {
        onSuccessHandler(nil,[self createErrorWithDescription:@"Developer Error: Please set visitationID  and patientID" andErrorCodeNumber:kUpdateObject inDomain:@"Visitation Object"]);
        return;
    }
    
    [super UpdateObject:onSuccessHandler shouldLock:NO andSendObjects:[self getDictionaryValuesFromManagedObject] withInstruction:kUpdateObject];
}

-(NSArray *)FindAllObjectsLocallyFromParentObject:(NSDictionary*)parentObject{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",PATIENTID,[parentObject objectForKey:PATIENTID]];
    
    return [self convertListOfManagedObjectsToListOfDictionaries: [self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:PATIENTID]];
}

-(void)FindAllObjectsOnServerFromParentObject:(NSDictionary*)parentObject OnCompletion:(ObjectResponse)eventResponse{
    
    NSMutableDictionary* query = [[NSMutableDictionary alloc]initWithCapacity:4];
    
    [query setValue:[parentObject objectForKey:PATIENTID] forKey:PATIENTID];
    [query setValue:[NSNumber numberWithInt:kVisitationType] forKey:OBJECTTYPE];
    [query setValue:[NSNumber numberWithInt:kFindObject] forKey:OBJECTCOMMAND];
    
    [ self tryAndSendData:query withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {
        eventResponse(nil,error);
    } andWithPositiveResponse:^(id data) {
        StatusObject* status = data;
        [self SaveListOfObjectsFromDictionary:status.data];
        eventResponse(self,nil);
    }];
}




-(void)linkVisit{
    visit = (Visitation*)self.databaseObject;
}

#pragma mark- Public Methods
#pragma mark-

-(void)associateObjectToItsSuperParent:(NSDictionary *)parent
{
    [self linkVisit];
    NSString* pId = [parent objectForKey:PATIENTID];
    [visit setVisitationId:[NSString stringWithFormat:@"%@_%f",pId,[[NSDate date]timeIntervalSince1970]]];
    [visit setPatientId:pId];
}

-(BOOL)shouldSetCurrentVisitToOpen:(BOOL)shouldOpen{
   
    BOOL isAlreadyOpen = ([[self.databaseObject valueForKey:ISOPEN]boolValue]);
    
    if (isAlreadyOpen) {
        return NO;
    }
    
    [self.databaseObject setValue:[NSNumber numberWithBool:shouldOpen] forKey:ISOPEN];
    
    return YES;
}

-(void) SyncAllOpenVisitsOnServer:(ObjectResponse)Response{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:kFindOpenObjects],OBJECTCOMMAND,[NSNumber numberWithInteger:kVisitationType],OBJECTTYPE, nil];
    
    [self tryAndSendData:dict withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {
        Response(data,error);
    } andWithPositiveResponse:^(id data) {
        StatusObject* status = data;
        [self SaveListOfObjectsFromDictionary:status.data];
        Response(self,nil);
    }];
}

-(NSArray*)FindAllOpenVisitsLocally{
   //Predicate to return list of Open Objects
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"isOpen == TRUE"];
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:TRIAGEIN]];
}



@end
