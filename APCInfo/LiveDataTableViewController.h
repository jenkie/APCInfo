//
//  LiveDataTableViewController.h
//  APCInfo
//
//  Created by Ben on 14.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogEntry.h"
#import "Session.h"
#import "AppDelegate.h"

@interface LiveDataTableViewController : UITableViewController {
    LogEntry *lEntry;
    Session *s;
}
@property (weak, nonatomic) IBOutlet UILabel *labelVoltage;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrent;
@property (weak, nonatomic) IBOutlet UILabel *labelPower;
@property (weak, nonatomic) IBOutlet UILabel *labelSpeed;
@property (weak, nonatomic) IBOutlet UILabel *labelKm;
@property (weak, nonatomic) IBOutlet UILabel *labelCadence;
@property (weak, nonatomic) IBOutlet UILabel *labelWh;
@property (weak, nonatomic) IBOutlet UILabel *labelHumanPower;
@property (weak, nonatomic) IBOutlet UILabel *labelHumanWh;
@property (weak, nonatomic) IBOutlet UILabel *labelPoti;
@property (weak, nonatomic) IBOutlet UILabel *labelControlMode;
@property (weak, nonatomic) IBOutlet UILabel *labelMah;
@property (weak, nonatomic) IBOutlet UILabel *labelProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelMaxSupport;
@property (weak, nonatomic) IBOutlet UILabel *labelSpeedGps;

@end
