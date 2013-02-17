//
//  VisitationObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/11/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "VisitationObject.h"
#define CHECKIN     @"checkInTime"
#define CHECKOUT    @"checkOutTime"
#define PHYSICIAN   @"physicianUsername"
#define DNOTES      @"diagnosisNotes"
#define DTITLE      @"diagnosisTitle"
#define GRAPHIC     @"isGraphic"
#define WEIGHT      @"weight" //The different user types (look at enum)
#define COMPLAINT   @"complaint"
#define VISITID     @"visitationId"
#define DATABASE    @"Visitation"

#import "StatusObject.h"
#import "Visitation.h"
@implementation VisitationObject

- (id)initWithVisit:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        [self unpackageFileForUser:info];
    }
    return self;
}

-(NSDictionary *)consolidateForTransmitting{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithCapacity:4];
    [consolidate setValue:_checkOutTime forKey:CHECKOUT];
    [consolidate setValue:_checkInTime forKey:CHECKIN];
    [consolidate setValue:_diagnosisNotes forKey:DNOTES];
    [consolidate setValue:_diagnosisTitle forKey:DTITLE];
    [consolidate setValue:_physicianUsername forKey:PHYSICIAN];
    [consolidate setValue:[NSNumber numberWithBool:_isGraphic] forKey:GRAPHIC];
    [consolidate setValue:[NSNumber numberWithDouble:_weight] forKey:WEIGHT];
    [consolidate setValue:_complaint forKey:COMPLAINT];
    [consolidate setValue:[NSNumber numberWithInt:kVisitationType] forKey:OBJECTTYPE];
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    self.checkInTime = [data objectForKey:CHECKIN];
    self.checkOutTime = [data objectForKey:CHECKOUT];
    self.complaint = [data objectForKey:COMPLAINT];
    self.diagnosisNotes = [data objectForKey:DNOTES];
    self.diagnosisTitle = [data objectForKey:DTITLE];
    self.weight = [[data objectForKey:WEIGHT]boolValue];
    self.isGraphic = [[data objectForKey:GRAPHIC]doubleValue];
    self.physicianUsername = [data objectForKey:PHYSICIAN];
}

/* The super needs to be called first */
-(void)unpackageDatabaseFileForUser:(NSManagedObject *)object{
    [super unpackageDatabaseFileForUser:object];
    self.checkInTime = [self getValueForKey:CHECKIN];
    self.checkOutTime = [self getValueForKey:CHECKOUT];
    self.complaint = [self getValueForKey:COMPLAINT];
    self.diagnosisNotes = [self getValueForKey:DNOTES];
    self.diagnosisTitle = [self getValueForKey:DTITLE];
    self.weight = [[self getValueForKey:WEIGHT]boolValue];
    self.isGraphic = [[self getValueForKey:GRAPHIC]doubleValue];
    self.physicianUsername = [self getValueForKey:PHYSICIAN];

}

-(void)saveObject:(ObjectResponse)eventResponse
{
    // First check to see if a databaseObject is present
    if (!databaseObject)
            // Otherwise create a new object from scratch
            [self CreateANewObjectFromClass:DATABASE];
    
    [super saveObject:^(id<BaseObjectProtocol> data, NSError* error) {
        [self addObjectToDatabaseObject:_checkOutTime forKey:CHECKOUT];
        [self addObjectToDatabaseObject:_checkInTime forKey:CHECKIN];
        [self addObjectToDatabaseObject:_complaint forKey:COMPLAINT];
        [self addObjectToDatabaseObject:_diagnosisTitle forKey:DTITLE];
        [self addObjectToDatabaseObject:_diagnosisNotes forKey:DNOTES];
        [self addObjectToDatabaseObject:_physicianUsername forKey:PHYSICIAN];
        [self addObjectToDatabaseObject:[NSNumber numberWithBool:_isGraphic] forKey:GRAPHIC];
        [self addObjectToDatabaseObject:[NSNumber numberWithDouble:_weight] forKey:WEIGHT];
    }];
    
    if (eventResponse != nil) {
        eventResponse(self,nil);
    }
    
    
}

-(void)CommonExecution
{
    NSLog(@"Doesn't need to be implemented Client-side");
}

-(void)createANewVisit
{
    // Find and return object if it exists
    StatusObject* status = [[StatusObject alloc]init];
    
    // Need to set client so it can go the correct device
    [status setClient:self.client];
    
    // Check For duplicate Visits
    if ([self isVisitUniqueForVisitID]) {
        // Create new Patient database object
        [self CreateANewObjectFromClass:DATABASE];
        
        // Save internal information to the patient object
        [self saveObject:nil];
        
        //set server status
        [status setStatus:kSuccess];
        
        // Create message
        [status setErrorMessage:@"Visit has been created"];
    }else {
        //Visit aleardy Exists
        [status setStatus:kError];
        [status setErrorMessage:@"Internal Coding Error: Cannot create a new visit from an existing visit"];
    }
    
    // send status back to requested client
    [status CommonExecution];
}

-(BOOL)isVisitUniqueForVisitID
{
    NSArray* pastVisits = [self FindObjectInTable:DATABASE withName:_visitationId forAttribute:VISITID];
    
    if (pastVisits.count > 0) {
        return NO;
    }
    
    return YES;
}
@end
