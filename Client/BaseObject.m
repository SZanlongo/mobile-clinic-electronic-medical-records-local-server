//
//  BaseObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "BaseObject.h"
#define MAX_NUMBER_ITEMS 10
#import "StatusObject.h"

@implementation BaseObject


-(NSDictionary *)consolidateForTransmitting{
    /* Setup some of variables that are common to all the 
     * the object that inherit from this base class
     */
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithCapacity:MAX_NUMBER_ITEMS];
    [consolidate setValue:self.objID forKey:OBJECTID];
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    /* Setup some of variables that are common to all the
     * the object that inherit from this base class
     */
    self.objID = [data objectForKey:OBJECTID];
    self.objectType = [[data objectForKey:OBJECTTYPE]intValue];
    self.commands = [[data objectForKey:OBJECTCOMMAND]intValue];
}

-(NSString *)description{
    NSString* text = [NSString stringWithFormat:@"\nObject ID: %@",self.objID.description];
    return text;
}

-(void)saveObject:(ObjectResponse)eventResponse{
    //Do not save the objectID, That is automatically saved and generated
    eventResponse(nil, nil);
    [self SaveCurrentObjectToDatabase];
}
-(void)unpackageDatabaseFileForUser:(NSManagedObject *)object{
    databaseObject = object;
    self.objID = databaseObject.objectID;
}
-(void)CommonExecution{
    NSLog(@"CommonExecution Not implemented.");
}

-(void)ActionSuccessfull
{
    // Remove event listener
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    StatusObject* obj = tempObject;
    if (obj.status == kSuccess) {
        // Reset this object with the information brought back through the server
        [self unpackageFileForUser:obj.data];
        // Activate the callback so user knows it was successful
        respondToEvent(self, nil);
    }else{
        respondToEvent(nil,[self createErrorWithDescription:obj.errorMessage andErrorCodeNumber:10 inDomain:@"BaseObject"] );
    }
    
}
@end
