//
//  UserObject.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//


#define ALL_USERS   @"all users"
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

-(void)linkDatabase{
    user = (Users*)self.databaseObject;
}

#pragma mark - User Login & Creation
#pragma mark -

-(void)loginWithUsername:(NSString*)username andPassword:(NSString*)password onCompletion:(ObjectResponse)onSuccessHandler{
    
    //Call back method that the caller is expecting
    respondToEvent = onSuccessHandler;
    
    // Sync all the users from server to the client
    [self getUsersFromServer:^(id<BaseObjectProtocol> data, NSError *error) {

        // Try to find user from username in local DB
        BOOL didFindUser = [self loadObjectForID:username];
        
        // link databaseObject to convenience Object named "user" 
        [self linkDatabase];
        // if we find the user locally then....
        if (didFindUser) {
            
            // Check if the user has permissions
            if (user.status.boolValue)
            {
                // Check credentials against the found user
                if ([user.password isEqualToString:password])
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

-(void)getUsersFromServer:(ObjectResponse)withResponse
{
    NSMutableDictionary* dataToSend = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dataToSend setValue:[NSNumber numberWithInt:kPullAllUsers] forKey:OBJECTCOMMAND];
    [dataToSend setValue:[NSNumber numberWithInt:kUserType] forKey:OBJECTTYPE];

    [self tryAndSendData:dataToSend withErrorToFire:^(id<BaseObjectProtocol> data, NSError *error) {
        withResponse(nil,error);
    } andWithPositiveResponse:^(id data) {
        StatusObject* status = data;
        [self SaveListOfObjectsFromDictionary:status.data];
        withResponse(self,nil);
    }];

}

@end
