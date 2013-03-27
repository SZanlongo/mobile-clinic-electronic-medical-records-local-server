//
//  BaseObject+Protected.m
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/26/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//

#import "BaseObject+Protected.h"

@implementation BaseObject (Protected)

-(void)makeCloudCallWithCommand:(NSString *)command withObject:(id)object onComplete:(CloudCallback)onComplete{
    
    [[CloudService cloud] query:command parameters:object  completion:^(NSError *error, NSDictionary *result) {
        //TODO: Create progress bar
        onComplete(result,error);
        NSLog(@"BASEOBJECT LOG: %@",result);
    }];
    
}
@end
