//
//  MapViewController.m
//  APCInfo
//
//  Created by Ben on 28.05.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController ()

@end

@implementation MapViewController {
    GMSMapView *mapView_;
}
@synthesize session;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LogEntry" inManagedObjectContext:context];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY self.session = %@", session];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSError *error;
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    GMSMutablePath *path = [GMSMutablePath path];
    LogEntry *startPoint = nil;
    LogEntry *endPoint = nil;
    if (array != nil)
    {
        for (int i = 0; i < array.count; i++) {
            LogEntry *e = array[i];
            if (i == 0) {
                startPoint = e;
            }
            else if (i == array.count - 1) {
                endPoint = e;
            }
            [path addLatitude:(CLLocationDegrees)[e.lat doubleValue] longitude:(CLLocationDegrees)[e.lon doubleValue]];
        }
        
    }
    if (startPoint != nil && endPoint != nil) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:(CLLocationDegrees)[startPoint.lat doubleValue]
                                                                longitude:(CLLocationDegrees)[startPoint.lon doubleValue]
                                                                     zoom:15];
        mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        mapView_.myLocationEnabled = YES;
        mapView_.mapType = kGMSTypeHybrid;
        self.view = mapView_;
        

        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
        
        // set marker
        GMSMarker *startMarker = [[GMSMarker alloc] init];
        startMarker.position = CLLocationCoordinate2DMake((CLLocationDegrees)[startPoint.lat doubleValue], (CLLocationDegrees)[startPoint.lon doubleValue]);
        startMarker.title = @"Start";
        startMarker.snippet = [format stringFromDate:startPoint.time];
        startMarker.map = mapView_;

        GMSMarker *endMarker = [[GMSMarker alloc] init];
        endMarker.position = CLLocationCoordinate2DMake((CLLocationDegrees)[endPoint.lat doubleValue], (CLLocationDegrees)[endPoint.lon doubleValue]);
        endMarker.title = @"End";
        endMarker.snippet = [format stringFromDate:endPoint.time];
        endMarker.map = mapView_;
        
        DataControl *c = [DataControl sharedDataControl];
        LogEntry *topSpeedEntry = [c getMaxLogEntryForAttribute:@"speed" withPredicate:predicate];
        GMSMarker *speedMarker = [[GMSMarker alloc] init];
        speedMarker.position = CLLocationCoordinate2DMake((CLLocationDegrees)[topSpeedEntry.lat doubleValue], (CLLocationDegrees)[topSpeedEntry.lon doubleValue]);
        speedMarker.title = @"Top Speed";
        speedMarker.snippet = [NSString stringWithFormat:@"%@km/h", topSpeedEntry.speed];
        speedMarker.map = mapView_;
        
        LogEntry *maxCurrentEntry = [c getMaxLogEntryForAttribute:@"current" withPredicate:predicate];
        GMSMarker *currentMarker = [[GMSMarker alloc] init];
        currentMarker.position = CLLocationCoordinate2DMake((CLLocationDegrees)[maxCurrentEntry.lat doubleValue], (CLLocationDegrees)[maxCurrentEntry.lon doubleValue]);
        currentMarker.title = @"Max Current";
        currentMarker.snippet = [NSString stringWithFormat:@"%@A", maxCurrentEntry.current];
        currentMarker.map = mapView_;
        
        
        // Add path
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeColor = [UIColor blueColor];
        polyline.strokeWidth = 5.f;
        polyline.map = mapView_;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)satelliteButtonTapped:(id)sender {
    mapView_.mapType = kGMSTypeSatellite;
}

- (IBAction)mapButtonTapped:(id)sender {
    mapView_.mapType = kGMSTypeNormal;
}

- (IBAction)hybridButtonTapped:(id)sender {
    mapView_.mapType = kGMSTypeHybrid;
}
@end
