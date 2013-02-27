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
        users = [[UserObject alloc]init];
        listOfUsers = [[NSMutableArray alloc]init];
        [self setDelegate:self];
        [self setDataSource:self];
        
         NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        
        // Normally the appdelegate starts first but in this case it doesnt, so
        // we listen for when the appdelegate says its up and running
        [center addObserver:self selector:@selector(SetupAnythingThatNeedsCoreData:) name:APPDELEGATE_STARTED object:appDelegate];
        
        // listen for when users add themselves to the database
        [center addObserverForName:SAVE_USER object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self refreshServer:nil];
        }];
        
        // connection = [ServerWrapper sharedServerManager];
        connection = [ServerCore sharedInstance];
        
        [connection startServer];
    }
}

-(void)SetupAnythingThatNeedsCoreData:(NSNotification*)note{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:APPDELEGATE_STARTED object:appDelegate];
    
    // On First load, Sync Users from cloud to local server
    users = [[UserObject alloc]init];
    appDelegate = note.object;
    appDelegate.server = connection;
    [self refreshServer:nil];    
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    UserObject* user = [[UserObject alloc]init];
    [user setDBObject:[listOfUsers objectAtIndex:rowIndex]];
	return [user getObjectForAttribute:USERNAME];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    NSInteger list = listOfUsers.count;
	NSLog(@"Count: %li", list);
    return list;
}
-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    UserObject* user = [[UserObject alloc]init];
       [user setDBObject:[listOfUsers objectAtIndex:row]];
    [[NSNotificationCenter defaultCenter]postNotificationName:SELECTED_A_USER object:user];
    return YES;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;
{
 
}

-(void)refreshServer:(id)sender{
      
    [users SyncAllUsersToLocalDatabase:^(id<BaseObjectProtocol> data, NSError *error) {
        [self beginUpdates];

        listOfUsers = [NSArray arrayWithArray:[users getAllUsersFromDatabase]];
        [self endUpdates];
        [self reloadData];
    }];
    
   
    
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
