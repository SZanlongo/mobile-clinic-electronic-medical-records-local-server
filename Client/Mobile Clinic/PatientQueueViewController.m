//
//  PatientQueueViewController.m
//  Mobile Clinic
//
//  Created by Rigo Hernandez on 3/10/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "PatientQueueViewController.h"
#import "DoctorPatientViewController.h"
#import "PharmacyPatientViewController.h"

@interface PatientQueueViewController () {
    MobileClinicFacade * mobileFacade;
    NSArray * queueArray;
}
@end

@implementation QueueTableCell

@end

@implementation PatientQueueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if(!mobileFacade)
            mobileFacade = [[MobileClinicFacade alloc] init];

    UINavigationBar * navbar = [self.navigationController navigationBar];
    
    // Request patient's that are currently checked in
    [mobileFacade findAllOpenVisitsAndOnCompletion:^(NSArray *allObjectsFromSearch, NSError *error) {
        queueArray = [NSArray arrayWithArray:allObjectsFromSearch];
        
        // Settings with respect to station chosen
        switch ([[self stationChosen] intValue]) {
            case 2: {
                [navbar setTintColor:[UIColor blueColor]];
                
                // Filter results to patient's that haven't seen the doctor
                //            NSString * predicateString = [NSString stringWithFormat:@"'%K' == '%@'", DOCTOROUT, nil];
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", DOCTOROUT, nil];
                queueArray = [NSMutableArray arrayWithArray:[queueArray filteredArrayUsingPredicate:predicate]];
                
                // Sort queue by priority
                NSSortDescriptor * sortDescriptor;
                sortDescriptor = [[NSSortDescriptor alloc]initWithKey:PRIORITY ascending:NO];
                NSArray * sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                queueArray = [NSMutableArray arrayWithArray:[queueArray sortedArrayUsingDescriptors:sortDescriptors]];
            }
                break;
            case 3: {
                [navbar setTintColor:[UIColor greenColor]];
                
                // Filter results (Seen doctor & need to see pharmacy)
                //            NSString * predicateString = [NSString stringWithFormat:@"'%@' != '%@'", @"doctorOut", @""];
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K != %@", DOCTOROUT, nil];
                queueArray = [NSMutableArray arrayWithArray:[queueArray filteredArrayUsingPredicate:predicate]];
                
                // Sort queue by time patient left doctor's station
//                NSSortDescriptor * sortDescriptor;
//                sortDescriptor = [[NSSortDescriptor alloc]initWithKey:DOCTOROUT ascending:NO];
//                NSArray * sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//                queueArray = [NSMutableArray arrayWithArray:[queueArray sortedArrayUsingDescriptors:sortDescriptors]];
            }
                break;
            default:
                break;
        }
        
        [_queueTableView reloadData];
    }];
}


- (void)viewDidUnload {
    [self setQueueTableView:nil];
    [super viewDidUnload];
}

// Defines number of sections 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Defines number of cells in table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"COUNT OF QUEUE RESULTS: %d", queueArray.count);
    return queueArray.count;
}

// Populate cells with respective content
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"queueCell";
    
    QueueTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        cell = [[QueueTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary * visitDic = [[NSDictionary alloc]initWithDictionary:[queueArray objectAtIndex:indexPath.row]];
    NSDictionary * patientDic = [visitDic objectForKey:OPEN_VISITS_PATIENT];
    
    // Set Priority Indicator color
    // Hide it for Pharmacy
    if([[self stationChosen]intValue] == 3)
        cell.priorityIndicator.backgroundColor = [UIColor whiteColor];
    
    // Show for Doctor
    else if([[visitDic objectForKey:PRIORITY]intValue] == 0)
        cell.priorityIndicator.backgroundColor = [UIColor yellowColor];
    else if([[visitDic objectForKey:PRIORITY]intValue] == 1)
        cell.priorityIndicator.backgroundColor = [UIColor purpleColor];
    else if([[visitDic objectForKey:PRIORITY]intValue] == 2)
        cell.priorityIndicator.backgroundColor = [UIColor redColor];
    
    // Display contents of cells
    if ([[patientDic objectForKey:PICTURE]isKindOfClass:[NSData class]]) {
        UIImage * image = [UIImage imageWithData: [patientDic objectForKey:PICTURE]];
        [cell.patientPhoto setImage:image];
    }
    
    NSDate * date = [patientDic objectForKey:DOB];
    BOOL doesDOBExist = ([date isKindOfClass:[NSDate class]] && date);
    NSString * firstName = [patientDic objectForKey:FIRSTNAME];
    NSString * familyName = [patientDic objectForKey:FAMILYNAME];
    
    cell.patientName.text = [NSString stringWithFormat:@"%@ %@", firstName, familyName];
    cell.patientAge.text = [NSString stringWithFormat:@"%i Years Old",(doesDOBExist)?date.getNumberOfYearsElapseFromDate:0];
    cell.patientDOB.text = (doesDOBExist)?[[patientDic objectForKey:DOB]convertNSDateFullBirthdayString]:@"Not Available";
    
    return cell;
}

// Action upon selecting cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Sets color of cell when selected
    [ColorMe ColorTint:[[tableView cellForRowAtIndexPath:indexPath]layer] forCustomColor:[UIColor lightGrayColor]];
    
    [UIView animateWithDuration:.3 animations:^{
        [ColorMe ColorTint:[[tableView cellForRowAtIndexPath:indexPath]layer] forCustomColor:[UIColor clearColor]];
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Push to doctor & pharmacy view controllers
    NSMutableDictionary * pDic = [[NSMutableDictionary alloc]initWithDictionary:[queueArray objectAtIndex:indexPath.row]];
    
    // Lock patients / visit
    [mobileFacade updateVisitRecord:pDic andShouldUnlock:NO andShouldCloseVisit:NO onCompletion:^(NSDictionary *object, NSError *error) {
        if(!object){
            [FIUAppDelegate getNotificationWithColor:AJNotificationTypeRed Animation:AJLinedBackgroundTypeDisabled WithMessage:error.localizedDescription inView:self.view];
        }else{
            if([[self stationChosen]intValue] == 2) {
                DoctorPatientViewController * newView = [self getViewControllerFromiPadStoryboardWithName:@"doctorPatientViewController"];
                [newView setPatientData:pDic];
                [self.navigationController pushViewController:newView animated:YES];
            }
            else if ([[self stationChosen]intValue] == 3) {
                PharmacyPatientViewController * newView = [self getViewControllerFromiPadStoryboardWithName:@"pharmacyPatientViewController"];
                [newView setPatientData:pDic];
                [self.navigationController pushViewController:newView animated:YES];
            }
        }
    }];
}

//// Coloring cell depending on priority
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if([[self stationChosen] intValue] == 2) {
//        NSDictionary * visitDic = [[NSDictionary alloc]initWithDictionary:[queueArray objectAtIndex:indexPath.row]];
//    
//        // Set priority color
//        if([[visitDic objectForKey:PRIORITY]intValue] == 0)
//            cell.backgroundColor = [UIColor yellowColor];
//        else if([[visitDic objectForKey:PRIORITY]intValue] == 1)
//            cell.backgroundColor = [UIColor purpleColor];
//        else if([[visitDic objectForKey:PRIORITY]intValue] == 2)
//            cell.backgroundColor = [UIColor redColor];
//    }
//}

- (void)reloadTableView{
}

@end
