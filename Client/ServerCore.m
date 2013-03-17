//
//  ServerCore.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/30/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define ARCHIVER    @"archiver"


#import "ServerCore.h"
#import "ObjectFactory.h"

ServerCallback onComplete;

@interface ServerCore (Private)
- (void)connectToNextAddress;
@end

NSMutableData* majorData;
static ServerCore *sharedMyManager = nil;
@implementation ServerCore

+(id)sharedInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

-(id)init{
    if (self=[super init]) {
        
        netServiceBrowser = [[NSNetServiceBrowser alloc] init];
        [netServiceBrowser setDelegate:self];
    }
    return self;
}
-(void)startClient{
    NSLog(@"Started ServerCore: Searching for Servers...");
    [netServiceBrowser searchForServicesOfType:@"_MC-EMR._tcp." inDomain:@"local."];
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)sender didNotSearch:(NSDictionary *)errorInfo
{
	NSLog(@"DidNotSearch: %@", errorInfo);
}
-(void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing{
    
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender
           didFindService:(NSNetService *)netService
               moreComing:(BOOL)moreServicesComing
{
	NSLog(@"DidFindService: %@", [netService name]);
	
	// Connect to the first service we find
	
	if (serverService == nil)
	{
		NSLog(@"Resolving...");
		
		serverService = netService;
		
		[serverService setDelegate:self];
		[serverService resolveWithTimeout:5.0];
	}
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender
         didRemoveService:(NSNetService *)netService
               moreComing:(BOOL)moreServicesComing
{
	NSLog(@"Removing Service: %@", [netService name]);
    
    if ([serverService.name isEqualToString:netService.name]) {
        NSLog(@"Removed Current Service that was in use");
        connected = NO;
        if (connectionStatus) {
            connectionStatus(connected);
        }
        [self stopClient];
        [self startClient];
    }
    
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)sender
{
	NSLog(@"DidStopSearch");
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
	NSLog(@"DidNotResolve");
    connected = NO;
    [self startClient];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	NSLog(@"DidResolve: %@", [sender addresses]);
	
	if (serverAddresses == nil)
	{
		serverAddresses = [[sender addresses] mutableCopy];
	}
	
	if (asyncSocket == nil)
	{
		asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
		[self connectToNextAddress];
	}
}

- (void)connectToNextAddress
{
	BOOL done = NO;
	
	while (!done && ([serverAddresses count] > 0))
	{
		NSData *addr;
		
		// Note: The serverAddresses array probably contains both IPv4 and IPv6 addresses.
		//
		// If your server is also using GCDAsyncSocket then you don't have to worry about it,
		// as the socket automatically handles both protocols for you transparently.
		
		if (YES) // Iterate forwards
		{
			addr = [serverAddresses objectAtIndex:0];
			[serverAddresses removeObjectAtIndex:0];
		}
		else // Iterate backwards
		{
			addr = [serverAddresses lastObject];
			[serverAddresses removeLastObject];
		}
		
		NSLog(@"Attempting connection to %@", addr);
		
		NSError *err = nil;
		if ([asyncSocket connectToAddress:addr error:&err])
		{
			done = YES;
		}
		else
		{
			NSLog(@"Unable to connect: %@", err);
		}
		
	}
	
	if (!done)
	{
		NSLog(@"Unable to connect to any resolved address");
	}
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"Socket:DidConnectToHost: %@ Port: %hu", host, port);
	[self grabURLInBackground:host];
	connected = YES;
    
    if (connectionStatus) {
        connectionStatus(connected);
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"SocketDidDisconnect:WithError: %@", err);
    
    [self connectToNextAddress];
    if (connectionStatus) {
        connectionStatus(NO);
    }
    
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSLog(@"Server did accept data %i",data.length);
    
    if (!majorData) {
        majorData = [[NSMutableData alloc]initWithData:data];
    }else{
        [majorData appendData:data];
    }
    @try {
        NSDictionary* myDictionary = [[NSDictionary alloc]initWithDictionary:[self unarchiveToDictionaryFromData:majorData] copyItems:YES];
        NSLog(@"Client will Recieve: %@",myDictionary.description);
        if(majorData) {
            // ObjectFactory: Used to instatiate the proper class but returns it generically
            id<BaseObjectProtocol> obj = [ObjectFactory createObjectForType:myDictionary];
            
            // setup the object to use the dictionary values
            [obj unpackageFileForUser:myDictionary];
            
            majorData = nil;
            onComplete(obj);
        } else {
            NSLog(@"Write Error in Log: Recieved No data");
        }
        
    }
    @catch (NSException *exception) {
        [asyncSocket readDataWithTimeout:-1 tag:tag];
    }
}
-(void)socketDidCloseReadStream:(GCDAsyncSocket *)sock{
    NSLog(@"Read Stream CLosed");
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"Completed Writing");
    [asyncSocket readDataWithTimeout:-1 tag:tag];
}

-(NSDictionary*)unarchiveToDictionaryFromData:(NSData*)data{
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    
    NSDictionary* myDictionary = [unarchiver decodeObjectForKey:ARCHIVER];
    
    [unarchiver finishDecoding];
    
    return myDictionary;
}

- (void)sendData:(NSDictionary*)dataToBeSent withOnComplete:(ServerCallback)response
{
    onComplete = response;
    
    //New mutable data object
    globalData = [[NSMutableData alloc] init];
    
    //Created an archiver to serialize dictionary into data object
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:globalData];
    //encodes the dataToBeSent into data object
    [archiver encodeObject:dataToBeSent forKey:ARCHIVER];
    //finalize archiving
    [archiver finishEncoding];
    NSLog(@"Client will Send: %@ Size: %i Bytes",dataToBeSent.description, globalData.length);
	[asyncSocket writeData:globalData withTimeout:-1 tag:10];
	
}
-(void)stopClient{
    [netServiceBrowser stop];
    [asyncSocket disconnect];
    asyncSocket = nil;
    serverService = nil;
    serverAddresses = nil;
}
-(NSInteger)numberOfConnections{
    return serverAddresses.count;
}
-(BOOL)isClientConntectToServer{
    return connected;
}
-(NSString *)getCurrentConnectionName{
    return asyncSocket.connectedHost;
}
- (void)setConnectionStatusHandler:(ClientServerConnect)statusHandler{
    connectionStatus = statusHandler;
}
@end
