//
//  PrescriptionObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/25/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#define VISITID         @"visitationId"
#define DATABASE    @"Prescription"

#import "PrescriptionObject.h"
#import "StatusObject.h"

@implementation PrescriptionObject


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

#pragma mark- Public Methods
#pragma mark-
-(void)associateObjectToItsSuperParent:(NSDictionary *)parent{
    NSString* vId = [parent objectForKey:VISITID];
    [self.databaseObject setValue:[NSString stringWithFormat:@"%@_%f",vId,[[NSDate date]timeIntervalSince1970]] forKey:PRESCRIPTIONID];
    [self.databaseObject setValue:vId forKey:VISITID];
}

-(void)createNewObject:(NSDictionary*) object onCompletion:(ObjectResponse)onSuccessHandler
{
    
    if (object) {
        [self setValueToDictionaryValues:object];
    }
    
    // Check for main ID's
    if (![self.databaseObject valueForKey:VISITID] || ![self.databaseObject valueForKey:PRESCRIPTIONID]) {
        onSuccessHandler(nil,[self createErrorWithDescription:@"Developer Error: Please set visitationID  and patientID" andErrorCodeNumber:kUpdateObject inDomain:@"Visitation Object"]);
        return;
    }
    
    [super UpdateObject:onSuccessHandler shouldLock:NO andSendObjects:[self getDictionaryValuesFromManagedObject] withInstruction:kUpdateObject];
}

-(NSArray *)FindAllObjectsLocallyFromParentObject:(NSDictionary*)parentObject{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",VISITID,[parentObject objectForKey:VISITID]];
    
    return [self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:VISITID];
}

-(void)FindAllObjectsOnServerFromParentObject:(NSDictionary*)parentObject OnCompletion:(ObjectResponse)eventResponse{
    
    NSMutableDictionary* query = [[NSMutableDictionary alloc]initWithCapacity:4];
    
    [query setValue:[parentObject objectForKey:VISITID] forKey:VISITID];
    [query setValue:[NSNumber numberWithInt:kPrescriptionType] forKey:OBJECTTYPE];
    [query setValue:[NSNumber numberWithInt:kFindObject] forKey:OBJECTCOMMAND];
    
    [ self tryAndSendData:query withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {
        eventResponse(nil,error);
    } andWithPositiveResponse:^(id data) {
        StatusObject* status = data;
        [self SaveListOfObjectsFromDictionary:status.data];
        eventResponse(self,nil);
    }];
}

@end
