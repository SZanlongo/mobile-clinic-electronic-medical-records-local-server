//
//  PatientTable.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 2/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "PatientTable.h"
#define INNER   @"Inner"

@interface PatientTable ()

@end

@implementation PatientTable

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        patientsHandler = [[PatientObject alloc]init];
        visitsHandler = [[VisitationObject alloc]init];
        [self reloadData];
    }
    return self;
}

-(void)reloadData{
    patientList = [NSArray arrayWithArray:[patientsHandler serviceAllObjects]];
    
    allItems = [[NSMutableArray alloc]init];
    
    for (NSDictionary* p in patientList) {
        
        NSArray* temp = [visitsHandler serviceAllObjectsForParentID:[p objectForKey:PATIENTID]];
        NSMutableDictionary* patientDictionary = [[NSMutableDictionary alloc]initWithCapacity:temp.count];
        NSMutableArray* allVisits = [[NSMutableArray alloc]initWithCapacity:temp.count];
        
        for (NSDictionary* v in temp) {
            // Place all visits into array
            [allVisits addObject:v];
        }
        
        [patientDictionary setValue:allVisits forKey:INNER];
        
        [allItems addObject:patientDictionary];
    }
    [_patientDirectory loadColumnZero];
}

- (id)rootItemForBrowser:(NSBrowser *)browser {

    return allItems;
}

-(NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item{
    if ([item isKindOfClass:[NSArray class]]) {
        return [item count];
    }else if ([item isKindOfClass:[NSDictionary class]]){
        return [[item objectForKey:INNER]count];
    }else{
        return 0;
    }
}
-(id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item{
   
    if ([item isKindOfClass:[NSArray class]]) {
        return [item objectAtIndex:index];
    }else if([item isKindOfClass:[NSDictionary class]]) {
        return [[item objectForKey:INNER]objectAtIndex:index];
    }else{
        return item;
    }
}

-(BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item{

    if ([item isKindOfClass:[NSDictionary class]]) {
        NSArray* inner = [item objectForKey:INNER];
        return (inner.count == 0 || !inner);
    }
    else
        return NO;
}

-(id)browser:(NSBrowser *)browser objectValueForItem:(id)item{
    
    NSString* fn;
    if ([item isKindOfClass:[NSDictionary class]]) {
        fn =  [item objectForKey:FIRSTNAME];
        if (fn) {
            return [NSString stringWithFormat:@"%@ %@",fn,[item objectForKey:FAMILYNAME]];
        }else{
            return [NSString stringWithFormat:@"%@",[item objectForKey:CONDITION]];
        }
    }
    return nil;
}
-(BOOL)browser:(NSBrowser *)sender selectRow:(NSInteger)row inColumn:(NSInteger)column{
    selectedRow = row;
    return YES;
}

- (IBAction)refreshPatients:(id)sender {
    [self reloadData];
}

- (IBAction)unblockPatients:(id)sender {
    patient = [patientList objectAtIndex:selectedRow];
    [patient setValue:@"" forKey:ISLOCKEDBY];
    [patientsHandler SaveCurrentObjectToDatabase:patient];
    patient = nil;
}

- (IBAction)pushPatientsIntoCloud:(id)sender {
    
}

@end
