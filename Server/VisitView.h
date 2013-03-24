//
//  VisitView.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/24/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define VISITVIEWEVENT @" visit event"
@interface VisitView : NSWindowController
@property (weak) IBOutlet NSImageView *patientPicture;
@property (strong) IBOutlet NSTextView *visitInformation;
@property (strong) IBOutlet NSScrollView *visitInfoScroll;
@property (weak) IBOutlet NSButton *loadInfo;
@property(strong)NSDictionary* visitRecord;
@property(strong)NSDictionary* patientRecord;

- (IBAction)loadInformationToScreen:(id)sender;

- (IBAction)setVisitRecord:(NSDictionary*)visitRecord forPatient:(NSDictionary*)patientRecord;

@end
