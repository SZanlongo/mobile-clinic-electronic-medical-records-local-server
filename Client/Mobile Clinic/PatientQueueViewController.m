//
//  PatientQueueViewController.m
//  Mobile Clinic
//
//  Created by Rigo Hernandez on 3/10/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "PatientQueueViewController.h"

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
    mobileFacade = [[MobileClinicFacade alloc] init];
    
    [mobileFacade findAllOpenVisitsAndOnCompletion:^(NSArray *allObjectsFromSearch, NSError *error) {
        queueArray = [NSArray arrayWithArray:allObjectsFromSearch];
        [_queueTableView reloadData];
    }];
    
//    // Sort queue by priority
//    NSSortDescriptor *sortDescriptor;
//    sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"priority" ascending:NO];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    queueArray = [NSMutableArray arrayWithArray:[queueArray sortedArrayUsingDescriptors:sortDescriptors]];
//    [_queueTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setQueueTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"COUNT OF QUEUE RESULTS: %d", queueArray.count);
    return queueArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"queueCell";
    
    QueueTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        cell = [[QueueTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary * visitDic = [[NSDictionary alloc]initWithDictionary:[queueArray objectAtIndex:indexPath.row]];
    
    NSDictionary * patientDic = [visitDic objectForKey:OPEN_VISITS_PATIENT];
    
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

@end
