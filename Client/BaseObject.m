//
//  BaseObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "BaseObject.h"
#define MAX_NUMBER_ITEMS 4
#import "StatusObject.h"

@implementation BaseObject
@synthesize databaseObject;
-(id)init{
    if (self = [super init]) {
       
    }
    return self;
}

-(NSDictionary *)consolidateForTransmitting:(NSManagedObject *)object{
    /* Setup some of variables that are common to all the 
     * the object that inherit from this base class
     */
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithCapacity:MAX_NUMBER_ITEMS];

    [consolidate setValue:[object dictionaryWithValuesForKeys:object.entity.attributesByName.allKeys] forKey:DATABASEOBJECT];
    
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    /* Setup some of variables that are common to all the
     * the object that inherit from this base class
     */
    self.commands = [[data objectForKey:OBJECTCOMMAND]intValue];
}

-(NSString *)description{
   
    return @"";
}

-(void)saveObject:(ObjectResponse)eventResponse{
    //Do not save the objectID, That is automatically saved and generated
    eventResponse(nil, nil);
    [self SaveCurrentObjectToDatabase];
}

-(void)CommonExecution{
    NSLog(@"CommonExecution Not implemented.");
}

-(void)tryAndSendData:(NSDictionary*)data withErrorToFire:(ObjectResponse)negativeResponse andWithPositiveResponse:(ServerCallback)posResponse{
    
    if ([self.appDelegate.ServerManager isClientConntectToServer]) {
        // Sending information to the server
        [self.appDelegate.ServerManager sendData:data withOnComplete:posResponse];
    }else{
        negativeResponse(nil,[self createErrorWithDescription:@"Server is Down, Please contact you Application Administrator" andErrorCodeNumber:10 inDomain:@"BaseObject"]);
    }
}

-(void)setDBObject:(NSManagedObject *)DatabaseObject{
    databaseObject = DatabaseObject;
}

-(void)setObject:(id)object withAttribute:(NSString *)attribute{
    [super setObject:object withAttribute:attribute inDatabaseObject:databaseObject];
}

-(id)getObjectForAttribute:(NSString *)attribute{
   return [super getObjectForAttribute:attribute inDatabaseObject:databaseObject];
}
@end
