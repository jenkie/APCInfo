//
//  ApcInfoTableViewController.h
//  APCInfo
//
//  Created by Ben on 17.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import "CustomHud.h"
#import "SessionTableViewController.h"
#import "ApcBtCom.h"
#import "LocationController.h"

@interface ApcInfoTableViewController : UITableViewController {
    Session *s;
    int prePotiValue;
    NSUserDefaults *defaults;
}
@property (weak, nonatomic) IBOutlet UISwitch *switchSessionRunning;
- (IBAction)switchSessionRunningTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelConnectionState;
@property (weak, nonatomic) IBOutlet UILabel *labelSessionState;
@property (weak, nonatomic) IBOutlet UIImageView *imageSessionRecording;
@property (weak, nonatomic) IBOutlet UIImageView *batteryIndicator;
@property (weak, nonatomic) IBOutlet UILabel *labelPoti;
@property (weak, nonatomic) IBOutlet UILabel *labelVoltage;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrent;
@property (weak, nonatomic) IBOutlet UILabel *labelPower;
@property (weak, nonatomic) IBOutlet UILabel *labelBatteryIndicator;
@property (weak, nonatomic) IBOutlet UILabel *labelMah;
- (IBAction)connectionSwitchValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *connectionSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *connectImage;
@property (weak, nonatomic) IBOutlet UILabel *labelSpeed;
@property (weak, nonatomic) IBOutlet UILabel *labelKm;
@property (weak, nonatomic) IBOutlet UILabel *labelWh;
@property (weak, nonatomic) IBOutlet UILabel *labelSpeedGps;
- (IBAction)potiSliderChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *potiSlider;
- (IBAction)gpsSwitchValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *gpsSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *profileSegmented;
- (IBAction)profileSegmentedValueChanged:(id)sender;


@end
