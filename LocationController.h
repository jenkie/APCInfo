//
//  LocationManager.h
//  APCInfo
//
//  Created by Ben on 30.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationController : NSObject {
    CLLocationManager* locationManager;
    __weak id delegate;
}

+ (LocationController*)sharedController;
-(void)startLocationUpdate;
-(void)stopLocationUpdate;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, weak) id  delegate;
@end