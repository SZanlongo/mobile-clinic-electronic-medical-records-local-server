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

@property CGPoint originalCenter;

@end

@implementation DoctorPatientViewController

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
    [bar setTintColor:[UIColor blueColor]];
    
    // Rotate table horizontally (90 degrees)
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);
    _tableView.rowHeight = 768;
    _tableView.transform = transform;
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // Create controllers for each view
    
    _control1 = [self getViewControllerFromiPadStoryboardWithName:@"currentDiagnosisViewController"];
    _control2 = [self getViewControllerFromiPadStoryboardWithName:@"previousVisitsViewController"];
    
    // _visitationData = [[VisitationObject alloc] initWithNewVisit];
    
    _patientNameField.text = [_patientData objectForKey:FIRSTNAME];
    _familyNameField.text = [_patientData objectForKey:FAMILYNAME];
    _villageNameField.text = [_patientData objectForKey:VILLAGE];
    _patientAgeField.text = [NSString stringWithFormat:@"%i",[[_patientData objectForKey:DOB]getNumberOfYearsElapseFromDate]];
    _patientSexField.text = ([_patientData objectForKey:SEX]==0)?@"Female":@"Male";
    id data = [_patientData objectForKey:PICTURE];
    [_patientPhoto setImage:[UIImage imageWithData:([data isKindOfClass:[NSData class]])?data:nil]];
    [_control1 view];
    [_control1 setPatientData:_patientData];
    [_control2 view];
    [_control2 setPatientData:_patientData];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveVisitation) name:SAVE_VISITATION object:_patientData];
//    [_control1.submitButton addTarget:self action:@selector(saveVisitation) forControlEvents:UIControlEventTouchUpInside];
    self.originalCenter = self.view.center;
 //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardDidShow: (NSNotification *) notif {
    self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - 264 - 44);
}

- (void)keyboardDidHide: (NSNotification *) notif {
    self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - 44);
}

-(void)saveVisitation{
   // [_patientData addVisitToCurrentPatient:_control1.visitationData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPatientNameField:nil];
    [self setFamilyNameField:nil];
    [self setVillageNameField:nil];
    [self setPatientAgeField:nil];
    [self setPatientSexField:nil];
    [self setPatientPhoto:nil];
    [self setPatientWeightLabel:nil];
    [self setPatientBPLabel:nil];
    [self setTableView:nil];
    [self setToolBar:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        cell.viewController.view.frame = CGRectMake(0, 0, 768, 700);
        
        for(UIView *mView in [cell.contentView subviews]){
            [mView removeFromSuperview];
        }
        
        [cell addSubview:cell.viewController.view];
        [cell.viewController setScreenHandler:handler];
        
        [_segmentedControl setEnabled:YES forSegmentAtIndex:0];
        
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
        cell.viewController.view.frame = CGRectMake(0, 0, 768, 700);
        
        for(UIView *mView in [cell.contentView subviews]){
            [mView removeFromSuperview];
        }
        
        [cell addSubview: cell.viewController.view];
        
        [_segmentedControl setEnabled:YES forSegmentAtIndex:1];
        
        return cell;
    }
    
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//}

- (void)setScreenHandler:(ScreenHandler)myHandler{
    handler = myHandler;
}

- (IBAction)segmentClicked:(id)sender {
    switch (_segmentedControl.selectedSegmentIndex) {
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
