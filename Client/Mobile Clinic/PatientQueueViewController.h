//
//  PatientQueueViewController.h
//  Mobile Clinic
//
//  Created by Rigo Hernandez on 3/10/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobileClinicFacade.h"

@interface PatientQueueViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *queueTableView;

@end

@interface QueueTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *patientName;
@property (weak, nonatomic) IBOutlet UILabel *patientDOB;
@property (weak, nonatomic) IBOutlet UILabel *patientAge;
@property (weak, nonatomic) IBOutlet UIImageView *patientPhoto;

@end
