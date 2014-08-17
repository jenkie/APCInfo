//
//  DataControl.h
//  APCInfo
//
//  Created by Ben on 17.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "LogEntry.h"
#import "Session.h"
#import <CoreLocation/CoreLocation.h>

@interface DataControl : NSObject {
    NSManagedObjectContext *context;
    Session *s;
    int storeInterval;
    int storeIntervalSetting;
    CLLocation *location;
    Boolean doLogging;
}

+ (id)sharedDataControl;
-(void)setStoreInterval:(int)interval;

-(NSDictionary*) calculateMinMaxAverageForAttribute:(NSString*)attribute inEntity:(NSString*)entity withPredicate:(NSPredicate*)predicate;
-(NSDictionary*) calculateStartEndDurationForAttribute:(NSString*)attribute inEntity:(NSString*)entity withPredicate:(NSPredicate*)predicate;
-(int) getCountInEntity:(NSString*)entity withPredicate:(NSPredicate*)predicate;
-(LogEntry*) getMaxLogEntryForAttribute:(NSString*)attribute withPredicate:(NSPredicate*)predicate;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end
