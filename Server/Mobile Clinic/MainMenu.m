//
//  MainMenu.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/24/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "MainMenu.h"
#import "ServerCore.h"
#import "UserView.h"
#import "PatientTable.h"
#import "MedicationList.h"

MedicationList* medicationView;
PatientTable* patientView;
UserView* userView;
id currentView;
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
    NSInteger num = [connection numberOfConnections];
    
    [_statusIndicator setIntValue:(int)num];
    
    switch (num) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            [_activityLabel setStringValue:@"Stable"];
            break;
        case 6:
        case 7:
            [_activityLabel setStringValue:@"Caution: High Load"];
            break;
        default:
            [_activityLabel setStringValue:@"Warning: Unstable!"];
            break;
    }
    [_connectionLabel setStringValue:[NSString stringWithFormat:@"%li Device(s) Connected",num]];
    return num;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    
    return NO;
}

- (IBAction)showMedicationView:(id)sender {
    if (!medicationView) {
        medicationView = [[MedicationList alloc]initWithNibName:@"MedicationList" bundle:nil];
    }
    if (currentView) {
        [_mainScreen replaceSubview:currentView with:medicationView.view];
        
    }else{
        [_mainScreen addSubview:medicationView.view];
        
    }
    currentView = medicationView.view;
}

- (IBAction)showPatientView:(id)sender {
    if (!patientView) {
        patientView = [[PatientTable alloc]initWithNibName:@"PatientTable" bundle:nil];
    }
    if (currentView) {
        [_mainScreen replaceSubview:currentView with:patientView.view];
        
    }else{
        [_mainScreen addSubview:patientView.view];
        
    }
    currentView = patientView.view;
}

- (IBAction)manualTableRefresh:(id)sender {
    [_serverTable reloadData];
}

- (IBAction)showUserView:(id)sender {
    if (!userView) {
        userView = [[UserView alloc]initWithNibName:@"UserView" bundle:nil];
    }
    if (currentView) {
        [_mainScreen replaceSubview:currentView with:userView.view];
       
    }else{
        [_mainScreen addSubview:userView.view];

    }
    currentView = userView.view;
}

-(void)SetStatus:(NSNotification*)note{
    
    int i = [note.object intValue];

    switch (i) {
        case 0:
            [_statusLabel setStringValue:@"ON"];
            break;

        default:
            [_statusLabel setStringValue:@"OFF"];
            break;
    }
}
@end
