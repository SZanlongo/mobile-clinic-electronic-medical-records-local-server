//
//  DoctorPatientViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "DoctorPatientViewController.h"
#import "DoctorViewController.h"

@interface DoctorPatientViewController (){
    BOOL visitationHasBeenSaved;
}

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
    
    // Set navbar color
    UINavigationBar *bar =[self.navigationController navigationBar];
    [bar setTintColor:[UIColor blueColor]];
    
    // Rotate table horizontally (90 degrees)
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);
    _tableView.rowHeight = 768;
    _tableView.transform = transform;
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // Extract patient name/village/etc from visit dictionary
    NSDictionary * patientDic = [_patientData objectForKey:OPEN_VISITS_PATIENT];
    
    // Populate patient info
    id data = [_patientData objectForKey:PICTURE];      
    [_patientPhoto setImage:[UIImage imageWithData:([data isKindOfClass:[NSData class]])?data:nil]];
    
    _patientNameField.text = [patientDic objectForKey:FIRSTNAME];
    _familyNameField.text = [patientDic objectForKey:FAMILYNAME];
    _villageNameField.text = [patientDic objectForKey:VILLAGE];
    _patientAgeField.text = [NSString stringWithFormat:@"%i",[[patientDic objectForKey:DOB]getNumberOfYearsElapseFromDate]];
    _patientSexField.text = ([patientDic objectForKey:SEX]==0)?@"Female":@"Male";
    
    // Populate patient's vitals from triage
    _patientWeightLabel.text = [NSString stringWithFormat:@"%.02f",[[_patientData objectForKey:WEIGHT]doubleValue]];
    _patientBPLabel.text = [_patientData objectForKey:BLOODPRESSURE];
//    _patientHRLabel.text = [_patientData objectForKey:HEARTRATE];
//    _patientRespirationLabel.text = [_patientData objectForKey:RESPIRATION];
//    _patientTempLabel.text = [_patientData objectForKey:TEMPERATURE];
    
    // Create controllers for each view
    [self setControllers];
    [self instantiateViews];
    
    // Pass patient visit dictionary to dependant views
    [_diagnosisViewController setPatientData:_patientData];
    [_previousVisitViewController setPatientData:_patientData];
    
    // Diagnosis notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveVisitation:) name:SAVE_VISITATION object:_patientData];
    
    // Prescription notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideToSearchMedicine) name:MOVE_TO_SEARCH_FOR_MEDICINE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideFromSearchMedicine:) name:MOVE_FROM_SEARCH_FOR_MEDICINE object:_prescriptionData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savePrescription:) name:SAVE_PRESCRIPTION object:_prescriptionData];

    visitationHasBeenSaved = NO;
    
    
}

// Set controllers used in tableview
- (void)setControllers {
    _diagnosisViewController = [self getViewControllerFromiPadStoryboardWithName:@"currentDiagnosisViewController"];
    _previousVisitViewController = [self getViewControllerFromiPadStoryboardWithName:@"previousVisitsViewController"];
    _precriptionViewController = [self getViewControllerFromiPadStoryboardWithName:@"prescriptionFormViewController"];
    _medicineViewController = [self getViewControllerFromiPadStoryboardWithName:@"searchMedicineViewController"];
}

// Instantiate views used in tableview
- (void)instantiateViews {
    [_diagnosisViewController view];
    [_previousVisitViewController view];
    [_precriptionViewController view];
    [_medicineViewController view];
}

// Save diagnosis and slide view to enter medication
- (void)saveVisitation:(NSNotification *)note {
    // TODO: RECONSIDER
    /* Because of objects can be locked, you have to handle the saving process on the screen that is responsible for saving this object. That way if something wrong occured the user will not have to redo what they did.
     */
    _patientData = note.object;
    
    MobileClinicFacade *mobileFacade = [[MobileClinicFacade alloc]init];
    [mobileFacade updateVisitRecord:_patientData andShouldUnlock:NO andShouldCloseVisit:NO onCompletion:^(NSDictionary *object, NSError *error) {
        if(!object)
            [FIUAppDelegate getNotificationWithColor:AJNotificationTypeOrange Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription inView:self.view];
        else{
            visitationHasBeenSaved = YES;
            // MAY HAVE TO REINSTANTIATE _patientData WITH object (CHECK W/ MIKE)
            [_tableView setScrollEnabled:NO];
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }];
}

- (void)slideToSearchMedicine {
    self.medicineViewController.prescriptionData = self.prescriptionData;
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)slideFromSearchMedicine:(NSNotification *)note {
    _prescriptionData = note.object;
    
    [_precriptionViewController setPrescriptionData:_prescriptionData];
    _precriptionViewController.drugTextField.text = _medicineViewController.medicineField.text;
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)savePrescription:(NSNotification *)note {
    /* Because of objects can be locked, you have to handle the saving process on the screen that is responsible for saving this object. That way if something wrong occured the user will not have to redo what they did. 
     */
    [self.navigationController popViewControllerAnimated:YES];
    
    /*
    _prescriptionData = note.object;

    [_prescriptionData setObject:[_visitationData objectForKey:VISITID] forKey:VISITID];    // ASK MIKE IF WE NEED THIS
    
    MobileClinicFacade* mobileFacade = [[MobileClinicFacade alloc]init];
    
    [mobileFacade addNewPrescription:_prescriptionData ForCurrentVisit:_visitationData AndlockVisit:NO onCompletion:^(NSDictionary *object, NSError *error) {                    
        if (!object)
            [FIUAppDelegate getNotificationWithColor:AJNotificationTypeOrange Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription inView:self.view];
        else
            [self.navigationController popViewControllerAnimated:YES];
    }];
    */
}

- (void)didReceiveMemoryWarning {
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
    [self setPatientHRLabel:nil];
    [self setPatientRespirationLabel:nil];
    [self setTableView:nil];
    [self setToolBar:nil];
    [self setPatientTempLabel:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * currentDiagnosisCellIdentifier = @"currentDiagnosisCell";
    static NSString * previousVisitsCellIdentifier = @"previousVisitsCell";
    static NSString * currentVisitCellIdentifier = @"prescriptionCell";
    static NSString * medicineSearchCellIdentifier = @"medicineSearchCell";
    
    if(indexPath.item == 0) {
        CurrentDiagnosisTableCell * cell = [tableView dequeueReusableCellWithIdentifier:currentDiagnosisCellIdentifier];
        
        if (!cell) {
            cell = [[CurrentDiagnosisTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:currentDiagnosisCellIdentifier];
            cell.viewController = _diagnosisViewController;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(0, 0, 744, 768);
        
        for(UIView *mView in [cell.contentView subviews]){
            [mView removeFromSuperview];
        }
        
        [cell addSubview:cell.viewController.view];
        [cell.viewController setScreenHandler:handler];
        
        [_segmentedControl setEnabled:YES forSegmentAtIndex:0];
        [_segmentedControl setHidden:NO];
        
        return cell;
    }
    else if(indexPath.item == 1){
        PreviousVisitsTableCell * cell = [tableView dequeueReusableCellWithIdentifier:previousVisitsCellIdentifier];
        
        if(!cell){
            cell = [[PreviousVisitsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:previousVisitsCellIdentifier];
            cell.viewController = _previousVisitViewController;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(0, 0, 744, 768);
        
        for(UIView *mView in [cell.contentView subviews]){
            [mView removeFromSuperview];
        }
        
        [cell addSubview: cell.viewController.view];
        
        [_segmentedControl setEnabled:YES forSegmentAtIndex:1];
        [_segmentedControl setHidden:NO];
        
        return cell;
    }
    else if(indexPath.item == 2) {
        
        
        DoctorPrescriptionCell * cell = [tableView dequeueReusableCellWithIdentifier:currentVisitCellIdentifier];
        
        if (!cell) {
            cell = [[DoctorPrescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:currentVisitCellIdentifier];
            cell.viewController = _precriptionViewController;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(0, 0, 744, 768);
        
        for(UIView *mView in [cell.contentView subviews]) {
            [mView removeFromSuperview];
        }
        
        [cell addSubview:cell.viewController.view];
        
        [_segmentedControl setHidden:YES];
        
        return cell;
    }
    else{
        MedicineSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:medicineSearchCellIdentifier];
        
        if(!cell){
            cell = [[MedicineSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:medicineSearchCellIdentifier];
            cell.viewController = _medicineViewController;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.viewController.view.transform = transform;
        cell.viewController.view.frame = CGRectMake(0, 0, 744, 768);
        
        for(UIView *mView in [cell.contentView subviews]) {
            [mView removeFromSuperview];
        }
        
        [cell addSubview: cell.viewController.view];
        
        return cell;
    }
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
              targetContentOffset:(inout CGPoint *)offset {
    int cellHeight = 768;
    
    if(!visitationHasBeenSaved && (int)offset->y >= 1 * cellHeight)
        *offset = CGPointMake(offset->x, 1*cellHeight);
    
    if(((int)offset->y) % (cellHeight) > cellHeight/2){
        *offset = CGPointMake(offset->x, offset->y + (cellHeight - (((int)offset->y) % (cellHeight))));
        self.segmentedControl.selectedSegmentIndex = 1;
    }
    else{
        *offset = CGPointMake(offset->x, offset->y - (((int)offset->y) % (cellHeight)));
        self.segmentedControl.selectedSegmentIndex = 0;
    }
}

// Hides keyboard when whitespace is pressed
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setScreenHandler:(ScreenHandler)myHandler {
    handler = myHandler;
}

@end
