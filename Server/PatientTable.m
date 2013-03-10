//
//  PatientTable.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "PatientTable.h"

@interface PatientTable ()

@end

@implementation PatientTable

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        patientsHandler = [[PatientObject alloc]init];
        
        patientList = [NSArray arrayWithArray:[patientsHandler FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:FIRSTNAME]];

        [_patientTable reloadData];
    }
    return self;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
   
    NSManagedObject* dictionary = [patientList objectAtIndex:row];
    
    if ([tableColumn.identifier isEqualToString:@"patientName"]) {
        return [NSString stringWithFormat:@"%@ %@",[dictionary valueForKey:FIRSTNAME],[dictionary valueForKey:FAMILYNAME]];
    }else{
        
        NSString* username = [dictionary valueForKey:ISLOCKEDBY];
        
        BOOL isBlocked = (!username || [username isEqualToString:@""]);
        return (isBlocked)?@"Unlocked":@"Locked";
    }
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return patientList.count;
}

- (IBAction)refreshPatients:(id)sender {
    patientList = [NSArray arrayWithArray:[patientsHandler FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:FIRSTNAME]];
    [_patientTable reloadData];
}

- (IBAction)unblockPatients:(id)sender {
}

- (IBAction)pushPatientsIntoCloud:(id)sender {
}
@end
