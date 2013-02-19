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


@end
