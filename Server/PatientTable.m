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
        patientList = [NSArray arrayWithArray:[patientsHandler FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:FIRSTNAME]];
       
        BaseObject* base = [[BaseObject alloc]init];
       
        allItems = [[NSMutableArray alloc]init];
        
        for (Patients* p in patientList) {
          
            NSDictionary* pDic = [base getDictionaryValuesFromManagedObject:p];
           
            NSArray* temp = [visitsHandler getVisitsForPatientWithID:[p valueForKey:PATIENTID]];
           
            NSMutableArray* allVisits = [[NSMutableArray alloc]initWithCapacity:temp.count];
            
            for (Visitation* v in temp) {
                // Place all visits into array
                [allVisits addObject: [base getDictionaryValuesFromManagedObject:v]];      
            }
            
            [pDic setValue:allVisits forKey:INNER];
            
            [allItems addObject:pDic];
        }
        [_patientDirectory reloadColumn:0];
       // [_patientTable reloadData];
    }
    return self;
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

}


- (IBAction)refreshPatients:(id)sender {
    patientList = [NSArray arrayWithArray:[patientsHandler FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:FIRSTNAME]];
    [_patientTable reloadData];
}

- (IBAction)unblockPatients:(id)sender {
    patient = [patientList objectAtIndex:selectedRow];
    [patient setValue:@"" forKey:ISLOCKEDBY];
    [patientsHandler SaveCurrentObjectToDatabase:patient];
    [_patientTable deselectRow:selectedRow];
    patient = nil;
}

- (IBAction)pushPatientsIntoCloud:(id)sender {
    
}
@end
