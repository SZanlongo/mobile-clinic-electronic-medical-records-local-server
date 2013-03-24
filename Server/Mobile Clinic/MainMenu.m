//
//  MainMenu.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/24/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "MainMenu.h"
#import "ServerCore.h"

id<ServerProtocol> connection;
@implementation MainMenu


- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    
    if([aTableColumn.identifier isEqualToString:@"hostName"])
        return  [connection getHostNameForSocketAtIndex:rowIndex];
    else
        return [connection getPortForSocketAtIndex:rowIndex];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    if (!connection) 
        connection = [ServerCore sharedInstance];
    
    return [connection numberOfConnections];
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    
    return NO;
}

- (IBAction)manualTableRefresh:(id)sender {
    [_serverTable reloadData];
}

@end
