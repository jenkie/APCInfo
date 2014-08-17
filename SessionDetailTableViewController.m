//
//  SessionDetailTableViewController.m
//  APCInfo
//
//  Created by Ben on 18.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import "SessionDetailTableViewController.h"

@interface SessionDetailTableViewController ()

@end

@implementation SessionDetailTableViewController
@synthesize sessionName;
@synthesize session;
@synthesize startEnd;
@synthesize duration;
@synthesize minMaxAverageVoltage;
@synthesize minMaxAverageCurrent;
@synthesize minMaxAveragePower;
@synthesize averageTopSpeed;
@synthesize totalKm;
@synthesize labelWh;
@synthesize labelMah;
@synthesize averageTopSpeedDriving;

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
    sessionName.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated {

    sessionName.text = session.name;
    
    DataControl *c = [DataControl sharedDataControl];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"dd.MM.yyyy HH:mm:ss" options:0 locale:[NSLocale currentLocale]];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:[NSLocale currentLocale]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY self.session = %@", session];
    
    NSDictionary *vals = [c calculateStartEndDurationForAttribute:@"time" inEntity:@"LogEntry" withPredicate:predicate];
    
    if (vals == nil) { //no data, simply show clear view
        return;
    }
   
    startEnd.text = [NSString stringWithFormat:@"%@ %@", [formatter stringFromDate:[vals valueForKey:@"start"]], [formatter stringFromDate:[vals valueForKey:@"end"]]];
    
    predicate = [NSPredicate predicateWithFormat:@"ANY self.session = %@ AND speed == 0", session];
    int count = [c getCountInEntity:@"LogEntry" withPredicate:predicate];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    int storeInterval = (int)[defaults integerForKey:@"dbStoreInterval"];
    NSDate *startDate = [vals valueForKey:@"start"];
    NSDate *endDate = [vals valueForKey:@"end"];
    NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate]-storeInterval*count;
    NSInteger seconds = (NSInteger)interval % 60;
    NSInteger minutes = ((NSInteger)interval / 60) % 60;
    NSInteger hours = ((NSInteger)interval / 3600);
    NSString *drivingTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    duration.text = [NSString stringWithFormat:@"%@/%@", [vals valueForKey:@"duration"], drivingTime ];
    
    
    predicate = [NSPredicate predicateWithFormat:@"ANY self.session = %@", session];
    
    vals = [c calculateMinMaxAverageForAttribute:@"km" inEntity:@"LogEntry" withPredicate:predicate];
    totalKm.text = [NSString stringWithFormat:@"%.1f km", [[vals valueForKey:@"max"] floatValue] - [[vals valueForKey:@"min"] floatValue]];
    
    vals = [c calculateMinMaxAverageForAttribute:@"speed" inEntity:@"LogEntry" withPredicate:predicate];
    averageTopSpeed.text = [NSString stringWithFormat:@"%.1f/%.1f km/h", [[vals valueForKey:@"average"] floatValue], [[vals valueForKey:@"max"] floatValue]];
    
    vals = [c calculateMinMaxAverageForAttribute:@"power" inEntity:@"LogEntry" withPredicate:predicate];
    minMaxAveragePower.text = [NSString stringWithFormat:@"%.1f/%.1f/%.1f W", [[vals valueForKey:@"min"] floatValue], [[vals valueForKey:@"max"] floatValue], [[vals valueForKey:@"average"] floatValue]];
    
    vals = [c calculateMinMaxAverageForAttribute:@"voltage" inEntity:@"LogEntry" withPredicate:predicate];
    minMaxAverageVoltage.text = [NSString stringWithFormat:@"%.1f/%.1f/%.1f V", [[vals valueForKey:@"min"] floatValue], [[vals valueForKey:@"max"] floatValue], [[vals valueForKey:@"average"] floatValue]];
    
    vals = [c calculateMinMaxAverageForAttribute:@"current" inEntity:@"LogEntry" withPredicate:predicate];
    minMaxAverageCurrent.text = [NSString stringWithFormat:@"%.1f/%.1f/%.1f A", [[vals valueForKey:@"min"] floatValue], [[vals valueForKey:@"max"] floatValue], [[vals valueForKey:@"average"] floatValue]];
    
    vals = [c calculateMinMaxAverageForAttribute:@"wh" inEntity:@"LogEntry" withPredicate:predicate];
    labelWh.text = [NSString stringWithFormat:@"%dWh", [[vals valueForKey:@"max"] intValue] - [[vals valueForKey:@"min"] intValue]];
    
    vals = [c calculateMinMaxAverageForAttribute:@"mah" inEntity:@"LogEntry" withPredicate:predicate];
    labelMah.text = [NSString stringWithFormat:@"%dmAh", [[vals valueForKey:@"max"] intValue] - [[vals valueForKey:@"min"] intValue]];
    
    
    predicate = [NSPredicate predicateWithFormat:@"ANY self.session = %@ AND speed != 0", session];
    vals = [c calculateMinMaxAverageForAttribute:@"speed" inEntity:@"LogEntry" withPredicate:predicate];
    averageTopSpeedDriving.text = [NSString stringWithFormat:@"%.1f km/h", [[vals valueForKey:@"average"] floatValue]];
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    session.name = sessionName.text;
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Cant store changes:%@", [error localizedDescription]);
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"mapViewSegue"]) {
        MapViewController *v = segue.destinationViewController;
        v.session = session;
    }
}

@end
