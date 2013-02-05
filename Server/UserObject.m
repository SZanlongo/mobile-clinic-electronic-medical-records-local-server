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
-(NSDictionary *)consolidateForTransmitting{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting]];
    
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
/* The super needs to be called first */
-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    
    _email = [data objectForKey:EMAIL];
    _lastname = [data objectForKey:LASTNAME];
    _firstname = [data objectForKey:FIRSTNAME];
    _password = [data objectForKey:PASSWORD];
    _username = [data objectForKey:USERNAME];
    _status = [[data objectForKey:STATUS]intValue];
    _type = [[data objectForKey:USERTYPE]intValue];
    self.commands = [[data objectForKey:OBJECTCOMMAND]intValue];
}
/* The super needs to be called first */
-(void)unpackageDatabaseFileForUser:(NSManagedObject *)object{
    [super unpackageDatabaseFileForUser:object];
    _email = [self getValueForKey:EMAIL];
    _lastname = [self getValueForKey:LASTNAME];
    _firstname = [self getValueForKey:FIRSTNAME];
    _password = [self getValueForKey:PASSWORD];
    _username = [self getValueForKey:USERNAME];
    _status = [[self getValueForKey:STATUS]intValue];
    _type = [[self getValueForKey:USERTYPE]intValue];
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
    if (databaseObject){
 
        [super saveObject:^(id<BaseObjectProtocol> data, NSError* error) {
            [self addObjectToDatabaseObject:_username forKey:USERNAME];
            [self addObjectToDatabaseObject:_password forKey:PASSWORD];
            [self addObjectToDatabaseObject:_firstname forKey:FIRSTNAME];
            [self addObjectToDatabaseObject:_lastname forKey:LASTNAME];
            [self addObjectToDatabaseObject:_email forKey:EMAIL];
            [self addObjectToDatabaseObject:[NSNumber numberWithBool:_status] forKey:STATUS];
            [self addObjectToDatabaseObject:[NSNumber numberWithInt:_type] forKey:USERTYPE];
        }];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:SAVE_USER object:self];
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
-(BOOL)CompleteServerSideValidation:(StatusObject*)status{
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

-(void)CreateANewUser:(ObjectResponse)onSuccessHandler
{
    // Find and return object if it exists
    StatusObject* status = [[StatusObject alloc]init];
    // Need to set client so it can go the correct device
    [status setClient:self.client];
    
    // Run Complete validation on the information given
    // if there is an error it will be stored in the status var
    if ([self CompleteServerSideValidation:status]) {
        if (![self FindDataBaseObjectWithID]){
            [self CreateANewObjectFromClass:DATABASE];
        }
        [self saveObject:nil];
        [status setErrorMessage:@"Your profile has been created. Contact your Application Administrator for approval"];
    }
    
    [status CommonExecution];
}
-(BOOL)isValidEmail{

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
-(BOOL)isObject:(id)obj UniqueForKey:(NSString*)key{
    // Check if it exists in database
    if ([self FindObjectInTable:DATABASE withName:obj forAttribute:key].count > 0) {
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
   
    Users* user = [userArray objectAtIndex:0];
   
    if (![user.password isEqualToString:_password]) {
        // Its good to send a message
        [status setErrorMessage:@"User Password is incorrect"];
        // Let the status object send this information
        [status CommonExecution];
            NSLog(@"User Password is incorrect");
        return;
        }
    
    if (!user.status) {
        // Its good to send a message
        [status setErrorMessage:@"Please contact your Application Administator to Activate your Account"];
        // Let the status object send this information
        [status CommonExecution];
        NSLog(@"User is inactive");
        return;
    }
    // status will hold a copy of this user data
    [status setData:[self consolidateForTransmitting]];
    // Indicates that this was a success
    [status setStatus:kSuccess];
    // Its good to send a message 
    [status setErrorMessage:@"Login Successfull"];
    // Let the status object send this information
    [status CommonExecution];
    
}
@end
