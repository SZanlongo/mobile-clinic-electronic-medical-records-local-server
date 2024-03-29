//
//  DatabaseProtocol.h
//  Mobile Clinic
//
//  Created by Michael Montaque on 3/12/13.
//  Copyright (c) 2013 Steven Berlanga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol DatabaseProtocol <NSObject>

@required
/**
 * @brief Singleton for Database Class
 */
+ (id)sharedInstance;
- (BOOL)shutdownDatabase;
- (NSManagedObjectContext *)managedObjectContext;
- (void)saveContext;
@end
