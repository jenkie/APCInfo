//
//  Session.h
//  APCInfo
//
//  Created by Ben on 19.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LogEntry;

@interface Session : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *logEntry;
@end

@interface Session (CoreDataGeneratedAccessors)

- (void)addLogEntryObject:(LogEntry *)value;
- (void)removeLogEntryObject:(LogEntry *)value;
- (void)addLogEntry:(NSSet *)values;
- (void)removeLogEntry:(NSSet *)values;

@end
