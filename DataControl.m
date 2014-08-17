//
//  DataControl.m
//  APCInfo
//
//  Created by Ben on 17.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import "DataControl.h"

@implementation DataControl
@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;


+ (id)sharedDataControl {
    static NSObject *sharedGlobalObjectsTmp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGlobalObjectsTmp = [[self alloc] init];
    });
    return sharedGlobalObjectsTmp;
}

- (id)init {
    if (self = [super init]) {
            context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"receivedData"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"startLogging"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"stopLogging"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"sessionSelected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"locationUpdate"
                                               object:nil];
    return self;
}

-(void) setStoreInterval:(int)interval {
    storeIntervalSetting = interval;
};

- (void)receivedNotification:(NSNotification *) notification {
    storeInterval++;
    if ([[notification name] isEqualToString:@"receivedData"]) {
        LogEntry *e = [NSEntityDescription insertNewObjectForEntityForName:@"LogEntry" inManagedObjectContext:context];
        NSMutableDictionary *lEntryDict = [[notification userInfo] objectForKey:@"logEntry"];
        e.voltage = [lEntryDict valueForKey:@"voltage"];
        e.current = [lEntryDict valueForKey:@"current"];
        e.power = [lEntryDict valueForKey:@"power"];
        e.speed = [lEntryDict valueForKey:@"speed"];
        e.km= [lEntryDict valueForKey:@"km"];
        e.cadence = [lEntryDict valueForKey:@"cadence"];
        e.wh = [lEntryDict valueForKey:@"wh"];
        e.powerHuman = [lEntryDict valueForKey:@"humanPower"];
        e.whHuman = [lEntryDict valueForKey:@"humanWh"];
        e.poti = [lEntryDict valueForKey:@"poti"];
        e.controlMode = [lEntryDict valueForKey:@"controlMode"];
        e.mah = [lEntryDict valueForKey:@"mah"];
        e.time = [NSDate date];
        e.lat = [NSNumber numberWithFloat:location.coordinate.latitude];
        e.lon = [NSNumber numberWithFloat:location.coordinate.longitude];
        if (doLogging && s.objectID != nil && storeInterval >= storeIntervalSetting) {
            storeInterval = 0;
            [s addLogEntryObject:e];
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Cant store Log-Entry:%@", [error localizedDescription]);
            }
            else {
                NSLog(@"Stored Log to session:%@", s.name);
            }
        }
    }
    else if ([[notification name] isEqualToString:@"startLogging"]) {
        doLogging = true;
    }
    else if ([[notification name] isEqualToString:@"stopLogging"]) {
        doLogging = false;
    }
    else if ([[notification name] isEqualToString:@"sessionSelected"]) {
         s = [[notification userInfo] objectForKey:@"session"];
    }
    else if ([[notification name] isEqualToString:@"locationUpdate"]) {
        location = [[notification userInfo] objectForKey:@"location"];
    }
    
}

-(NSDictionary*) calculateMinMaxAverageForAttribute:(NSString*)attribute inEntity:(NSString*)entity withPredicate:(NSPredicate*)predicate{
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    [request setResultType:NSDictionaryResultType];
    [request setPredicate:predicate];
    
    NSExpression *keyExpression = [NSExpression expressionForKeyPath:attribute];
    
    NSExpression *minExpression = [NSExpression expressionForFunction:@"min:" arguments:[NSArray arrayWithObject:keyExpression]];
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyExpression]];
    NSExpression *averageExpression = [NSExpression expressionForFunction:@"average:" arguments:[NSArray arrayWithObject:keyExpression]];
    
    NSExpressionDescription *minDesc = [[NSExpressionDescription alloc] init];
    [minDesc setName:@"min"];
    [minDesc setExpression:minExpression];
    [minDesc setExpressionResultType:NSFloatAttributeType];
    
    NSExpressionDescription *maxDesc = [[NSExpressionDescription alloc] init];
    [maxDesc setName:@"max"];
    [maxDesc setExpression:maxExpression];
    [maxDesc setExpressionResultType:NSFloatAttributeType];
    
    NSExpressionDescription *averageDesc = [[NSExpressionDescription alloc] init];
    [averageDesc setName:@"average"];
    [averageDesc setExpression:averageExpression];
    [averageDesc setExpressionResultType:NSFloatAttributeType];
    
    [request setPropertiesToFetch:[NSArray arrayWithObjects:minDesc, maxDesc, averageDesc, nil]];
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error == nil && results != nil && results.count > 0){
        return [results objectAtIndex:0];
    }
    return nil;
}

-(NSDictionary*) calculateStartEndDurationForAttribute:(NSString*)attribute inEntity:(NSString*)entity withPredicate:(NSPredicate*)predicate{
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    [request setResultType:NSDictionaryResultType];
    [request setPredicate:predicate];
    
    NSExpression *keyExpression = [NSExpression expressionForKeyPath:attribute];
    
    NSExpression *minExpression = [NSExpression expressionForFunction:@"min:" arguments:[NSArray arrayWithObject:keyExpression]];
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyExpression]];
   
    NSExpressionDescription *minDesc = [[NSExpressionDescription alloc] init];
    [minDesc setName:@"start"];
    [minDesc setExpression:minExpression];
    [minDesc setExpressionResultType:NSDateAttributeType];
    
    NSExpressionDescription *maxDesc = [[NSExpressionDescription alloc] init];
    [maxDesc setName:@"end"];
    [maxDesc setExpression:maxExpression];
    [maxDesc setExpressionResultType:NSDateAttributeType];
    
    [request setPropertiesToFetch:[NSArray arrayWithObjects:minDesc, maxDesc, nil]];
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error == nil && results != nil && results.count > 0){
        if ([[results objectAtIndex:0] valueForKey:@"start"] == nil || [[results objectAtIndex:0] valueForKey:@"end"] == nil) { //abort
            return nil;
        }
        NSDate *startDate = [[results objectAtIndex:0] valueForKey:@"start"];
        NSDate *endDate = [[results objectAtIndex:0] valueForKey:@"end"];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                   fromDate:startDate
                                                     toDate:endDate
                                                    options:0];
        NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)components.second];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:startDate, @"start", endDate, @"end", durationString, @"duration", nil];
        return dict;;
    }
    return nil;
}


-(LogEntry*) getMaxLogEntryForAttribute:(NSString*)attribute withPredicate:(NSPredicate*)predicate {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"LogEntry" inManagedObjectContext:context];
    request.fetchLimit = 1;
    request.predicate = predicate;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:attribute ascending:NO]];
    NSError *error;
    return [context executeFetchRequest:request error:&error].lastObject;
}

-(int) getCountInEntity:(NSString*)entity withPredicate:(NSPredicate*)predicate {
    int count = 0;
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error == nil) {
        count = (int)results.count;
    }
    return count;
}

@end


