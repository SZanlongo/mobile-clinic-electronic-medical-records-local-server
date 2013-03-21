//
//  LoginViewController.m
//  Mobile Clinic
//
//  Created by sebastian a zanlongo on 2/18/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//
#define TESTING @"Test"
#import "LoginViewController.h"
#import "MedicationObject.h"
#import "PatientObject.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize usernameTextField,passwordTextField,user;

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
    // Leave this while Device is in Testing mode
    NSUserDefaults* uDefault = [NSUserDefaults standardUserDefaults];
    
    if (![uDefault boolForKey:TESTING]) {
        [self createTestMedications:nil];
        [self setupTestPatients:nil];
        [self setupUser:nil];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:TESTING];
    }
   
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender {
    
    // if user doesn't exist, instantiate the user
    if (!user)
        user = [[UserObject alloc]init];
    
    // Attempt to login the user based on username and password
    [user loginWithUsername:usernameTextField.text andPassword:passwordTextField.text onCompletion:^(id<BaseObjectProtocol> data, NSError *error) {
        if (error) {
            
            [FIUAppDelegate getNotificationWithColor:AJNotificationTypeRed Animation:AJLinedBackgroundTypeAnimated WithMessage:error.localizedDescription inView:self.view];
        }else{
            // Listens for the logout button
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogOffDevice) name:LOGOFF object:nil];
            [self navigateToMainScreen];
            [[NSUserDefaults standardUserDefaults]setObject:usernameTextField.text forKey:CURRENT_USER];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }];
    
}
-(void)LogOffDevice{
    [self dismissViewControllerAnimated:YES completion:^{
        // Stops listening
        [passwordTextField setText:@""];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:CURRENT_USER];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }];
}
-(void)navigateToMainScreen{
    
    id screen = [self getViewControllerFromiPadStoryboardWithName:@"userSelectScreen"];
    [self presentViewController:screen animated:YES completion:nil];
}
- (void)viewDidUnload {
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
}
- (IBAction)move:(id)sender {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogOffDevice) name:LOGOFF object:nil];
    [self navigateToMainScreen];
}

- (IBAction)setupTestPatients:(id)sender {
    // - DO NOT COMMENT: IF YOUR RESTART YOUR SERVER IT WILL PLACE DEMO PATIENTS INSIDE TO HELP ACCELERATE YOUR TESTING
    // - YOU CAN SEE WHAT PATIENTS ARE ADDED BY CHECKING THE PatientFile.json file
    NSError* err = nil;
    
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"PatientFile" ofType:@"json"];
    
    NSArray* patients = [NSArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]options:0 error:&err]];
    
    NSLog(@"Imported Patients: %@", patients);
    
    [patients enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj];
        PatientObject *base = [[PatientObject alloc]init];
        
        NSDateFormatter *format =[[NSDateFormatter alloc]init];
        
        [format setDateFormat:@"yyyy-MMMM-dd"];
        
        [dic setValue:[format dateFromString:[dic valueForKey:@"age"]] forKey:DOB];
        
        [base setValueToDictionaryValues:dic];
        
        [base saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            
        }];
        
    }];
}

- (IBAction)setupUser:(id)sender {
    NSError* err = nil;
    
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"User" ofType:@"json"];
    
    NSArray* user = [NSArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]options:0 error:&err]];
    
    NSLog(@"Imported User: %@", user);
    
    [user enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj];
       
        UserObject *base = [[UserObject alloc]init];
        
        [base setValueToDictionaryValues:dic];
        
        [base saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
            
        }];
    }];
}

- (IBAction)createTestMedications:(id)sender {
    NSError* err = nil;
    
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"MedicationFile" ofType:@"json"];
    
    NSArray* Meds = [NSArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]options:0 error:&err]];
    
    NSLog(@"Imported Medications: %@", Meds.description);
    
    [Meds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MedicationObject* base = [[MedicationObject alloc]init];
        
        [base setValueToDictionaryValues:obj];
        
        [base saveObject:^(id<BaseObjectProtocol> data, NSError *error) {
        }];
    }];
    
}
@end
