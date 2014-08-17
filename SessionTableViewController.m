//
//  SessionTableViewController.m
//  APCInfo
//
//  Created by Ben on 16.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import "SessionTableViewController.h"

@interface SessionTableViewController ()

@end

@implementation SessionTableViewController
@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize selectedSession;

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
    
    managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:false];
    [self.tableView reloadData];

    [self.tableView selectRowAtIndexPath:[_fetchedResultsController indexPathForObject:selectedSession] animated:true scrollPosition:UITableViewScrollPositionNone];
    SessionTableViewCell *cell = (SessionTableViewCell*)[self.tableView cellForRowAtIndexPath:[_fetchedResultsController indexPathForObject:selectedSession]];
    [cell.checkImageView setImage:[UIImage imageNamed:@"cellCheckmark.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
    Session *s = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.sessionName.text = s.name;
    return cell;
}

#pragma mark - Core Data stuff

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext: managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [managedObjectContext deleteObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
        NSError *error;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Error while deleting: %@", [error localizedDescription]);
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SessionTableViewCell *cell = (SessionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.checkImageView setImage:[UIImage imageNamed:@"cellCheckmark.png"]];
     NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    [payload setValue:[_fetchedResultsController objectAtIndexPath:indexPath] forKey:@"session"];
    selectedSession = [_fetchedResultsController objectAtIndexPath:indexPath];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sessionSelected" object:self userInfo:payload];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SessionTableViewCell *cell = (SessionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.checkImageView setImage:nil];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath
{
    UITableView* tableView = self.tableView;
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            //[tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView endUpdates];
}

- (IBAction)addButtonTapped:(id)sender {
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    Session *s = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:context];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    s.name = [dateFormatter stringFromDate:[NSDate date]];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error while saving: %@", [error localizedDescription]);
    }
    else {
        NSLog(@"Session stored to Database");
    }
}

- (IBAction)startButtonTapped:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Session selected" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        return;
    }
    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    [payload setValue:[_fetchedResultsController objectAtIndexPath:indexPath] forKey:@"session"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startLogging" object:self userInfo:payload];
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

- (IBAction)stopButtonTapped:(id)sender {
    CustomHud *hud = [[CustomHud alloc] init];
    [hud showSuccessHudInView:self.navigationController.view withDetailText:@"Logging stopped"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLogging" object:self userInfo:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"sessionDetailSegue"]) {
        SessionDetailTableViewController *v = segue.destinationViewController;
        v.session = [_fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
    }
}
@end
