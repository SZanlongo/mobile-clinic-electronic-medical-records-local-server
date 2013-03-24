//
//  MedicationList.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/16/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "MedicationList.h"

@interface MedicationList ()
@property(strong)NSArray* allMedication;
@end


@implementation MedicationList
@synthesize allMedication;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    NSDictionary* medication = [allMedication objectAtIndex:rowIndex];
    
    return [medication objectForKey:aTableColumn.identifier]; 
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    NSInteger list = allMedication.count;
    return list;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{

    return YES;
}

- (IBAction)destructiveResync:(id)sender {
    
}

- (IBAction)setupView:(id)sender {
    allMedication = [NSArray arrayWithArray:[[[MedicationObject alloc]init] FindAllObjectsLocallyFromParentObject]];
    [_tableView reloadData];
}
@end
