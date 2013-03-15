//
//  StatusObjectProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/15/13.
//  Copyright (c) 2013 Florida International University. All rights reserved.
//
#define DATA      @"data to transfer"
#define STATUS     @"status"

#import <Foundation/Foundation.h>
#import "BaseObjectProtocol.h"
typedef enum {
    kSuccess    = 0,
    kError      = 1,
} ServerStatus;

@protocol StatusObjectProtocol <NSObject>

@end
