//
//  LiveDataTableViewController.m
//  APCInfo
//
//  Created by Ben on 14.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import "LiveDataTableViewController.h"
#import "ApcBtCom.h"
#import "LogEntry.h"
#import <CoreLocation/CoreLocation.h>


@interface LiveDataTableViewController ()

@end

@implementation LiveDataTableViewController
@synthesize labelCadence;
@synthesize labelControlMode;
@synthesize labelCurrent;
@synthesize labelHumanPower;
@synthesize labelHumanWh;
@synthesize labelKm;
@synthesize labelPoti;
@synthesize labelPower;
@synthesize labelSpeed;
@synthesize labelVoltage;
@synthesize labelWh;
@synthesize labelMah;
@synthesize labelMaxSupport;
@synthesize labelProfile;
@synthesize labelSpeedGps;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"receivedData"
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)receivedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"receivedData"]) {
        NSMutableDictionary *lEntryDict = [[notification userInfo] objectForKey:@"logEntry"];
        labelVoltage.text = [[lEntryDict valueForKey:@"voltage"] stringValue];
        labelCurrent.text = [[lEntryDict valueForKey:@"current"] stringValue];
        labelPower.text = [[lEntryDict valueForKey:@"power"] stringValue];
        labelSpeed.text = [[lEntryDict valueForKey:@"speed"] stringValue];
        labelKm.text = [[lEntryDict valueForKey:@"km"] stringValue];
        labelCadence.text = [[lEntryDict valueForKey:@"cadence"] stringValue];
        labelWh.text = [[lEntryDict valueForKey:@"wh"] stringValue];
        labelHumanPower.text = [[lEntryDict valueForKey:@"humanPower"] stringValue];
        labelHumanWh.text = [[lEntryDict valueForKey:@"humanWh"] stringValue];
        labelPoti.text = [[lEntryDict valueForKey:@"poti"] stringValue];
        labelControlMode.text = [lEntryDict valueForKey:@"controlMode"];
        labelMah.text = [[lEntryDict valueForKey:@"mah"] stringValue];
        labelMaxSupport.text = [[lEntryDict valueForKey:@"potiMax"] stringValue];
        labelProfile.text = [[lEntryDict valueForKey:@"currentProfile"] stringValue];
    }
    else if ([[notification name] isEqualToString:@"receivedData"]) {
        CLLocation *loc = [[notification userInfo] objectForKey:@"location"];
        double kmh = loc.speed*3.6;
        labelSpeedGps.text = [NSString stringWithFormat:@"%.01f", kmh];

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

@end
