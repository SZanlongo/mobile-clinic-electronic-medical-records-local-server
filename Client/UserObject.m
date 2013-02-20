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
#define ALL_USERS   @"all users"
#define USERTYPE    @"usertype" //The different user types (look at enum)
#define DATABASE    @"Users"

#import "UserObject.h"
#import "StatusObject.h"
#import "NSString+Validation.h"

StatusObject* tempObject;
ObjectResponse classResponder;
NSString* tempUsername;
NSString* tempPassword;
@implementation UserObject

#pragma mark - Default Methods
#pragma mark -

- (id)initWithNewUser
{
    self = [super init];
    if (self) {
        _user = (Users*)[self CreateANewObjectFromClass:DATABASE];
    }
    return self;
}

-(NSString *)description
{
    NSString* text = [NSString stringWithFormat:@"\nUsername: %@ \nPassword: %@ \nUsertype: %i ",_user.username,_user.password,_user.usertype.intValue];
    return text;
}

#pragma mark - Protocol Methods
#pragma mark -

-(NSDictionary *)consolidateForTransmitting:(NSManagedObject *)object
{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting:object]];
    
    [consolidate setValue:[NSNumber numberWithInt:kUserType] forKey:OBJECTTYPE];
    
    return consolidate;
}

-(void)unpackageFileForUser:(NSDictionary *)data
{
    [super unpackageFileForUser:data];
    [_user setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
}


-(void)saveObject:(ObjectResponse)eventResponse
{
    // First check to see if a databaseObject is present
    if (_user){
        
        [self SaveCurrentObjectToDatabase];
    }
    
    if (eventResponse != nil) {
        eventResponse(self,nil);
    }
    
}

#pragma mark - User Validation
#pragma mark -

-(BOOL)usernameAndPasswordValidation
{
    // Username must be between 5 - 20 chars
    if (_user.password.length < 5 || _user.password.length > 20) {
        return NO;
    }
    // Username must be between 5 - 20 chars
    else if (_user.username.length < 5 || _user.username.length > 20) {
        return NO;
    }
    // Check if contains any symbols
    else if (![_user.username isAlphaNumeric]) {
        return NO;
    }
    
    return YES;
}

-(BOOL)isObject:(NSString*)obj UniqueForKey:(NSString*)key
{
    // Check if it exists in database
    if ([self FindObjectInTable:DATABASE withName:obj forAttribute:key].count > 0) {
        return NO;
    }
    return YES;
}

#pragma mark - User Login & Creation
#pragma mark -

-(void)loginWithUsername:(NSString*)username andPassword:(NSString*)password onCompletion:(ObjectResponse)onSuccessHandler{
    
    //Call back method that the caller is expecting
    respondToEvent = onSuccessHandler;
    
    // Sync all the users from server to the client
    [self getUsersFromServer:^(id<BaseObjectProtocol> data, NSError *error) {

        // Try to find user from username in local DB
        BOOL didFindUser = [self loadUserWithUsername:username];
        
        // if we find the user locally then....
        if (didFindUser) {
            
            // Check if the user has permissions
            if (_user.status.boolValue)
            {
                // Check credentials against the found user
                if ([_user.password isEqualToString:password])
                {
                    respondToEvent(self,nil);
                }
                // If incorrect password then throw an error
                else
                {
                    respondToEvent(Nil,[self createErrorWithDescription:@"Username & Password combination is incorrect" andErrorCodeNumber:0 inDomain:@"User Object"]);
                }
            }
            // If the user doesn't have permission, throw an error
            else
            {
                respondToEvent(Nil,[self createErrorWithDescription:@"You do not have permission to login. Please contact you application administrator" andErrorCodeNumber:0 inDomain:@"User Object"]);
            }
        }
        // if we cannot find the user, throw an error
        else
        {
            respondToEvent(Nil,[self createErrorWithDescription:@"The user does not exists" andErrorCodeNumber:0 inDomain:@"User Object"]);
        }
    }];
    
}

-(void)sendLoginRequestToServer{
    // Any methods that makes calls and expects information back
    // you have to listen for the GLOBAL_STATUS_LISTENER
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(ActionSuccessfull:) name:GLOBAL_STATUS_LISTENER object:tempObject];
    
    //storing internal variables to be sent to the client
    NSMutableDictionary* dataToSend = [NSMutableDictionary dictionaryWithDictionary:[self consolidateForTransmitting:_user]];
    
    //** SETTING THE COMMAND YOU WANT THE SERVER TO EXECUTE WITH YOUR INFORMATION **
    [dataToSend setValue:[NSNumber numberWithInt:kLoginUser] forKey:OBJECTCOMMAND];
    
    // Sending information to the server
    [self.appDelegate.ServerManager sendData:dataToSend];
}

-(void)CreateANewUser:(ObjectResponse)onSuccessHandler
{
    // Handle callback
    respondToEvent = onSuccessHandler;
    
    // client side validation
    if ([self usernameAndPasswordValidation]) {
        
        //Repackage data to be sent
        NSMutableDictionary* dataToSend = [NSMutableDictionary dictionaryWithDictionary:[self consolidateForTransmitting:_user]];
        
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

-(BOOL)loadUserWithUsername:(NSString *)usersName
{

    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K ==[cd] %@",USERNAME,usersName];
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:USERNAME];
    
    if (arr.count == 1) {
        _user = [arr objectAtIndex:0];
        return  YES;
    }
    return  NO;
}

-(void)getUsersFromServer:(ObjectResponse)withResponse
{
    classResponder = withResponse;
    // Create a listener for when the server sends a responses
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(PullAllUsers:) name:GLOBAL_STATUS_LISTENER object:tempObject];
    NSMutableDictionary* dataToSend = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dataToSend setValue:[NSNumber numberWithInt:kPullAllUsers] forKey:OBJECTCOMMAND];
    [dataToSend setValue:[NSNumber numberWithInt:kUserType] forKey:OBJECTTYPE];
    // Send data to server
    [self.appDelegate.ServerManager sendData:dataToSend];
}

#pragma mark - Listen & Respond Methods
#pragma mark -

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
-(void)PullAllUsers:(NSNotification *)notification{
    // Get information that was returned from server
    tempObject = notification.object;
    
    // get all the users returned from server
    NSArray* arr = [tempObject.data objectForKey:ALL_USERS];
    
    // Go through all users in array
    for (NSDictionary* dict in arr) {
        // If the user doesnt exists in the database currently then add it in
        if (![self loadUserWithUsername:[dict objectForKey:USERNAME]]) {
           _user = (Users*)[self CreateANewObjectFromClass:DATABASE];
        }
        
        [_user setValuesForKeysWithDictionary:dict];
        [self SaveCurrentObjectToDatabase];
    }
    
    classResponder(nil,nil);
}
@end
