//
//  DoctorPatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "DoctorPatientViewController.h"
#import "DoctorViewController.h"

@interface DoctorPatientViewController ()

@end

@implementation DoctorPatientViewController

@synthesize segmentedControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UINavigationBar *bar =[self.navigationController navigationBar];
    [bar setTintColor:[UIColor orangeColor]];
    
    // Rotate table horizontally (90 degrees)
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);
    _tableView.rowHeight = 768;
    _tableView.transform = transform;
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // Create controllers for each view
    
    _control1 = [self getViewControllerFromiPadStoryboardWithName:@"currentDiagnosisViewController"];
    
    [_control1 view];
    _control2 = [self getViewControllerFromiPadStoryboardWithName:@"previousVisitsViewController"];
    [_control2 view];
    
    _visitationData = [[VisitationObject alloc] initWithNewVisit];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveVisitation) name:SAVE_VISITATION object:_patientData];
    
    [_control1.submitButton addTarget:self action:@selector(saveVisitation) forControlEvents:UIControlEventTouchUpInside];
    
    _patientNameLabel.text = _patientData.patient.firstName;
    _patientFamilyNameLabel.text = _patientData.patient.familyName;
    _patientAgeLabel.titleLabel.text = [NSString stringWithFormat:@"%i", _patientData.getAge ];
    _patientSexLabel.text =  [_patientData.patient.sex isEqualToNumber:[NSNumber numberWithInt:0]] ? @"Male" : @"Female";
//
}

-(void)saveVisitation{
    [_patientData addVisitToCurrentPatient:_control1.visitationData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setToolBar:nil];
    [self setPatientNameLabel:nil];
    [self setPatientFamilyNameLabel:nil];
    [self setPatientVillageLabel:nil];
    [self setPatientAgeLabel:nil];
    [self setPatientSexLabel:nil];
    [self setPatientSexLabel:nil];
    [self setPatientWeightLabel:nil];
    [self setPatientBPLabel:nil];
    [super viewDidUnload];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * currentDiagnosisCellIdentifier = @"currentDiagnosisCell";
    static NSString * previousVisitsCellIdentifier = @"previousVisitsCell";
    
    if(indexPath.item == 0) {
        CurrentDiagnosisTableCell * cell = [tableView dequeueReusableCellWithIdentifier:currentDiagnosisCellIdentifier];
        
        if (!cell) {
            cell = [[CurrentDiagnosisTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:currentDiagnosisCellIdentifier];
            
            cell.viewController = _control1;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(0, 0, 768, 685);
        
        for(UIView *mView in [cell.contentView subviews]){
            [mView removeFromSuperview];
        }
        
        [cell addSubview:cell.viewController.view];
        
        
        
        [cell.viewController setScreenHandler:handler];
        
        return cell;
    }
    else {
        PreviousVisitsTableCell * cell = [tableView dequeueReusableCellWithIdentifier:previousVisitsCellIdentifier];
        
        if(!cell){
            cell = [[PreviousVisitsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:previousVisitsCellIdentifier];
            
            cell.viewController = _control2;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(0, 0, 768, 685);
        
        for(UIView *mView in [cell.contentView subviews]){
            [mView removeFromSuperview];
        }
        
        [cell addSubview: cell.viewController.view];
        
        return cell;
    }
    
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//}

-(void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
}

- (IBAction) segmentedControlIndexChanged {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        case 1:
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        default:
            break;
            
    }
    [self.tableView reloadData];
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    int cellHeight = 768;
    
    if(((int)targetContentOffset->y) % (cellHeight) > cellHeight/2){
        *targetContentOffset = CGPointMake(targetContentOffset->x,
                                           targetContentOffset->y + (cellHeight - (((int)targetContentOffset->y) % (cellHeight))));
        self.segmentedControl.selectedSegmentIndex = 1;
    }
    else{
        *targetContentOffset = CGPointMake(targetContentOffset->x,
                                           targetContentOffset->y - (((int)targetContentOffset->y) % (cellHeight)));
        self.segmentedControl.selectedSegmentIndex = 0;
    }
}

@end
