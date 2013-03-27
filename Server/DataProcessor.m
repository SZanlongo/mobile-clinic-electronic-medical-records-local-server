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
+(NSDate *)convertSecondsToNSDate:(NSNumber *)time{
   
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setYear:2013];
    [components setMonth:1];
    [components setDay:1];
    NSDate* date = [calendar dateFromComponents:components];
    return [NSDate dateWithTimeIntervalSinceReferenceDate:time.integerValue];
}
-(NSNumber *)convertNSDateToSeconds{
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    
//    [components setYear:2013];
//    [components setMonth:1];
//    [components setDay:1];
   // NSDate* date = [calendar dateFromComponents:components];
    return [NSNumber numberWithInteger:[self timeIntervalSinceReferenceDate]];
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
