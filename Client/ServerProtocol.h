//
//  ServerProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/3/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ClientServerConnect) (BOOL isConnected);
typedef void (^ServerCallback)(id data);

@protocol ServerProtocol <NSObject>

@required
+ (id)sharedInstance;
- (void) startClient;
- (void) stopClient;
- (void)sendData:(NSDictionary*)dataToBeSent withOnComplete:(ServerCallback)response;
- (BOOL) isClientConntectToServer;
- (void)setConnectionStatusHandler:(ClientServerConnect)statusHandler;
@end
