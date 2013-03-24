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
ServerCommand onComplete;
static int TIMEOUT;
NSMutableData* majorData;
@implementation ServerCore
@synthesize isServerRunning;
+(id)sharedInstance{
    static ServerCore *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        TIMEOUT = -1;
    });
    
    return sharedMyManager;
}

-(id)init{
    if (self=[super init]) {
        multiThread = dispatch_queue_create("mainScreen", NULL);
        isServerRunning = NO;
    }
    return self;
}

-(void)startServer{
    if (!isServerRunning) {
        asyncSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        // Create an array to hold accepted incoming connections.
        
        connectedSockets = [[NSMutableArray alloc] init];
        
        // Now we tell the socket to accept incoming connections.
        // We don't care what port it listens on, so we pass zero for the port number.
        // This allows the operating system to automatically assign us an available port.
        
        NSError *err = nil;
        if ([asyncSocket acceptOnPort:0 error:&err])
        {
            // So what port did the OS give us?
            
            UInt16 port = [asyncSocket localPort];
            
            // Create and publish the bonjour service.
            // Obviously you will be using your own custom service type.
            
            netService = [[NSNetService alloc] initWithDomain:@"local."
                                                         type:@"_MC-EMR._tcp."
                                                         name:@""
                                                         port:port];
            
            [netService setDelegate:self];
            [netService publish];
            
            // You can optionally add TXT record stuff
            
            NSMutableDictionary *txtDict = [NSMutableDictionary dictionaryWithCapacity:2];
            
            [txtDict setObject:@"moo" forKey:@"cow"];
            [txtDict setObject:@"quack" forKey:@"duck"];
            
            NSData *txtData = [NSNetService dataFromTXTRecordDictionary:txtDict];
            [netService setTXTRecordData:txtData];
        }
        else
        {
            NSLog(@"Error in acceptOnPort:error: -> %@", err);
        }
        
        // [asyncSocket readDataWithTimeout:-1 tag:30];
    }
}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"Connected with Client");
}
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
	NSLog(@"Accepted new socket from %@:%hu", [newSocket connectedHost], [newSocket connectedPort]);
	
	// The newSocket automatically inherits its delegate & delegateQueue from its parent.
    
    [newSocket readDataWithTimeout:-1 tag:0];
	[connectedSockets addObject:newSocket];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	[connectedSockets removeObject:sock];
}

- (void)netServiceDidPublish:(NSNetService *)ns
{
    isServerRunning = YES;
	NSLog(@"Bonjour Service Published: domain(%@) type(%@) name(%@) port(%i)",
          [ns domain], [ns type], [ns name], (int)[ns port]);
}

- (void)netService:(NSNetService *)ns didNotPublish:(NSDictionary *)errorDict
{
	// Override me to do something here...
	//
	// Note: This method in invoked on our bonjour thread.
	
	NSLog(@"Failed to Publish Service: domain(%@) type(%@) name(%@) - %@",
          [ns domain], [ns type], [ns name], errorDict);
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSLog(@"Server did accept data %li",data.length);
    
    if (!majorData) {
        majorData = [[NSMutableData alloc]initWithData:data];
    }else{
        [majorData appendData:data];
    }
    
    @try {
        
        NSDictionary* myDictionary = [[NSDictionary alloc]initWithDictionary:[self unarchiveToDictionaryFromData:majorData] copyItems:YES];
        
        NSLog(@"Server Recieved: %@",myDictionary.description);
        
        if(myDictionary) {
            // ObjectFactory: Used to instatiate the proper class but returns it generically
            id<BaseObjectProtocol> factoryObject = [ObjectFactory createObjectForType:myDictionary];
            
            [factoryObject ServerCommand:myDictionary withOnComplete:^(NSDictionary *dataToBeSent) {
                
                //New mutable data object
                NSMutableData *data = [[NSMutableData alloc] init];
                
                //Created an archiver to serialize dictionary into data object
                NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
                
                //encodes the dataToBeSent into data object
                [archiver encodeObject:dataToBeSent forKey:ARCHIVER];
                //finalize archiving
                [archiver finishEncoding];
                
                //send data
                NSLog(@"Server Will Send:%@ \n%li Bytes",dataToBeSent.description,data.length);
                [sock writeData:data withTimeout:TIMEOUT tag:10];
                majorData = nil;
            }];
        
        }
        else
        {
            majorData = nil;
            NSLog(@"Write Error in Log: Recieved No data");
        }
    }
    @catch (NSException *exception) {
        [sock readDataWithTimeout:TIMEOUT tag:tag];
    }
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"Server is now Listening for Data");
    [sock readDataWithTimeout:TIMEOUT tag:tag];
}

-(NSDictionary*)unarchiveToDictionaryFromData:(NSData*)data
{
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        NSDictionary* myDictionary = [unarchiver decodeObjectForKey:ARCHIVER];
        
        [unarchiver finishDecoding];
        
        return myDictionary;
}
-(NSString*)getHostNameForSocketAtIndex:(NSInteger)index{
   GCDAsyncSocket* sock = [connectedSockets objectAtIndex:index];
    return [sock connectedHost];
}
-(NSString*)getPortForSocketAtIndex:(NSInteger)index{
    GCDAsyncSocket* sock = [connectedSockets objectAtIndex:index];
    return [NSString stringWithFormat:@"%hu",sock.connectedPort];
}
-(void)stopServer{
    if (isServerRunning) {
        [asyncSocket disconnect];
        [netService stop];
    }
}
-(void)netServiceDidStop:(NSNetService *)sender{
    NSLog(@"Server Has Been Turned Off");
    isServerRunning = NO;
}
-(NSInteger)numberOfConnections{
    return connectedSockets.count;
}

@end
