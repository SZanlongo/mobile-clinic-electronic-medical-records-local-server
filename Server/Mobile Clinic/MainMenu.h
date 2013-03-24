//
//  MainMenu.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/24/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainMenu : NSWindow<NSTableViewDataSource,NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *serverTable;

- (IBAction)manualTableRefresh:(id)sender;
@end
