//
//  LocationManager.m
//  APCInfo
//
//  Created by Ben on 30.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import "LocationController.h"

@implementation LocationController
@synthesize locationManager;
@synthesize delegate;

+ (LocationController*)sharedController {
    static LocationController *sharedControllerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedControllerInstance = [[self alloc]init];
    });
    
    return sharedControllerInstance;
}

- (id)init {
    if (self = [super init]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = (id)self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 1; // Meter.
    }
    return self;
}
    
- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation {
    if (newLocation.horizontalAccuracy < 110) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:newLocation forKey:@"location"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdate" object:self userInfo:dict];
    }
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    NSLog(@"%@", error.localizedDescription);
        
}

-(void)startLocationUpdate {
    [locationManager startUpdatingLocation];
}

-(void)stopLocationUpdate {
    [locationManager stopUpdatingLocation];
}
    
@end
