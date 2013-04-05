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
    if (!connection){
        connection = [ServerCore sharedInstance];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manualTableRefresh:) name:SERVER_OBSERVER object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SetStatus:) name:SERVER_STATUS object:[[NSNumber alloc]init]];
    }
    return [connection numberOfConnections];
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    
    return NO;
}

- (IBAction)manualTableRefresh:(id)sender {
    [_serverTable reloadData];
}

-(void)SetStatus:(NSNotification*)note{
    
    int i = [note.object intValue];
    
    [_statusIndicator setIntValue:i];
    
    switch (i) {
        case 0:
            [_statusLabel setStringValue:@"OFF"];
            break;
        case 1:
            [_statusLabel setStringValue:@"Bonjour Cannot Establish A Port"];
            break;
        case 2:
            [_statusLabel setStringValue:@"ON with issues"];
            break;
        case 3:
            [_statusLabel setStringValue:@"ON"];
            break;
        default:
            break;
    }
}
@end
