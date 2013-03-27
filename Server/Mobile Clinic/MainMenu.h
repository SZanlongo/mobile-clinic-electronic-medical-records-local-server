//
//  MainMenu.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/24/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainMenu : NSViewController<NSTableViewDataSource,NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *serverTable;
@property (weak) IBOutlet NSLevelIndicator *statusIndicator;
@property (weak) IBOutlet NSTextField *statusLabel;
- (IBAction)manualTableRefresh:(id)sender;
@end
