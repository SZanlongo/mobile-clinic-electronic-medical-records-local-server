//
//  BaseObject.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 1/27/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DatabaseDriver.h"
#import "BaseObjectProtocol.h"
#import "DataProcessor.h"
#import "NSString+StringExt.h"
#import "NSObject+CustomTools.h"

@interface BaseObject : DatabaseDriver <BaseObjectProtocol>

+(NSString*)getCurrenUserName;
@end
