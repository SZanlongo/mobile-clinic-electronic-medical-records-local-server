//
//  PatientObject.m
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/11/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define ISOPEN  @"isOpen"

#import "PatientObject.h"
#import "NSDataAdditions.h"
#import "BaseObject+Protected.h"
#import "Patients.h"
#import "FIUAppDelegate.h"

NSString* firstname;
NSString* lastname;
NSString* isLockedBy;

@implementation PatientObject
+(NSString *)DatabaseName{
    return DATABASE;
}
- (id)init
{
    [self setupObject];
    return [super init];
}
-(id)initAndMakeNewDatabaseObject
{
    [self setupObject];
    return [super initAndMakeNewDatabaseObject];
}
- (id)initAndFillWithNewObject:(NSDictionary *)info
{
    [self setupObject];
    return [super initAndFillWithNewObject:info];
}
-(id)initWithCachedObjectWithUpdatedObject:(NSDictionary *)dic
{
    [self setupObject];
    return [super initWithCachedObjectWithUpdatedObject:dic];
}

-(void)setupObject{
    
    self->COMMONID =  PATIENTID;
    self->CLASSTYPE = kPatientType;
    self->COMMONDATABASE = DATABASE;
}
#pragma mark - BaseObjectProtocol Methods
#pragma mark -

/* The super needs to be called first */
-(NSDictionary *)consolidateForTransmitting{
    
    NSMutableDictionary* consolidate = [[NSMutableDictionary alloc]initWithDictionary:[super consolidateForTransmitting]];

    [consolidate setValue:[NSNumber numberWithInt:kPatientType] forKey:OBJECTTYPE];
    return consolidate;
}

-(void)ServerCommand:(NSDictionary *)dataToBeRecieved withOnComplete:(ServerCommand)response{
    [super ServerCommand:nil withOnComplete:response];
    [self unpackageFileForUser:dataToBeRecieved];
    [self CommonExecution];
}

-(void)unpackageFileForUser:(NSDictionary *)data{
    [super unpackageFileForUser:data];
    firstname = [self->databaseObject valueForKey:FIRSTNAME];
    lastname = [self->databaseObject valueForKey:FAMILYNAME];
}

/* Depending on the RemoteCommands it will execute a different Command */
-(void)CommonExecution
{
    switch (self->commands) {
        case kAbort:
            break;
        case kUpdateObject:
            [super UpdateObjectAndSendToClient];
            break;
        case kFindObject:
            [self sendSearchResults:[self FindAllObjectsForGivenCriteria]];
            break;
        case kFindOpenObjects:
            [self sendSearchResults:[self OptimizedFindAllObjects]];
        
        default:
            break;
    }
}
-(NSArray*)getObjectsUsingCustomPredicate:(NSString*)predicate{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:predicate];
   
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:FIRSTNAME]];
}

#pragma mark - COMMON OBJECT Methods
#pragma mark -
-(NSArray*)OptimizedFindAllObjects{
    
    FIUAppDelegate* app = (FIUAppDelegate*)[[NSApplication sharedApplication]delegate];
    
    switch ([app isOptimized]) {
        case kFirstSync:
            return [self FindAllObjects];
        case kFastSync:
            return  [self FindAllOpenPatients];
        case kStabilize:
        case kFinalize:
            return [self FindAllDirtyPatients];
    }
}
-(NSArray*)FindAllDirtyPatients{
    //TODO: Add BETWEEN Comparison
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:[NSPredicate predicateWithFormat:@"%K == YES",ISDIRTY] andSortByAttribute:FIRSTNAME]];
}
-(NSArray*)FindAllOpenPatients{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == YES",ISOPEN];
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:FIRSTNAME]];
}

-(NSArray *)FindAllObjects{
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:nil andSortByAttribute:FIRSTNAME]]; 
}

-(NSArray*)FindAllObjectsUnderParentID:(NSString*)parentID{
    return [self FindAllObjects];
}

-(NSAttributedString *)printFormattedObject:(NSDictionary *)object{
    
    NSString* titleString = [NSString stringWithFormat:@"Patient Records\n"];
    
    NSMutableAttributedString* title = [[NSMutableAttributedString alloc]initWithString:titleString];
    
    [title addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Gill Sans" size:22.0] range:[titleString rangeOfString:titleString]];
    
   // [title setAlignment:NSCenterTextAlignment range:[titleString rangeOfString:titleString]];
    
    NSMutableAttributedString* container = [[NSMutableAttributedString alloc]initWithAttributedString:title];

    
     NSString* main = [NSString stringWithFormat:@" Patient Name:\t%@ %@ \n Village:\t%@ \n Date of Birth:\t%@ \n Age:\t%li \n Sex:\t%@ \n",[object objectForKey:FIRSTNAME],[object objectForKey:FAMILYNAME],[object objectForKey:VILLAGE],[[NSDate convertSecondsToNSDate:[object objectForKey:DOB]]convertNSDateFullBirthdayString],[[NSDate convertSecondsToNSDate:[object objectForKey:DOB]]getNumberOfYearsElapseFromDate],([[object objectForKey:SEX]integerValue]==0)?@"Female":@"Male"];
    

    
    NSMutableAttributedString* line1 = [[NSMutableAttributedString alloc]initWithString:main];
    
    [line1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"HelveticaNeue" size:16.0] range:[main rangeOfString:main]];
    
    [container appendAttributedString:line1];
    
    return container;
}
-(NSString*)convertDateNumberForPrinting:(NSNumber*)number{
    if (number) {
        return [[NSDate convertSecondsToNSDate:number]convertNSDateToMonthDayYearTimeString];
    }
    return @"N/A";
}
-(NSString*)convertTextForPrinting:(NSString*)text{
    return ([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)?text:@"Incomplete";
}
#pragma mark - Private Methods
#pragma mark -

-(NSArray *)FindAllObjectsForGivenCriteria{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K beginswith[cd] %@ || %K beginswith[cd] %@",FIRSTNAME,firstname,FAMILYNAME,lastname];
    
    if (!firstname && !lastname) {
        pred = nil;
    }
    
    return [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:DATABASE withCustomPredicate:pred andSortByAttribute:FIRSTNAME]];
}

-(void)UnlockPatient:(ObjectResponse)onComplete{
    // Unlock patient
    [self->databaseObject setValue:@"" forKey:ISLOCKEDBY];
    // save changes
    [self saveObject:onComplete];
}

-(void)pullFromCloud:(CloudCallback)onComplete{
    
    [self makeCloudCallWithCommand:DATABASE withObject:nil onComplete:^(id cloudResults, NSError *error) {

            NSArray* allPatients = [cloudResults objectForKey:@"data"];
           
            [self handleCloudCallback:onComplete UsingData:allPatients WithPotentialError:error];
 
    }];
}

-(void)pushToCloud:(CloudCallback)onComplete{
    
//    NSArray* allPatients= [self convertListOfManagedObjectsToListOfDictionaries:[self FindObjectInTable:COMMONDATABASE withCustomPredicate:[NSPredicate predicateWithFormat:@"%K == YES",ISDIRTY] andSortByAttribute:FIRSTNAME]];
    
    NSArray* allPatients= [self FindAllObjects];
    
    // Remove Values that will break during serialization
    for (NSMutableDictionary* object in allPatients) {
        NSString* pId = [object objectForKey:PATIENTID];
        pId = [pId stringByReplacingOccurrencesOfString:@"." withString:@""];
        [object setValue:pId forKey:PATIENTID];
        // Remove Pictures (NSData)
        [object setValue:nil forKey:PICTURE];
        // Remove FingerPrint (NSData)
        [object setValue:nil forKey:FINGERDATA];
        
        id dob = [object objectForKey: DOB];
        
        if(!dob){
            [object setValue:[NSNumber numberWithInteger:0] forKey:DOB];
        }
    }
    
    [self makeCloudCallWithCommand:UPDATEPATIENT withObject:[NSDictionary dictionaryWithObject:allPatients forKey:DATABASE] onComplete:^(id cloudResults, NSError *error) {
        
        [self handleCloudCallback:onComplete UsingData:allPatients WithPotentialError:error];
    }];
}

-(NSArray *)covertAllSavedObjectsToJSON{
    
    NSArray* allPatients= [self FindObjectInTable:COMMONDATABASE withCustomPredicate:[NSPredicate predicateWithFormat:@"%K == YES",ISDIRTY] andSortByAttribute:FIRSTNAME];
   
    NSMutableArray* allObject = [[NSMutableArray alloc]initWithCapacity:allPatients.count];
    
    for (NSManagedObject* obj in allPatients) {
       
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:[obj dictionaryWithValuesForKeys:[obj attributeKeys]]];
        
        NSData* picture = [dictionary objectForKey:PICTURE];
        
        if ([picture isKindOfClass:[NSData class]]) {
            // Convert the picture to string
            NSString* picString = [picture base64Encoding];
            [dictionary setValue:picString forKey:PICTURE];
        }
       
        id fingerData = [dictionary objectForKey:FINGERDATA];
        
        if ([fingerData isKindOfClass:[NSData class]] ) {
            //convert finger data to string
            [dictionary setValue:[fingerData base64Encoding] forKey:FINGERDATA];
        }
        
        
        [allObject addObject:dictionary];
    }

    return  allObject;
}

@end
