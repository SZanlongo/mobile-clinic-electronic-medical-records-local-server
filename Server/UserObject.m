//
//  UserObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

/* NOTE ABOUT THIS CLASS
 * Make user you call super for any of the methods that are part of the BaseObjectProtocol
 * 
 */

// These are elements within the database
// This prevents hardcoding
#define STATUS      @"status"
#define EMAIL       @"email"
#define FIRSTNAME   @"firstname"
#define LASTNAME    @"lastname"
#define USERNAME    @"username"
#define PASSWORD    @"password"
#define USERTYPE    @"usertype" //The different user types (look at enum)

#define DATABASE    @"Users"

#import "Users.h"
#import "UserObject.h"
#import "StatusObject.h"
#import "NSString+Validation.h"

@implementation UserObject

#pragma mark - BaseObjectProtocol Methods
#pragma mark -

/* The super needs to be called first */
-(NSDictionary *)consolidateForTransmitting:(NSManagedObject *)object{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting:object]];
    
    [consolidate setValue:[NSNumber numberWithInt:kUserType] forKey:OBJECTTYPE];

    return consolidate;
}

/* The super needs to be called first */
-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    [_user setValuesForKeysWithDictionary:[data objectForKey:DATABASEOBJECT]];
}


/* Depending on the RemoteCommands it will execute a different Command */
-(void)CommonExecution
{
    switch (self.commands) {
        case kCreateNewUser:
            [self CreateANewUser:nil];
            break;
        case kLoginUser:
            [self ValidateAndLoginUser];
            break;
        case kLogoutUser:
            
            break;
        default:
            break;
    }
}


/* Make sure you call Super after checking the existance of the database object
 * This can be done by doing the following:
 *       if (![self FindDataBaseObjectWithID]) {
 *               [self CreateANewObjectFromClass:<<CLASS NAME>>];
 *           }
 */
-(void)saveObject:(ObjectResponse)eventResponse
{

    if (_user){
 
        [self SaveCurrentObjectToDatabase:_user];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:SAVE_USER object:self];
        if (eventResponse) 
            eventResponse(self, nil);
    }else{
//        if (eventResponse)
//            eventResponse(self, nil);
    }
}

#pragma mark - Private Methods
#pragma mark -

-(NSString *)description
{
    
    NSString* text = [NSString stringWithFormat:@"\nFirstname: %@ \nLastname: %@\nUsername: %@ \nPassword: %@ \nEmail: %@ \nStatus: %@ \nUsertype: %i ",_firstname,_lastname,_username,_password,_email,(_status)?@"Active":@"Inactive",_type];
    
    [text stringByAppendingString:[super description]];
    
    return text;
}

-(BOOL)CompleteServerSideValidation:(StatusObject*)status
{
    BOOL isValid = YES;
    [status setStatus:kSuccess];
    
    if (![self isPasswordValid] && ![self isUsernameValid] ) {
        [status setStatus:kError];
        [status setErrorMessage:@"Your username and or password does not meet criteria"];
        isValid =NO;
    }else if(![self isValidEmail]){
        [status setStatus:kError];
        [status setErrorMessage:@"Please enter a valid email address"];
        isValid=NO;
    }else if(![self isObject:_username UniqueForKey:USERNAME]){
        [status setStatus:kError];
        [status setErrorMessage:@"Username Already Exists"];
        isValid=NO;
    }else if(![self isObject:_email UniqueForKey:EMAIL]){
        [status setStatus:kError];
        [status setErrorMessage:@"Email Already Exists"];
        isValid=NO;
    }
    return isValid;
}

-(BOOL)isValidEmail
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:_email];
    
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

-(void)CreateANewUser:(ObjectResponse)onSuccessHandler
{
    // Find and return object if it exists
    StatusObject* status = [[StatusObject alloc]init];
    // Need to set client so it can go the correct device
    [status setClient:self.client];
    
    // Run Complete validation on the information given
    // if there is an error it will be stored in the status var
    if ([self CompleteServerSideValidation:status]) {
        // If validation passes a new user is create
        [self CreateANewObjectFromClass:DATABASE];
        // Save the new user
        [self saveObject:nil];
        // store a message that the user has been created
        [status setErrorMessage:@"Your profile has been created. Contact your Application Administrator for approval"];
    }
    
    [status CommonExecution];
}

-(BOOL)isObject:(id)obj UniqueForKey:(NSString*)key
{
    // Check if it exists in database
    if ([self FindObjectInTable:DATABASE withName:obj forAttribute:key].count > 0) {
        return NO;
    }
    return YES;
}

-(void)ValidateAndLoginUser{
   
    StatusObject* status = [[StatusObject alloc]init];
    // Need to set client so it can go the correct device
    [status setClient:self.client];
    // Initially set it to an error, for efficiency.
    [status setStatus:kError];
    
    NSArray* userArray = [self FindObjectInTable:DATABASE withName:_username forAttribute:USERNAME];
    
    // Checks if username exists (should return 1 or 0 value)
    if (userArray.count == 0) {
        // Its good to send a message
        [status setErrorMessage:@"Username doesnt Exist or was incorrect"];
        // Let the status object send this information
        [status CommonExecution];
            NSLog(@"Username doesnt Exist or was incorrect");
        return;
    }
   
    // Validate with information inside database
    _user = [userArray objectAtIndex:0];
   
    if (![_user.password isEqualToString:_password]) {
        // Its good to send a message
        [status setErrorMessage:@"User Password is incorrect"];
        // Let the status object send this information
        [status CommonExecution];
            NSLog(@"User Password is incorrect");
        return;
        }
    
    if (!_user.status.boolValue) {
        // Its good to send a message
        [status setErrorMessage:@"Please contact your Application Administator to Activate your Account"];
        // Let the status object send this information
        [status CommonExecution];
        NSLog(@"User is inactive");
        return;
    }
    
    // status will hold a copy of this user data
    [status setData:[self consolidateForTransmitting:_user]];
    // Indicates that this was a success
    [status setStatus:kSuccess];
    // Its good to send a message 
    [status setErrorMessage:@"Login Successfull"];
    // Let the status object send this information
    [status CommonExecution];
    
}

-(BOOL)loadUserWithUsername:(NSString *)usersName{
    
    // checks to see if object exists
    NSArray* arr = [self FindObjectInTable:DATABASE withName:usersName forAttribute:USERNAME];

    if (arr.count == 1) {
       _user = [arr objectAtIndex:0];
        return  YES;
    }
    return  NO;
}
@end
