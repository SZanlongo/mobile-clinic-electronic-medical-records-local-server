//
//  Patient.h
//  Mobile Clinic
//
//  Created by Steven Berlanga on 2/11/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Patient : NSManagedObject

@property(nonatomic, weak)      NSString* firstName;
@property(nonatomic, weak)      NSString* lastName;
@property(nonatomic, weak)      NSString* villiage;
@property(nonatomic, weak)      NSNumber* age;
@property(nonatomic, weak)      NSNumber* weight;
@property(nonatomic, weak)      NSNumber* sex;
@property(nonatomic, assign)    BOOL      status;

@end
