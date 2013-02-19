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

-(NSDictionary *)consolidateForTransmitting:(NSManagedObject *)object{
   
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting:object]];
    
    [consolidate setValue:[NSNumber numberWithInt:kVisitationType] forKey:OBJECTTYPE];

    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    [_visit setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
}


-(void)saveObject:(ObjectResponse)eventResponse
{
    // First check to see if a databaseObject is present
    if (_visit){
        
        [self SaveCurrentObjectToDatabase];
    }
    
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
    NSArray* pastVisits = [self FindObjectInTable:DATABASE withName:_visit.visitationId forAttribute:VISITID];
    
    if (pastVisits.count > 0) {
        return NO;
    }
    
    return YES;
}
-(BOOL)loadVisitWithVisitationID:(NSString *)visitID{
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:DATABASE withName:visitID forAttribute:VISITID];
    
    if (arr.count == 1) {
        _visit = [arr objectAtIndex:0];
        return  YES;
    }
    return  NO;
}
@end
