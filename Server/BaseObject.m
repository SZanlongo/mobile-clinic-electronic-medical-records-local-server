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

@interface BaseObject()
{
    NSString *kURL;
}
@end

@implementation BaseObject

-(id)init{
    self = [super init];
    if(self)
    {
         kURL = @"http://znja-webapp.herokuapp.com/api/";
    }
    return self;
}

-(NSDictionary *)consolidateForTransmitting:(NSManagedObject *)object{
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithCapacity:MAX_NUMBER_ITEMS];
    
    [consolidate setValue:[object dictionaryWithValuesForKeys:object.entity.attributeKeys] forKey:DATABASEOBJECT];
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    self.commands = [[data objectForKey:OBJECTCOMMAND]intValue];
}

-(NSString *)description{
    NSString* text = [NSString stringWithFormat:@"\nObjectType: %i",self.objectType];
    return text;
}

-(void)saveObject:(ObjectResponse)eventResponse{
    //Do not save the objectID, That is automatically saved and generated
    eventResponse(self, nil);
}

-(void)CommonExecution{
    
}

-(void)query:(NSString *)stringQuery parameters: (NSDictionary *)params completion:(void(^)(NSError *error, NSDictionary *result)) completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self queryWithPartialURL:stringQuery parameters:params completion:completion];
        
    });
}

-(void)queryWithPartialURL:(NSString *)partialURL parameters: (NSDictionary *)param completion:(void(^)(NSError *error, NSDictionary *result)) completion
{
//    [[NSApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    
    NSURL *url = [NSURL  URLWithString:[NSString stringWithFormat:@"%@%@", kURL, partialURL]];
    NSData *data;
    
    if (param) {
        NSData *json = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        
        data = [[[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding]
                dataUsingEncoding: NSUTF8StringEncoding];
    }
    else
    {
        data = [[NSString stringWithFormat:@"%@",@""] dataUsingEncoding: NSUTF8StringEncoding];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: data];
    
    
    [self sendAsyncRequest:request completion:completion];
}

-(void)sendAsyncRequest:(NSURLRequest *)request completion:(void(^)(NSError *error, NSDictionary *result)) completion
{
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        completion(error, nil);
    }];
    
//    [[NSApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
    
}

#pragma Mark Utilities
-(NSString *)convertDictionaryToString:(NSDictionary *) jsonParams
{
    NSData *jsonParamsData = [NSJSONSerialization dataWithJSONObject:jsonParams options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonParamsData encoding:NSUTF8StringEncoding];
}

@end
