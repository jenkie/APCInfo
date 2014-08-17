//
//  SessionDetailTableViewController.h
//  APCInfo
//
//  Created by Ben on 18.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import "AppDelegate.h"
#import "LogEntry.h"
#import "DataControl.h"
#import "MapViewController.h"

@interface SessionDetailTableViewController : UITableViewController <UITextFieldDelegate> {
    Session *session;
}
@property (weak, nonatomic) IBOutlet UITextField *sessionName;
@property (weak, nonatomic) IBOutlet UILabel *startEnd;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *totalKm;
@property (weak, nonatomic) IBOutlet UILabel *averageTopSpeed;
@property (weak, nonatomic) IBOutlet UILabel *minMaxAveragePower;
@property (weak, nonatomic) IBOutlet UILabel *minMaxAverageVoltage;
@property (weak, nonatomic) IBOutlet UILabel *minMaxAverageCurrent;
@property (weak, nonatomic) IBOutlet UILabel *labelWh;
@property (nonatomic, strong) Session *session;
@property (weak, nonatomic) IBOutlet UILabel *labelMah;
@property (weak, nonatomic) IBOutlet UILabel *averageTopSpeedDriving;
@end
