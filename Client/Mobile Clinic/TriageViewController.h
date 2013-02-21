//
//  TriageViewController.h
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationViewHandlerProtocol.h"
@interface TriageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    ScreenHandler handler;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *viewSelectorSegment;

-(void)setScreenHandler:(ScreenHandler)myHandler;
@end
