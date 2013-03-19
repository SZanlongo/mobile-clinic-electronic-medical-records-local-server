//
//  ConnectionTable.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "ConnectionTable.h"
#import "ServerCore.h"
#import "UserObject.h"
id connection;

DatabaseDriver* userDatabaseDriver;
UserObject* users;
@implementation ConnectionTable
@synthesize listOfUsers;
#pragma mark -
#pragma mark NSTableView delegate methods

-(void)viewDidMoveToWindow{
    if (!appDelegate) {
        appDelegate = (FIUAppDelegate*)[[NSApplication sharedApplication]delegate];
        userDatabaseDriver = [[DatabaseDriver alloc]init];

        listOfUsers = [[NSMutableArray alloc]init];
        
        [self setDelegate:self];
        [self setDataSource:self];

        // connection = [ServerWrapper sharedServerManager];
        connection = [ServerCore sharedInstance];
        
        [connection startServer];
        
        users = [[UserObject alloc]init];
        appDelegate.server = connection;
        [self refreshServer:nil];
    }
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
   NSDictionary* user = [NSDictionary dictionaryWithDictionary:[listOfUsers objectAtIndex:rowIndex]];
	return [user objectForKey:USERNAME];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    NSInteger list = listOfUsers.count;
	NSLog(@"Count: %li", list);
    return list;
}
-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{

    NSDictionary* user = [NSDictionary dictionaryWithDictionary:[listOfUsers objectAtIndex:row]];
    
    NSString* username = [user objectForKey:USERNAME];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:SELECTED_A_USER object:username];
    return YES;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;
{
 
}

-(void)refreshServer:(id)sender{
    
    if (users) {
        [users SyncAllUsersToLocalDatabase:^(id<BaseObjectProtocol> data, NSError *error) {

            listOfUsers = [NSArray arrayWithArray:[users serviceAllObjects]];

            [self reloadData];
        }];

    }  
}
-(void)StopServer:(id)sender{
    NSSegmentedControl* sc = sender;
    switch ([sc selectedSegment]) {
        case 0:
            [connection startServer];
            break;
        case 1:
            [connection stopServer];
            break;
        default:
            break;
    }
    
}

-(void)AuthorizeUser:(id)sender{
    
}
-(void)CommitNewUserInfo:(id)sender{
    
}
@end
