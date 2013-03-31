//
//  UserView.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/23/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "UserView.h"

@interface UserView ()
@property(strong)NSArray* allUsers;
@end

@implementation UserView
@synthesize allUsers,tableView,usernameLabel,primaryRolePicker,loadIndicator;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self refreshTable:nil];
    }
    
    return self;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    NSDictionary* user = [allUsers objectAtIndex:rowIndex];
    
    if ([aTableColumn.identifier isEqualToString:STATUS]) {
        return ([[user objectForKey:aTableColumn.identifier]integerValue]==0)?@"Inactive":@"Active";
    }
    return [user objectForKey:aTableColumn.identifier];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return allUsers.count;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    
    NSDictionary* dict = [allUsers objectAtIndex:row];
    
    [primaryRolePicker selectItemAtIndex:[[dict objectForKey:USERTYPE]integerValue]];
    NSString* name = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:FIRSTNAME],[dict objectForKey:LASTNAME]];
    [usernameLabel setStringValue:name];
    return YES;
}

- (IBAction)refreshTable:(id)sender {
    [loadIndicator startAnimation:self];
    allUsers = [NSArray arrayWithArray:[[[UserObject alloc]init]FindAllObjects]];
    [loadIndicator stopAnimation:self];
    [tableView reloadData];
}

- (IBAction)commitChanges:(id)sender {
    
}

- (IBAction)cloudSync:(id)sender {
    UserObject* users = [[UserObject alloc]init];
    
    [loadIndicator startAnimation:self];
    
    [users pullFromCloud:^(id<BaseObjectProtocol> data, NSError *error) {
      
        if (error) {
            [NSApp presentError:error];
        }else{
            [self refreshTable:nil];
        }
        [loadIndicator stopAnimation:self];
            
    }];
}
@end
