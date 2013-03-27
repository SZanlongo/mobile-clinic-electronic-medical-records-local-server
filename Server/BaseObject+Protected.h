//
//  BaseObject+Protected.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/26/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "BaseObject.h"
#import "StatusObject.h"
#import "CloudService.h"
@interface BaseObject (Protected)

-(void)makeCloudCallWithCommand:(NSString *)command withObject:(id)object onComplete:(CloudCallback)onComplete;
@end
