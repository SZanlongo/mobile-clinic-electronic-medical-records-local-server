//
//  VisitView.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/24/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "VisitView.h"
#import "VisitationObject.h"
#import "PatientObject.h"
#import "PrescriptionObject.h"
@interface VisitView ()

@property(strong)NSDictionary* prescriptionRecord;
@end

@implementation VisitView

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {

    }
    
    return self;
}
- (IBAction)loadInformationToScreen:(id)sender {
    NSArray* array = [NSArray arrayWithArray:[[[PrescriptionObject alloc]init]serviceAllObjectsForParentID:[_visitRecord objectForKey:VISITID]]];
    NSString* prescriptString = @"Prescribed Medication: \n\n";
    
    for (NSDictionary* dict in array) {
        prescriptString = [prescriptString stringByAppendingFormat:@" %@ \n",[[[PrescriptionObject alloc]init]printFormattedObject:dict]];
    }
    
    [self displayRecordsForPatient:[[[PatientObject alloc]init]printFormattedObject:_patientRecord] visit:[[[VisitationObject alloc]init]printFormattedObject:_visitRecord] andPrescription:prescriptString];
}

- (IBAction)setVisitRecord:(NSDictionary*)visitRecord forPatient:(NSDictionary*)patientRecord{
    
    [self loadInformationToScreen:nil];
}
-(void)displayRecordsForPatient:(NSString*)pInfo visit:(NSString*)vInfo andPrescription:(NSString*)prInfo{
    
    NSString* info = [NSString stringWithFormat:@"%@\n%@\n%@\n",pInfo,vInfo,prInfo];

        [_visitInformation setString:info];

}

-(void)StoreInformation:(NSNotification*)note{
    _visitRecord = [NSDictionary dictionaryWithDictionary:[note.object objectAtIndex:0]];
    _patientRecord = [NSDictionary dictionaryWithDictionary:[note.object objectAtIndex:1]];
    [self loadInformationToScreen:nil];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(StoreInformation:) name:VISITVIEWEVENT object:[[NSArray alloc]init]];

}

@end
