//
//  DataProcessor.m
//  OmniOrganize
//
//  Created by Michael Montaque on 9/26/11.
//  Copyright (c) 2011 Florida International University. All rights reserved.
//

#import "DataProcessor.h"

@implementation NSDate (DataProcessor)

-(NSString*)convertNSDateToString{
    NSDateFormatter *format =[[NSDateFormatter alloc]init];
    
    [format setDateFormat:@"MMM dd, h:mm aa"];
    
    return [format stringFromDate:self];

}

+(NSDate*)convertStringToNSDate:(NSString*)string{
    
    NSDateFormatter *format =[[NSDateFormatter alloc]init];
    
    [format setDateFormat:@"MMM dd, h:mm aa"];
    
    return [format dateFromString:string];
    
}

-(NSString*)convertNSDateFullBirthdayString{
    
    NSDateFormatter *format =[[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMMM dd, yyyy"];
    return [format stringFromDate:self];
}

-(NSString*)convertNSDateToTimeString{
    
    NSDateFormatter *format =[[NSDateFormatter alloc]init];
    [format setDateFormat:@"h:mm aa"];
    return [format stringFromDate:self];
}
-(NSString*)convertNSDateToMonthDayYearTimeString{
    
    NSDateFormatter *format =[[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMMM dd, yyyy h:mm aa"];
    return [format stringFromDate:self];
}
-(NSInteger)getNumberOfYearsElapseFromDate{
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:self
                                       toDate:now
                                       options:0];
   return [ageComponents year];
}

-(NSString*)convertNSDateToMonthNumDayString{
    
    NSDateFormatter *format =[[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMM dd"];
    return [format stringFromDate:self];
}

@end
