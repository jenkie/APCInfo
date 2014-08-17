//
//  SessionTableViewController.h
//  APCInfo
//
//  Created by Ben on 16.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "SessionTableViewCell.h"
#import "Session.h"
#import "CustomHud.h"
#import "SessionDetailTableViewController.h"

@interface SessionTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    Session *selectedSession;
}
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) Session *selectedSession;
- (IBAction)addButtonTapped:(id)sender;
- (IBAction)startButtonTapped:(id)sender;
- (IBAction)stopButtonTapped:(id)sender;

@end
