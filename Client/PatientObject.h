////  PatientObject.h//  Mobile Clinic////  Created by Steven Berlanga on 2/4/13.//  Copyright (c) 2013 Steven Berlanga. All rights reserved.///** PatientObject class has a few bugs but is otherwise operational. This class is the main class that the user will interact with.  */#import "BaseObject.h"#import "PatientObjectProtocol.h"@interface PatientObject : BaseObject <PatientObjectProtocol>{        NSMutableArray* visits;}+(NSString*)DatabaseName;@end