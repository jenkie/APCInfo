//
//  ApcInfoTableViewController.m
//  APCInfo
//
//  Created by Ben on 17.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import "ApcInfoTableViewController.h"

@interface ApcInfoTableViewController ()

@end

@implementation ApcInfoTableViewController

@synthesize labelConnectionState;
@synthesize labelSessionState;
@synthesize imageSessionRecording;
@synthesize switchSessionRunning;
@synthesize batteryIndicator;
@synthesize labelBatteryIndicator;
@synthesize labelCurrent;
@synthesize labelPoti;
@synthesize labelPower;
@synthesize labelVoltage;
@synthesize connectImage;
@synthesize connectionSwitch;
@synthesize labelKm;
@synthesize labelSpeed;
@synthesize labelWh;
@synthesize potiSlider;
@synthesize gpsSwitch;
@synthesize profileSegmented;
@synthesize labelMah;
@synthesize labelSpeedGps;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    defaults = [NSUserDefaults standardUserDefaults];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"connectingDevice"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"connectedDevice"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"disconnectedDevice"
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
                                                 name:@"receivedData"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"locationUpdate"
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:true];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receivedNotification:(NSNotification *) notification {
    CustomHud *hud = [[CustomHud alloc] init];
    if ([[notification name] isEqualToString:@"connectingDevice"]) {
        [hud showOffsetMessageHudInView:self.navigationController.view withText:@"Connecting..."];
    }
    if ([[notification name] isEqualToString:@"connectedDevice"]) {
        [hud showSuccessHudInView:self.navigationController.view withDetailText:@"Connected"];
        labelConnectionState.text = @"Connected";
        [connectImage setImage:[UIImage imageNamed:@"connected.png"]];
        [connectionSwitch setOn:true];
    }
    else if ([[notification name] isEqualToString:@"disconnectedDevice"]) {
        [hud showOffsetMessageHudInView:self.navigationController.view withText:@"Disconnected"];
        if (switchSessionRunning.isOn) {  //try reconnect if session-recording is on
          ApcBtCom *c = [ApcBtCom sharedApcBtCom ];
          [c reconnect];
        }
        labelConnectionState.text = @"Disconnected";
        [connectImage setImage:[UIImage imageNamed:@"disconnected.png"]];
        [batteryIndicator setImage:[UIImage imageNamed:@"battery-0.png"]];
        [connectionSwitch setOn:false];
    }
    else if ([[notification name] isEqualToString:@"startLogging"]) {
        if (s.objectID == nil) {
            [hud showOffsetMessageHudInView:self.navigationController.view withText:@"Starting new session."];
            NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
            s = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:context];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
            s.name = [dateFormatter stringFromDate:[NSDate date]];
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Store error: %@", [error localizedDescription]);
            }
            else {
                NSLog(@"Session stored to Database");
                NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
                [payload setValue:s forKey:@"session"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sessionSelected" object:self userInfo:payload];
            }
        }
        [hud showOffsetMessageHudInView:self.navigationController.view withText:@"Logging started"];
        labelSessionState.text = s.name;
        [imageSessionRecording setImage:[UIImage imageNamed:@"sessionGreen.png"]];
        [switchSessionRunning setOn:true];
    }
    else if ([[notification name] isEqualToString:@"stopLogging"]) {
        [hud showOffsetMessageHudInView:self.navigationController.view withText:@"Logging stopped"];
        //labelSessionState.text = @"No Session selected";
        [imageSessionRecording setImage:[UIImage imageNamed:@"session.png"]];
        [switchSessionRunning setOn:false];
    }
    else if ([[notification name] isEqualToString:@"sessionSelected"]) {
        s = [[notification userInfo] objectForKey:@"session"];
        labelSessionState.text = s.name;
    }
    else if ([[notification name] isEqualToString:@"receivedData"]) {
        NSMutableDictionary *lEntryDict = [[notification userInfo] objectForKey:@"logEntry"];
        if (lEntryDict.count > 0) {
            labelVoltage.text = [NSString stringWithFormat:@"%@", [lEntryDict valueForKey:@"voltage"]];
            labelCurrent.text = [NSString stringWithFormat:@"%@", [lEntryDict valueForKey:@"current"]];
            labelPower.text = [NSString stringWithFormat:@"%@", [lEntryDict valueForKey:@"power"]];
            labelSpeed.text = [NSString stringWithFormat:@"%@", [lEntryDict valueForKey:@"speed"]];
            labelKm.text = [NSString stringWithFormat:@"%@", [lEntryDict valueForKey:@"km"]];
            labelWh.text = [NSString stringWithFormat:@"%@", [lEntryDict valueForKey:@"wh"]];
            
            //Battery-Indicator
            float wh = [[lEntryDict valueForKey:@"wh"] floatValue];
            float capacity = (int)[defaults floatForKey:@"batteryCapacity"];
            float percent = (capacity-wh)/capacity;
            NSString *imageName = [NSString stringWithFormat:@"battery-%.0f.png", round(percent*10)*10];
            [batteryIndicator setImage:[UIImage imageNamed:imageName]];
            labelBatteryIndicator.text = [NSString stringWithFormat:@"%.0f%%", percent*100];
            
            labelMah.text = [NSString stringWithFormat:@"%@", [lEntryDict valueForKey:@"mah"]];
            int potiValue = [[lEntryDict valueForKey:@"poti"] intValue];
            labelPoti.text = [NSString stringWithFormat:@"%d", potiValue];
            if (potiValue != prePotiValue) {
                int potiMax = [[lEntryDict valueForKey:@"potiMax"] intValue];
                [potiSlider setValue:potiValue*(int)potiSlider.maximumValue/potiMax];
            }
            prePotiValue = potiValue;
            
            int profile = [[lEntryDict valueForKey:@"currentProfile"] intValue];
            if (profile != profileSegmented.selectedSegmentIndex) {
                profileSegmented.selectedSegmentIndex = profile;
            }
        }
    }
    else if ([[notification name] isEqualToString:@"locationUpdate"]) {
        CLLocation *loc = [[notification userInfo] objectForKey:@"location"];
        double kmh = loc.speed*3.6;
        labelSpeedGps.text = [NSString stringWithFormat:@"%.01f", kmh];
    }
}

- (IBAction)switchSessionRunningTapped:(id)sender {
    if (switchSessionRunning.isOn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startLogging" object:self userInfo:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLogging" object:self userInfo:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"sessionSegue"]) {
        SessionTableViewController *v = segue.destinationViewController;
        v.selectedSession = s;
    }
}

- (IBAction)connectionSwitchValueChanged:(id)sender {
    ApcBtCom *c = [ApcBtCom sharedApcBtCom ];
    if (connectionSwitch.isOn) {
        [c connect];
    }
    else {
        if (c.isConnected) {
            [c disconnect];
        }
    }
}
- (IBAction)potiSliderChanged:(id)sender {
    ApcBtCom *c = [ApcBtCom sharedApcBtCom ];
    [c sendString:[NSString stringWithFormat:@"ps%.0f\n", potiSlider.value]];
}

- (IBAction)gpsSwitchValueChanged:(id)sender {
    LocationController *loc = [LocationController sharedController];
    if (gpsSwitch.isOn) {
        [loc startLocationUpdate];
    }
    else {
        [loc stopLocationUpdate];
    }
}

- (IBAction)profileSegmentedValueChanged:(id)sender {
    ApcBtCom *c = [ApcBtCom sharedApcBtCom ];
    if (profileSegmented.selectedSegmentIndex == 0) {
        [c sendInitString:[defaults stringForKey:@"profileOneCmd"]];
        //[c sendString:[NSString stringWithFormat:@"%@\n", [defaults stringForKey:@"profileOneCmd"]]];
    }
    else {
        [c sendInitString:[defaults stringForKey:@"profileTwoCmd"]];
        //[c sendString:[NSString stringWithFormat:@"%@\n", [defaults stringForKey:@"profileTwoCmd"]]];
    }
}

@end
