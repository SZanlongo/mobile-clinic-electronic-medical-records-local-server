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
        [center addObserver:self selector:@selector(displayUserInformation:) name:SELECTED_A_USER object:user];
    }
}

-(void)displayUserInformation:(NSNotification*)note{
    user = note.object;
    [_username setStringValue:user.user.username];
    [_email setStringValue:user.user.email];
    [_Password setStringValue:user.user.password];
    [_userTypeBox selectItemAtIndex:user.user.usertype.integerValue];
    [_isActiveSegment setSelectedSegment:(user.user.status.boolValue)?1:0];
}
-(void)AuthorizeUser:(id)sender{
    NSSegmentedControl* seg = sender;
    user.user.status = [NSNumber numberWithBool:(seg.selectedSegment == 1)?YES:NO];
    [_isActiveSegment setSelectedSegment:(user.user.status.boolValue)?1:0];
}

-(void)CommitNewUserInfo:(id)sender{
   [user saveObject:^(id<BaseObjectProtocol> data, NSError* error) {
#warning Create an error;
       if (!error) {
           NSLog(@"ERROR: %@",error.localizedDescription);
       }
   }];
}
@end
