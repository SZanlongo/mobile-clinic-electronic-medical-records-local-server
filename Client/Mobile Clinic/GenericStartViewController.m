//
//  GenericStartViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 3/6/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import "GenericStartViewController.h"
#import "TriagePatientViewController.h"
#import "DoctorPatientViewController.h"
#import "PharmacyPatientViewController.h"

@interface GenericStartViewController ()

@end

@implementation GenericStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Rotate table horizontally (-90 degrees)
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);
    _tableView.rowHeight = 768;
    _tableView.transform = transform;
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.frame = self.view.frame;
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    
    _searchControl = [self getViewControllerFromiPadStoryboardWithName:@"searchPatientViewController"];
    
    //set up according to station chosen
    switch ([[self stationChosen] intValue]) {
        case 1:
            [bar setTintColor:[UIColor orangeColor]];
            _registerControl = [self getViewControllerFromiPadStoryboardWithName:@"registerPatientViewController"];
            break;
        case 2:
            [bar setTintColor:[UIColor blueColor]];
            _registerControl = [self getViewControllerFromiPadStoryboardWithName:@"registerPatientViewController"];
            break;
        case 3:
            [bar setTintColor:[UIColor greenColor]];
            _registerControl = [self getViewControllerFromiPadStoryboardWithName:@"registerPatientViewController"];
            break;
        default:
            break;
    }
}

//define number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//define number of cells in table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

//defines the cells in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * registerCellIdentifier = @"registerCell";
    static NSString * searchCellIdentifier = @"searchCell";
        static NSString * queueCellIdentifier = @"queueCell";
    
    if(indexPath.item == 0 && [[self stationChosen] intValue] == 1) {
        RegisterPatientTableCell * cell = [tableView dequeueReusableCellWithIdentifier:registerCellIdentifier];
        if(!cell) {
            cell = [[RegisterPatientTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:registerCellIdentifier];
            cell.viewController = _registerControl;
        }
        
        return [self setupCell:cell forRow:indexPath];
        
    } else if (indexPath.item == 0) {
        //patient queue cell
        
        PatientQueueTableCell * cell = [tableView dequeueReusableCellWithIdentifier:queueCellIdentifier];
        if(!cell) {
            cell = [[PatientQueueTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:queueCellIdentifier];
            cell.viewController = _queueControl;
        }
        
        return [self setupCell:cell forRow:indexPath];
    } else {
        SearchPatientTableCell * cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
        
        if(!cell) {
            cell = [[SearchPatientTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellIdentifier];
            cell.viewController = _searchControl;
        }
        
        return [self setupCell:cell forRow:indexPath];
    }
}

-(UITableViewCell*)setupCell:(id)cell forRow:(NSIndexPath*)path{
    // Rotate view vertically on the screen
    CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
    [cell viewController].view.transform = transform;
    [cell viewController].view.frame = CGRectMake(50, 0, 916, 768);
    
    // Removes previous view (for memory mgmt)
    for(UIView *mView in [[cell contentView] subviews]){
        [mView removeFromSuperview];
    }
    
    // Populate view in cell
    [cell addSubview: [cell viewController].view];
    
    [[cell viewController] setScreenHandler:^(id object, NSError *error) {
        _patientData = [NSMutableDictionary dictionaryWithDictionary:object];
        id newView;
        switch ([[self stationChosen] intValue]) {
            case 1:
                newView = [self getViewControllerFromiPadStoryboardWithName:@"triagePatientViewController"];
                break;
            case 2:
                newView = [self getViewControllerFromiPadStoryboardWithName:@"doctorPatientViewController"];
                break;
            case 3:
                newView = [self getViewControllerFromiPadStoryboardWithName:@"pharmacyPatientViewController"];
                break;
            default:
                break;
        }
        
        [newView setPatientData:_patientData];
        
        [newView setScreenHandler:^(id object, NSError *error) {
            [self.navigationController popViewControllerAnimated:YES];
            if (error) {
                [FIUAppDelegate getNotificationWithColor:AJNotificationTypeRed Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription inView:self.view
                 ];
            }
            [[cell viewController]resetData];
        }];
        
        [self.navigationController pushViewController:newView animated:YES];
    }];
    
    return cell;
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
    else
    {
        *targetContentOffset = CGPointMake(targetContentOffset->x,
                                           targetContentOffset->y - (((int)targetContentOffset->y) % (cellHeight)));
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setToolbar:nil];
    [self setSegmentedControl:nil];
    [super viewDidUnload];
}

@end
