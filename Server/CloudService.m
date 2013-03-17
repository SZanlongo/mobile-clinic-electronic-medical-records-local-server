//
//  CloudService.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/15/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "CloudService.h"

@interface CloudService()
{
    NSString *kURL;
}
@end

@implementation CloudService

#pragma mark - Cloud API
#pragma mark-
-(id)init{
    self = [super init];
    if(self)
    {
        kURL = @"http://znja-webapp.herokuapp.com/api/";
        //        kURL = @"http://0.0.0.0:3000/api/";
    }
    return self;
}

-(void)query:(NSString *)stringQuery parameters: (NSDictionary *)params completion:(void(^)(NSError *error, NSDictionary *result)) completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self queryWithPartialURL:stringQuery parameters:params completion:completion];
        
    });
}

-(void)query:(NSString *)stringQuery parameters: (NSDictionary *)params imageData:(NSData *)imageData completion:(void(^)(NSError *error, NSDictionary *result)) completion
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
        
        [self queryWithPartialURL:stringQuery parameters:params imageData:imageData completion:completion];
        
    });
    
}

-(void)queryWithPartialURL:(NSString *)partialURL parameters: (NSDictionary *)params imageData:(NSData *)imageData completion:(void(^)(NSError *error, NSDictionary *result)) completion
{
    //    [[NSApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    
    NSURL *url = [NSURL  URLWithString:[NSString stringWithFormat:@"%@%@", kURL, partialURL]];
    
    
    //////////////////////////////////////////////////////
    NSData *json = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"%@", [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding]);
    
    //    NSDictionary *_params = [NSDictionary dictionaryWithObjectsAndKeys:
    //                             kAPI_Key , @"X-ApiKey", deviceID ,
    //                             @"X-DeviceID", accessToken ,
    //                             @"X-AccessToken",[[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding],
    //                             @"&X-UserToken=", userToken,
    //                             @"params", nil];
    
    
    NSString *POSTBoundary = @"0xKhTmLbOuNdArY";
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    //    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", POSTBoundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    //    for (NSString *param in _params) {
    //        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", POSTBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
    //        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    //    }
    
    // add image data
    //    NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", POSTBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"file"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", POSTBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%li", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:url];
    
    [self sendAsyncRequest:request completion:completion];
}

-(void)queryWithPartialURL:(NSString *)partialURL parameters: (NSDictionary *)param completion:(void(^)(NSError *error, NSDictionary *result)) completion
{
    //    [[NSApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    
    NSURL *url = [NSURL  URLWithString:[NSString stringWithFormat:@"%@%@", kURL, partialURL]];
    
    NSData *data;
    
    if (param) {
        NSData *json = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        
        data = [[NSString stringWithFormat:@"%@%@",
                 @"&params=",[[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding] ]
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
        
        if(!error){
            NSError *jsonError;
            
            //read and print the server response for debug
            NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", myString);
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            
            if (completion) {
                completion(jsonError, json);
            }
        }
        else
        {
            completion(error, nil);
        }
        
    }];
    
    //    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
    
}

#pragma mark- Cloud API Utilities
#pragma mark-
-(NSString *)convertDictionaryToString:(NSDictionary *) jsonParams
{
    NSData *jsonParamsData = [NSJSONSerialization dataWithJSONObject:jsonParams options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonParamsData encoding:NSUTF8StringEncoding];
}

@end