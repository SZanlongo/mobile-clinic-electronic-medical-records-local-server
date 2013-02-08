//
//  StatusObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define ERRORMSG    @"errormsg"
#import "StatusObject.h"
#import "FIUAppDelegate.h"
@implementation StatusObject

-(NSDictionary *)consolidateForTransmitting{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithCapacity:4];
    [consolidate setValue:_errorMessage forKey:ERRORMSG];
    [consolidate setValue:_data forKey:DATA];
    [consolidate setValue:[NSNumber numberWithInt:_status] forKey:STATUS];
    [consolidate setValue:[NSNumber numberWithInt:kStatusType] forKey:OBJECTTYPE];
    return consolidate;
}
-(void)unpackageFileForUser:(NSDictionary *)data{
    _errorMessage = [data objectForKey:ERRORMSG];
    _data = [data objectForKey:DATA];
    self.objectType = [[data objectForKey:OBJECTTYPE]intValue];
    _status = [[data objectForKey:STATUS]intValue];
    _commands = [[data objectForKey:OBJECTCOMMAND]intValue];
}


-(NSString *)description{
    NSString* text = [NSString stringWithFormat:@"\nError Message: %@ \nStatus: %i\nObjectType: %i",_errorMessage,_status,self.objectType];
    return text;
}

-(void)saveObject:(ObjectResponse)eventResponse{
    NSLog(@"This Method has not been implemented");
}

-(void)CommonExecution{

    switch (self.commands) {
        case kStatusClientWillRecieve:
            [self SendDataToTheWhoeverIsExpecting];
            break;
        default:
            NSLog(@"Server sent a Bad Message");
            break;
    }
}
-(void)SendDataToTheWhoeverIsExpecting{
    NSLog(@"---Sending Notification---");
    [[NSNotificationCenter defaultCenter]postNotificationName:GLOBAL_STATUS_LISTENER object:self userInfo:_data];
}
@end
