//
//  UserView.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/23/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UserObject.h"
@interface UserView : NSViewController<NSTableViewDataSource,NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *usernameLabel;
@property (weak) IBOutlet NSComboBox *primaryRolePicker;
@property (weak) IBOutlet NSProgressIndicator *loadIndicator;

- (IBAction)refreshTable:(id)sender;
- (IBAction)commitChanges:(id)sender;
- (IBAction)cloudSync:(id)sender;

@end
