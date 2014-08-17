//
//  MapViewController.h
//  APCInfo
//
//  Created by Ben on 28.05.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import "AppDelegate.h"
#import "LogEntry.h"
#import "DataControl.h"


@interface MapViewController : UIViewController {
}
- (IBAction)satelliteButtonTapped:(id)sender;
- (IBAction)mapButtonTapped:(id)sender;
- (IBAction)hybridButtonTapped:(id)sender;
@property (nonatomic, strong) Session *session;
@end
