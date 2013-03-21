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
        onSuccessHandler(nil,[self createErrorWithDescription:@"Developer Error: Please set visitationID and patientID" andErrorCodeNumber:kErrorObjectMisconfiguration inDomain:@"Visitation Object"]);
        return;
    }
    
    [super UpdateObject:onSuccessHandler shouldLock:NO andSendObjects:[self getDictionaryValuesFromManagedObject] withInstruction:kUpdateObject];
}

-(NSArray *)FindAllObjectsLocallyFromParentObject:(NSDictionary*)parentObject{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@",VISITID,[parentObject objectForKey:VISITID]];
    
   return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:self.COMMONDATABASE withCustomPredicate:pred andSortByAttribute:self.COMMONID]];

}

-(void)FindAllObjectsOnServerFromParentObject:(NSDictionary*)parentObject OnCompletion:(ObjectResponse)eventResponse{
    
    NSMutableDictionary* query = [[NSMutableDictionary alloc]initWithCapacity:4];
    
    [query setValue:[parentObject objectForKey:VISITID] forKey:VISITID];
    
    [self startSearchWithData:query withsearchType:kFindObject andOnComplete:eventResponse];
}

@end
