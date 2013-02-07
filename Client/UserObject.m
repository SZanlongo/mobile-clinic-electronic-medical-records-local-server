//
//  UserObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#define STATUS      @"status"
#define EMAIL       @"email"
#define FIRSTNAME   @"firstname"
#define LASTNAME    @"lastname"
#define USERNAME    @"username"
#define PASSWORD    @"password"
#define USERTYPE    @"usertype" //The different user types (look at enum)
#define DATABASE    @"Users"

#import "UserObject.h"
#import "StatusObject.h"
#import "NSString+Validation.h"


@implementation UserObject

-(NSDictionary *)consolidateForTransmitting{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithCapacity:4];
    [consolidate setValue:_email forKey:EMAIL];
    [consolidate setValue:_firstname forKey:FIRSTNAME];
    [consolidate setValue:_lastname forKey:LASTNAME];
    [consolidate setValue:_username forKey:USERNAME];
    [consolidate setValue:_password forKey:PASSWORD];
    [consolidate setValue:[NSNumber numberWithBool:_status] forKey:STATUS];
    [consolidate setValue:[NSNumber numberWithInt:_type] forKey:USERTYPE];
    [consolidate setValue:[NSNumber numberWithInt:kUserType] forKey:OBJECTTYPE];
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    _email = [self getValueForKey:EMAIL];
    _lastname = [self getValueForKey:LASTNAME];
    _firstname = [self getValueForKey:FIRSTNAME];
    _password = [self getValueForKey:PASSWORD];
    _username = [self getValueForKey:USERNAME];
    _status = [[self getValueForKey:STATUS]boolValue];
    _type = [[self getValueForKey:USERTYPE]intValue];
}



-(void)saveObject:(ObjectResponse)eventResponse
{
    NSLog(@"Save to local Database: Not Yet Implemented");
}

-(void)CommonExecution
{
    NSLog(@"Doesn't need to be implemented Client-side");
}

-(NSString *)description
{
    NSString* text = [NSString stringWithFormat:@"\nUsername: %@ \nPassword: %@ \nUsertype: %i \nObjectType: %i",_username,_password,_type,self.objectType];
    return text;
}

-(BOOL)isUsernameValid
{
    // Username must be between 5 - 20 chars
    if (_username.length < 5 || _username.length > 20) {
        return NO;
    }
    // Check if contains any symbols
    if (![_username isAlphaNumeric]) {
        return NO;
    }
    
    return YES;
}

-(BOOL)isPasswordValid
{
    // Username must be between 5 - 20 chars
    if (_password.length < 5 || _password.length > 20) {
        return NO;
    }
    // Check if contains any symbols
    if (![_username isAlphaNumeric]) {
        return NO;
    }
    return YES;
}

-(void)login:(ObjectResponse)onSuccessHandler
{
    //Call back method that the caller is expecting
    respondToEvent = onSuccessHandler;
    
    // Any methods that makes calls and expects information back
    // you have to listen for the GLOBAL_STATUS_LISTENER
    id obj = [super self];
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];    
    [center addObserver:obj selector:@selector(ActionSuccessfull) name:GLOBAL_STATUS_LISTENER object:tempObject];
    
    //storing internal variables to be sent to the client
    NSMutableDictionary* dataToSend = [NSMutableDictionary dictionaryWithDictionary:[self consolidateForTransmitting]];
    
    //** SETTING THE COMMAND YOU WANT THE SERVER TO EXECUTE WITH YOUR INFORMATION **
    [dataToSend setValue:[NSNumber numberWithInt:kLoginUser] forKey:OBJECTCOMMAND];
    
    // Sending information to the server
    [self.appDelegate.ServerManager sendData:dataToSend];
}



-(void)CreateANewUser:(ObjectResponse)onSuccessHandler{
    // Handle callback
    respondToEvent = onSuccessHandler;
    
    // client side validation
    if ([self isUsernameValid] && [self isPasswordValid]) {
        //Repackage data to be sent
        NSMutableDictionary* dataToSend = [NSMutableDictionary dictionaryWithDictionary:[self consolidateForTransmitting]];
        // adding Command to tell the server to create a new user
        // with the information provided
        [dataToSend setValue:[NSNumber numberWithInt:kCreateNewUser] forKey:OBJECTCOMMAND];
        // Create a listener for when the server sends a responses
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(ActionSuccessfull) name:GLOBAL_STATUS_LISTENER object:tempObject];
        // Send data to server
        [self.appDelegate.ServerManager sendData:dataToSend];
        
    }else{
        
        respondToEvent(Nil,[self createErrorWithDescription:@"Username/Password needs to be longer than 6 characters and contain no symbols" andErrorCodeNumber:0 inDomain:@"User Object"]);
    }
}

@end
