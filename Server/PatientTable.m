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
#import "NSString+Validation.h"

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
    id obj;
    if([aTableView isEqualTo:patientTableView]){
        commonDictionary =  [patientArray objectAtIndex:rowIndex];
        obj = [commonDictionary objectForKey:aTableColumn.identifier];
    }else{
        commonDictionary = [visitArray objectAtIndex:rowIndex];
        obj = [commonDictionary objectForKey:aTableColumn.identifier];
    }
    
    if([aTableColumn.identifier isEqualToString:ISOPEN]){
        return ([obj boolValue])?@"In Queue":@"Closed";
    }else if ([aTableColumn.identifier isEqualToString:TRIAGEIN]){
        return [[NSDate convertSecondsToNSDate:obj] convertNSDateToMonthDayYearTimeString];
    }else{
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
        
        visitArray = [NSArray arrayWithArray:[[[VisitationObject alloc]init]FindAllObjectsUnderParentID:[patient objectForKey:PATIENTID]]];
        [visitTableView reloadData];
        
    }else{
        [self showDetails:[NSNumber numberWithInteger:row]];
    }
    
    return YES;
}


- (IBAction)showDetails:(id)sender {
    NSInteger* visitRow = [sender integerValue];
    if(visitRow >= 0){
        NSDictionary* vRecord = [visitArray objectAtIndex:visitRow];
        
        NSDictionary* pRecord = [patientArray objectAtIndex:patientTableView.selectedRow];
        
        NSArray* array = [NSArray arrayWithArray:[[[PrescriptionObject alloc]init]FindAllObjectsUnderParentID:[vRecord objectForKey:VISITID]]];
        
        NSString* prescriptString = @"Prescribed Medication: \n\n";
        
        for (NSDictionary* dict in array) {
            prescriptString = [prescriptString stringByAppendingFormat:@" %@ \n",[[[PrescriptionObject alloc]init]printFormattedObject:dict]];
        }
        
        [self displayRecordsForPatient:[[[PatientObject alloc]init]printFormattedObject:pRecord] visit:[[[VisitationObject alloc]init]printFormattedObject:vRecord] andPrescription:prescriptString];
    }
}
-(void)displayRecordsForPatient:(NSString*)pInfo visit:(NSString*)vInfo andPrescription:(NSString*)prInfo{
    
    NSString* info = [NSString stringWithFormat:@"%@\n%@\n%@\n",pInfo,vInfo,prInfo];
    
    [_visitDocumentation setString:info];
    
}

- (IBAction)refreshPatients:(id)sender {
    [progressIndicator startAnimation:self];
    patientArray = [NSArray arrayWithArray:[[[PatientObject alloc]init]FindAllObjectsUnderParentID:nil]];
    visitArray = nil;
    [patientTableView reloadData];
    [visitTableView reloadData];
    [progressIndicator stopAnimation:self];
}

- (IBAction)unblockPatients:(id)sender {
    NSMutableDictionary* patient = [patientList objectAtIndex:selectedRow];
    
    [patient setValue:@"" forKey:ISLOCKEDBY];
    
    [[[PatientObject alloc]initWithCachedObjectWithUpdatedObject:patient]saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
        //TODO: Code to change color of object Here
    }];
    
}

- (IBAction)getPatientsFromCloud:(id)sender {
    
    [progressIndicator startAnimation:self];
    
    [[[PatientObject alloc]init] pullFromCloud:^(id cloudResults, NSError *error) {
        if (error) {
            [NSApp presentError:error];
        }else{
            /*
            [[[PatientObject alloc]init] pushToCloud:^(id cloudResults, NSError *error) {
                if (error) {
                    [NSApp presentError:error];
                }else{
                    [self refreshPatients:nil];
                }
            }];
             */
        }
         [progressIndicator stopAnimation:self];
    }];
}

- (IBAction)importFile:(id)sender {
    
    // Create a File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Set array of file types
    NSArray *fileTypesArray;
    fileTypesArray = [NSArray arrayWithObjects:@"csv",@"json", nil];
    
    // Enable options in the dialog.
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowedFileTypes:fileTypesArray];
    [openDlg setAllowsMultipleSelection:NO];
    
    // Display the dialog box.  If the OK pressed,
    // process the files.
    if ( [openDlg runModal] == NSOKButton ) {
        
        // Gets list of all files selected
        NSArray *files = [openDlg URLs];
        
        // Loop through the files and process them.
        NSError* err = nil;
        
        NSArray* arr = [NSArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:files.lastObject] options:0 error:&err]];
        
        if ([arr.description contains:PRESCRIPTIONID]) {
            [self addJsonFileToDatabase:[[PrescriptionObject alloc]init] fromArray:arr];
        }else if([arr.description contains:VISITID]){
            [self addJsonFileToDatabase:[[VisitationObject alloc]init] fromArray:arr];
        }else if([arr.description contains:PATIENTID]){
            [self addJsonFileToDatabase:[[PatientObject alloc]init] fromArray:arr];
        }else{
            //TODO: Add error dialog here
            NSLog(@"The file you chose is not an acceptable file");
        }
        
        NSLog(@"Imported Object: %@", arr);    
    }
    
}
-(void)addJsonFileToDatabase:(id<BaseObjectProtocol>)base fromArray:(NSArray*)array{

    //TODO: Add a completed dialog here
     [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
     
         [base setValueToDictionaryValues:obj];
     
         [base saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
     
         }];
     }];

}
- (IBAction)printPatient:(id)sender{
  
    NSPrintOperation *op = [NSPrintOperation printOperationWithView:_visitDocumentation];
    
    [op setShowsPrintPanel:YES];
    
    if (op)
        [op runOperation];
    else{
        //TODO: Show error Dialog here
        NSLog(@"Failed to open print dialog");
    }
    
}
@end
