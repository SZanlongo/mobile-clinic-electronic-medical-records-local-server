//
//  ServerProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/3/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServerProtocol <NSObject>
@required
- (void) startClient;
- (void) stopClient;
- (void) sendData:(NSDictionary*)dataToBeSent;
- (BOOL) isClientConntectToServer;
@end
