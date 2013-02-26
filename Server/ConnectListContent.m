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
    
    [_username setStringValue:[user getObjectForAttribute:USERNAME]];
    [_email setStringValue:[user getObjectForAttribute:EMAIL]];
    [_Password setStringValue:[user getObjectForAttribute:PASSWORD]];
    [_userTypeBox selectItemAtIndex:[[user getObjectForAttribute:USERNAME]integerValue]];
    [_isActiveSegment setSelectedSegment:([[user getObjectForAttribute:USERNAME]boolValue])?1:0];
}
-(void)AuthorizeUser:(id)sender{
    NSSegmentedControl* seg = sender;
    
    [user setObject:[NSNumber numberWithBool:(seg.selectedSegment == 1)?YES:NO] withAttribute:STATUS ];
    [_isActiveSegment setSelectedSegment:([[user getObjectForAttribute:USERNAME]boolValue])?1:0];
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
