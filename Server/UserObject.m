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

#define DATABASE    @"Users"

#import "Users.h"
#import "UserObject.h"
#import "NSString+Validation.h"

@implementation UserObject
+(NSString *)DatabaseName{
    return DATABASE;
}
- (id)init
{
    [self setupObject];
    return [super init];
}
-(id)initAndMakeNewDatabaseObject
{
    [self setupObject];
    return [super initAndMakeNewDatabaseObject];
}
- (id)initAndFillWithNewObject:(NSDictionary *)info
{
    [self setupObject];
    return [super initAndFillWithNewObject:info];
}
-(id)initWithCachedObjectWithUpdatedObject:(NSDictionary *)dic
{
    [self setupObject];
    return [super initWithCachedObjectWithUpdatedObject:dic];
}

-(void)setupObject{
    
    self.COMMONID =  USERNAME;
    self.CLASSTYPE = kPatientType;
    self.COMMONDATABASE = DATABASE;
}

#pragma mark - BaseObjectProtocol Methods
#pragma mark -

//TODO: Add error creator to base object
/* The super needs to be called first */
-(NSDictionary *)consolidateForTransmitting{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting]];
    
    [consolidate setValue:[NSNumber numberWithInt:kUserType] forKey:OBJECTTYPE];

    return consolidate;
}

-(void)ServerCommand:(NSDictionary *)dataToBeRecieved withOnComplete:(ServerCommand)response{
    [super ServerCommand:nil withOnComplete:response];
    [self unpackageFileForUser:dataToBeRecieved];
    [self CommonExecution];
}

/* Depending on the RemoteCommands it will execute a different Command */
-(void)CommonExecution
{
    switch (self.commands) {
        case kPullAllUsers:
            [self sendSearchResults:[self FindAllObjectsLocallyFromParentObject]];            
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

#pragma mark - COMMON OBJECT Methods
#pragma mark -

-(NSArray *)FindAllObjectsLocallyFromParentObject{
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:USERNAME]];
}
-(NSArray *)serviceAllObjectsForParentID:(NSString *)parentID{
     return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:USERNAME]];
}

#pragma mark- Public Methods
#pragma mark-

-(void)SyncAllUsersToLocalDatabase:(ObjectResponse)responder
{
    
    NSMutableDictionary * mDic = [[NSMutableDictionary alloc]init];
    
    //TODO: Remove Hard Dependencies
    [mDic setObject:@"1" forKey:@"created_at"];
    
    [cloudAPI query:@"users" parameters:mDic completion:^(NSError *error, NSDictionary *result) {
        if (!error) {
            [self storeMultipleCloudUsers:result];
            responder(self,nil);
        }else{
            responder(nil,error);
        }
    }];
}




#pragma mark - Private Methods
#pragma mark -

-(BOOL)CompleteServerSideValidation
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
    }else if(![self isObject:user.userName UniqueForKey:USERNAME]){
        [status setStatus:kError];
        [status setErrorMessage:@"Username Already Exists"];
        isValid=NO;
    }else if(![self isObject:user.email UniqueForKey:EMAIL]){
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
    
    return [emailTest evaluateWithObject:user.email];
    
}

-(BOOL)isUsernameValid
{
    // Username must be between 5 - 20 chars
    if (user.userName.length < 5 || user.userName.length > 20) {
        return NO;
    }
    // Check if contains any symbols
    if (![user.userName isAlphaNumeric]) {
        return NO;
    }
    
    return YES;
}

-(BOOL)isPasswordValid
{
    // Username must be between 5 - 20 chars
    if (user.password.length < 5 || user.password.length > 20) {
        return NO;
    }
    return YES;
}


-(BOOL)isObject:(id)obj UniqueForKey:(NSString*)key
{
    // Check if it exists in database
    if ([self FindObjectInTable:DATABASE withName:obj forAttribute:key].count > 0) {
        return NO;
    }
    return YES;
}

-(void)storeMultipleCloudUsers:(NSDictionary*)cloudUsers
{
    //TODO: Remove Hard Dependencies
    NSArray* users = [cloudUsers objectForKey:@"data"];
    
    for (NSDictionary* userInfo in users) {
        self.databaseObject = [self loadObjectWithID:[userInfo objectForKey:USERNAME]];
        
        if (!self.databaseObject) {
            self.databaseObject = [self CreateANewObjectFromClass:DATABASE isTemporary:NO];
            
            [self linkDatabaseObjects];
            
            //TODO: Why are the improper values still showing?
            //[self copyDictionaryValues:userInfo intoManagedObject:self.databaseObject];
            user.userName = [userInfo objectForKey:USERNAME];
            //TODO: How to deal with password
            user.password = @"000000";
            user.firstName = [userInfo objectForKey:FIRSTNAME];
            user.lastName = [userInfo objectForKey:LASTNAME];
            user.email = [userInfo objectForKey:EMAIL];
            user.status = [userInfo objectForKey:STATUS];
            user.userType = [userInfo objectForKey:USERTYPE];
            [self SaveCurrentObjectToDatabase:user];
            user = nil;
        }  
    }
}


-(void)ValidateAndLoginUser
{
    // Initially set it to an error, for efficiency.
    [status setStatus:kError];
    
    NSArray* userArray = [self FindObjectInTable:DATABASE withName:user.userName forAttribute:USERNAME];
    
    // Checks if username exists (should return 1 or 0 value)
    if (userArray.count == 0) {
        // Its good to send a message
        [status setErrorMessage:@"Username doesnt Exist or was incorrect"];
        // Let the status object send this information
        NSLog(@"Username doesnt Exist or was incorrect");

    }else{
    
    // Validate with information inside database
    user = [userArray objectAtIndex:0];
    
    if (![user.password isEqualToString:user.password]) {
        // Its good to send a message
        [status setErrorMessage:@"User Password is incorrect"];
        NSLog(@"User Password is incorrect");
    }else if (!user.status.boolValue) {
        // Its good to send a message
        [status setErrorMessage:@"Please contact your Application Administator to Activate your Account"];
        NSLog(@"User is inactive");
    }
    // status will hold a copy of this user data
    [status setData:[self consolidateForTransmitting]];
    // Indicates that this was a success
    [status setStatus:kSuccess];
    // Its good to send a message
    [status setErrorMessage:@"Login Successfull"];

    }
    
    commandPattern([status consolidateForTransmitting]);
    
}

-(void)linkDatabaseObjects{
    user = (Users*) self.databaseObject;
}
@end
