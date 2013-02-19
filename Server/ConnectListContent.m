//
//  ConnectListContent.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/28/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "ConnectListContent.h"

@implementation ConnectListContent
@synthesize user;


-(void)viewWillDraw{
    if (!appDelegate) {
        appDelegate = (FIUAppDelegate*)[[NSApplication sharedApplication]delegate];
        
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        // Called when the server saves information
        [center addObserverForName:SAVE_USER object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self displayUserInformation:note.object];
        }];

        // Called when the user taps a user Row
        [center addObserverForName:SELECTED_A_USER object:nil queue:nil usingBlock:^(NSNotification *note) {
            user = note.object;
            [self displayUserInformation:note.object];
        }];
    }
}

-(void)displayUserInformation:(UserObject*)theUser{
    [_titleText setStringValue:theUser.user.username];
    [_info setString:theUser.description];
    [_Password setStringValue:theUser.user.password];
    [_userTypeBox selectItemAtIndex:theUser.user.usertype.integerValue];
    [_isActiveSegment setSelectedSegment:(theUser.user.status.boolValue)?1:0];
}
-(void)AuthorizeUser:(id)sender{
    NSSegmentedControl* seg = sender;
    user.user.status = [NSNumber numberWithBool:(seg.selectedSegment == 1)?YES:NO];
    [self displayUserInformation:user];
}
-(void)CommitNewUserInfo:(id)sender{
   [user saveObject:^(id<BaseObjectProtocol> data, NSError* error) {
       if (!error) {
           [self displayUserInformation:user];
       }else {
           NSLog(@"ERROR: %@",error.localizedDescription);
       }
   }];
}
@end
