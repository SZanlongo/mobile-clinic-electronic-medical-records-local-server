//
//  PatientTable.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "PatientTable.h"
#define INNER   @"Inner"
#import "DataProcessor.h"
#import "VisitView.h"
VisitView* visit;
@interface PatientTable ()
@property(strong)NSArray* patientArray;
@property(strong)NSArray* AllVisitArray;
@property(strong)NSArray* visitArray;
@end

@implementation PatientTable
@synthesize patientArray,visitArray,patientTableView,visitTableView,AllVisitArray,progressIndicator;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self refreshPatients:nil];
    }
    return self;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    NSDictionary* commonDictionary;
    
    if([aTableView isEqualTo:patientTableView]){
        commonDictionary =  [patientArray objectAtIndex:rowIndex];
        return [commonDictionary objectForKey:aTableColumn.identifier];
    }else{
        commonDictionary = [visitArray objectAtIndex:rowIndex];
        id obj = [commonDictionary objectForKey:([aTableColumn.identifier isEqualToString:@"visitDate"])?TRIAGEIN:CONDITION];
        if ([obj isKindOfClass:[NSDate class]]) {
            return [obj convertNSDateToMonthDayYearTimeString];
        }
        return obj;
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    if([aTableView isEqualTo:patientTableView])
        return patientArray.count;
    else
        return visitArray.count;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    
    if([tableView isEqualTo:patientTableView]){
        
        NSDictionary* patient = [patientArray objectAtIndex:row];

        visitArray = [NSArray arrayWithArray:[[[VisitationObject alloc]init]serviceAllObjectsForParentID:[patient objectForKey:PATIENTID]]];
        [visitTableView reloadData];

    }

    return YES;
}


- (IBAction)showDetails:(id)sender {
  
    
    
    NSInteger visitRow = [visitTableView selectedRow];
    
    if (visitRow > -1) {
        if (!visit.window) {
            visit= [[VisitView alloc]initWithWindowNibName:@"VisitView" owner:self];
            [visit showWindow:self];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:VISITVIEWEVENT object:[NSArray arrayWithObjects:[visitArray objectAtIndex:visitRow],[patientArray objectAtIndex:[patientTableView selectedRow]], nil]];
            
            
        }
    }
}

- (IBAction)refreshPatients:(id)sender {
    [progressIndicator startAnimation:self];
    patientArray = [NSArray arrayWithArray:[[[PatientObject alloc]init]serviceAllObjectsForParentID:nil]];
    visitArray = nil;
    [patientTableView reloadData];
    [visitTableView reloadData];
    [progressIndicator stopAnimation:self];
}

- (IBAction)unblockPatients:(id)sender {
   NSMutableDictionary* patient = [patientList objectAtIndex:selectedRow];
    
    [patient setValue:@"" forKey:ISLOCKEDBY];
    
    [[[PatientObject alloc]initWithCachedObjectWithUpdatedObject:patient]saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
        // Code to change color of object Here
    }];
   
}

- (IBAction)getPatientsFromCloud:(id)sender {
   
    [progressIndicator startAnimation:self];
    
    [[[PatientObject alloc]init] PullAllPatientsFromCloud:^(id<BaseObjectProtocol> data, NSError *error) {
        [progressIndicator stopAnimation:self];
        [self refreshPatients:nil];
    }];
}

@end
