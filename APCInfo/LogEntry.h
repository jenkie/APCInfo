//
//  LogEntry.h
//  APCInfo
//
//  Created by Ben on 07.05.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;

@interface LogEntry : NSManagedObject

@property (nonatomic, retain) NSNumber * cadence;
@property (nonatomic, retain) NSString * controlMode;
@property (nonatomic, retain) NSNumber * current;
@property (nonatomic, retain) NSNumber * km;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * mah;
@property (nonatomic, retain) NSNumber * poti;
@property (nonatomic, retain) NSNumber * power;
@property (nonatomic, retain) NSNumber * powerHuman;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSNumber * speedGps;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * voltage;
@property (nonatomic, retain) NSNumber * wh;
@property (nonatomic, retain) NSNumber * whHuman;
@property (nonatomic, retain) Session *session;

@end
