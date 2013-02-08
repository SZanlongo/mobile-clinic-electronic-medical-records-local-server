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

StatusObject* tempObject;
@implementation UserObject

- (id)init
{
    self = [super init];
    if (self) {
        _password = [[NSString alloc]init];
        _username = [[NSString alloc]init];
        _firstname = [[NSString alloc]init];
        _lastname = [[NSString alloc]init];
        _email = [[NSString alloc]init];
    }
    return self;
}

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
    self.email = [data objectForKey:EMAIL];
    self.lastname = [data objectForKey:LASTNAME];
    self.firstname = [data objectForKey:FIRSTNAME];
    self.password = [data objectForKey:PASSWORD];
    self.username = [data objectForKey:USERNAME];
    self.status = [[data objectForKey:STATUS]boolValue];
    self.type = [[data objectForKey:USERTYPE]intValue];
}

/* The super needs to be called first */
-(void)unpackageDatabaseFileForUser:(NSManagedObject *)object{
    [super unpackageDatabaseFileForUser:object];
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
    // First check to see if a databaseObject is present
    if (!databaseObject)
        if ([self isObject:_username UniqueForKey:USERNAME]) 
            // Otherwise create a new object from scratch
            [self CreateANewObjectFromClass:DATABASE];
    
        [super saveObject:^(id<BaseObjectProtocol> data, NSError* error) {
            [self addObjectToDatabaseObject:_username forKey:USERNAME];
            [self addObjectToDatabaseObject:_password forKey:PASSWORD];
            [self addObjectToDatabaseObject:_firstname forKey:FIRSTNAME];
            [self addObjectToDatabaseObject:_lastname forKey:LASTNAME];
            [self addObjectToDatabaseObject:_email forKey:EMAIL];
            [self addObjectToDatabaseObject:[NSNumber numberWithBool:_status] forKey:STATUS];
            [self addObjectToDatabaseObject:[NSNumber numberWithInt:_type] forKey:USERTYPE];
        }];
    
    if (eventResponse != nil) {
        eventResponse(self,nil);
    }
    

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
    
    
    
    if (![self userExistInCache])
    {
        // Any methods that makes calls and expects information back
        // you have to listen for the GLOBAL_STATUS_LISTENER
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(ActionSuccessfull:) name:GLOBAL_STATUS_LISTENER object:tempObject];
        
        //storing internal variables to be sent to the client
        NSMutableDictionary* dataToSend = [NSMutableDictionary dictionaryWithDictionary:[self consolidateForTransmitting]];
        
        //** SETTING THE COMMAND YOU WANT THE SERVER TO EXECUTE WITH YOUR INFORMATION **
        [dataToSend setValue:[NSNumber numberWithInt:kLoginUser] forKey:OBJECTCOMMAND];
        
        // Sending information to the server
        [self.appDelegate.ServerManager sendData:dataToSend];
    }

}

-(BOOL)isObject:(NSString*)obj UniqueForKey:(NSString*)key
{
    // Check if it exists in database
    if ([self FindObjectInTable:DATABASE withName:obj forAttribute:key].count > 0) {
        return NO;
    }
    return YES;
}

-(BOOL)userExistInCache{
   
    // Find user by username
    NSArray* users =[self FindObjectInTable:DATABASE withName:_username forAttribute:USERNAME];
    
    // Check if there is a user
    if (users.count >= 1) {
        
        NSString* pass = [self getValueForKey:PASSWORD fromObject:users.lastObject];
        // Compare password
        if ([pass isEqualToString:_password]) {
            // Return that login is successful
            respondToEvent(self,nil);
        }
        else
        {
            // Return that password has failed
          respondToEvent(Nil,[self createErrorWithDescription:@"Username/Password needs to be longer than 6 characters and contain no symbols" andErrorCodeNumber:0 inDomain:@"User Object"]);  
        }
        // Acknowledge that a user exists
        return YES;
    }
    // if user doesn't exist, return no and check against server
    return NO;
}

-(void)ActionSuccessfull:(NSNotification *)notification
{

    // Remove event listener
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    tempObject = notification.object;
    if (tempObject.status == kSuccess) {
        // Reset this object with the information brought back through the server
        [self unpackageFileForUser:notification.userInfo];
        
        // Activate the callback so user knows it was successful
        respondToEvent(self, nil);
        // Save the new user information that has been returned
        [self saveObject:nil];
    }else{
        respondToEvent(nil,[self createErrorWithDescription:tempObject.errorMessage andErrorCodeNumber:10 inDomain:@"BaseObject"] );
    }
    
   
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
        
    }
}

@end
