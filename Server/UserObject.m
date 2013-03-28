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
#import "BaseObject+Protected.h"

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
    
    self->COMMONID =  USERNAME;
    self->CLASSTYPE = kPatientType;
    self->COMMONDATABASE = DATABASE;
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
    switch (self->commands) {
        case kPullAllUsers:
            [self sendSearchResults:[self FindAllObjects]];
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
-(NSArray *)FindAllObjects{
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:USERNAME]];
}

-(NSArray *)FindAllObjectsUnderParentID:(NSString *)parentID{
    return [self FindAllObjects];
}

#pragma mark- Public Methods
#pragma mark-
-(void)pullFromCloud:(CloudCallback)onComplete{
    
}
-(void)SyncAllUsersToLocalDatabase:(ObjectResponse)responder
{
    
    NSMutableDictionary * mDic = [[NSMutableDictionary alloc]init];
    
    //TODO: Remove Hard Dependencies
    [mDic setObject:@"1" forKey:@"created_at"];
    
    [[CloudService cloud] query:@"users" parameters:mDic completion:^(NSError *error, NSDictionary *result) {
        if (error && !result) {
            responder(nil,error);
        }else{
            [self storeMultipleCloudUsers:result];
            responder(self,nil);
        }
    }];
}

#pragma mark - Private Methods
#pragma mark -

-(void)storeMultipleCloudUsers:(NSDictionary*)cloudUsers
{
    //TODO: Remove Hard Dependencies
    NSArray* users = [cloudUsers objectForKey:@"data"];
    
    for (NSDictionary* userInfo in users) {
        self->databaseObject = [self loadObjectWithID:[userInfo objectForKey:USERNAME]];
        
        if (!self->databaseObject) {
            self->databaseObject = [self CreateANewObjectFromClass:DATABASE isTemporary:NO];
            
            //TODO: Why are the improper values still showing?
            BOOL success = [self setValueToDictionaryValues:userInfo];
            /*
            [self setObject:[userInfo objectForKey:USERNAME] withAttribute:USERNAME];
            [self setObject:[userInfo objectForKey:PASSWORD] withAttribute:PASSWORD];
            [self setObject:[userInfo objectForKey:FIRSTNAME] withAttribute:FIRSTNAME];
            [self setObject:[userInfo objectForKey:LASTNAME] withAttribute:LASTNAME];
            [self setObject:[userInfo objectForKey:EMAIL] withAttribute:EMAIL];
            [self setObject:[userInfo objectForKey:STATUS] withAttribute:STATUS];
            [self setObject:[userInfo objectForKey:USERTYPE] withAttribute:USERTYPE];
             */
            if (success) {
                [self saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
                    
                }];
            }else{
              NSError*  error = [[NSError alloc]initWithDomain:COMMONDATABASE code:kErrorObjectMisconfiguration userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Object was misconfigured",NSLocalizedFailureReasonErrorKey, nil]];
                
                [NSApp presentError:error];
                break;
            }

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
    user = (Users*) self->databaseObject;
}
@end
