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
    self->CLASSTYPE = kUserType;
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
        case kAbort:
            NSLog(@"Error: User Object Misconfiguration handled by baseObject");
            break;
        case kPullAllUsers:
            [self sendSearchResults:[self FindAllObjects]];
            break;
        case kLoginUser:
            [self ValidateAndLoginUser];
            break;
        case kLogoutUser:
            break;
        default:
            [self sendInformation:nil toClientWithStatus:kErrorBadCommand andMessage:@"Server recieved a bad command"];
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

-(NSString *)printFormattedObject:(NSDictionary *)object{
    return @"Not Implemented Yet";
}
#pragma mark- Public Methods
#pragma mark-

-(void)pushToCloud:(CloudCallback)onComplete{
   
    onComplete(nil,[[NSError alloc]initWithDomain:COMMONDATABASE code:kErrorObjectMisconfiguration userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"This feature is not implemented",NSLocalizedFailureReasonErrorKey, nil]]);
    
}

-(void)pullFromCloud:(CloudCallback)onComplete{
    
    //TODO: Remove Hard Dependencies

    [self makeCloudCallWithCommand:DATABASE withObject:nil onComplete:^(id cloudResults, NSError *error) {

        NSArray* users = [cloudResults objectForKey:@"data"];
            
        [self handleCloudCallback:onComplete UsingData:users WithPotentialError:error];
    }];
}

#pragma mark - Private Methods
#pragma mark -


-(void)ValidateAndLoginUser
{
    // Initially set it to an error, for efficiency.
    [status setStatus:kError];
    
    NSArray* userArray = [self FindObjectInTable:DATABASE withName:user.userName forAttribute:USERNAME];
    
   NSArray* filtered = [userArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@",USERNAME,user.userName]];
    
    // Checks if username exists (should return 1 or 0 value)
    if (filtered.count == 0 || filtered.count > 1) {
        // Its good to send a message
        [status setErrorMessage:@"Username doesnt Exist or was incorrect"];
        // Let the status object send this information
        NSLog(@"Username doesnt Exist or was incorrect");
        
    }else{
        
        // Validate with information inside database
        user = [filtered objectAtIndex:0];
        
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
-(NSArray *)covertAllSavedObjectsToJSON{
    
    NSArray* allPatients= [self FindObjectInTable:COMMONDATABASE withCustomPredicate:[NSPredicate predicateWithFormat:@"%K == YES",ISDIRTY] andSortByAttribute:USERNAME];
    NSMutableArray* allObject = [[NSMutableArray alloc]initWithCapacity:allPatients.count];
    
    for (NSManagedObject* obj in allPatients) {
        [allObject addObject:[obj dictionaryWithValuesForKeys:[obj attributeKeys]]];
    }
    return  allObject;
}

-(void)linkDatabaseObjects{
    user = (Users*) self->databaseObject;
}
@end
