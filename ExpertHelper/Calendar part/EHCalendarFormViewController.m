//
//  TableViewController2.m
//  firstCalendarFrom
//
//  Created by alena on 10/28/14.
//  Copyright (c) 2014 alenka. All rights reserved.
//

#import "EHCalendarFormViewController.h"
#import "EHListOfInterviewsViewController.h"
#import "EHCalendarEventsParser.h"
#import "EHMainEventsTableViewController.h"
#import "EHEventsGetInfoParser.h"

@interface EHCalendarFormViewController () <UITableViewDataSource, UITabBarDelegate>

@property (copy, nonatomic) NSArray *sections;
@property (copy, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;

// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@property (nonatomic, copy) NSArray *eventsList;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation EHCalendarFormViewController

@synthesize sections;
@synthesize sortedDays;
@synthesize sectionDateFormatter;
@synthesize cellDateFormatter;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.eventStore = [[EKEventStore alloc] init];// Initialize the event store
    
    self.eventsList = [NSArray array] ; // Initialize the events list
    
    self.sortedDays = [NSArray array];
    self.sectionDateFormatter = [[NSDateFormatter alloc] init];
    [self.sectionDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterFullStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self
                            action:@selector(updateEvents)
                  forControlEvents:UIControlEventValueChanged];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateEvents];
    
    [self.tableView reloadData]; // Update the UI with the  events
}

- (void)updateEvents
{
    // End the refreshing
    if (self.refreshControl)
    {
        [((EHEventsGetInfoParser *)interviewFromEventsParser).calEventParser checkEventStoreAccessForCalendar];  // Check whether we are authorized to access Calendar
        
        // Fetch all events happening in the next 24 hours and put them into eventsList
        if (((EHEventsGetInfoParser *)interviewFromEventsParser).calEventParser.eventsList.count == 0)
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                              message:@"You have no interview - events in your calendar"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        } else {
            self.eventsList = [interviewFromEventsParser sortAllInterviewsToDictionary];
            self.sections = ((EHEventsGetInfoParser *)interviewFromEventsParser).interviews;
            self.sortedDays = _eventsList;
        }
        [self.tableView reloadData]; // Update the UI with the  events
        [self.refreshControl endRefreshing];
    }
    // Reload table data
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass: [EHRevealViewControllerSegue class]] ){
        EHRevealViewControllerSegue *ehSegue = (EHRevealViewControllerSegue *)segue;
        ehSegue.performBlock = ^(EHRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            EHListOfInterviewsViewController *eventsMainForm = [segue destinationViewController];
            NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
            NSArray *weeksOnThisMonth = [[self.sortedDays objectAtIndex:myIndexPath.row] weeks];
            eventsMainForm.sortedWeeks = weeksOnThisMonth;
            eventsMainForm.notFirstLoad = true;
            UINavigationController *navController = (UINavigationController *)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//[self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sortedDays count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    tableView.sectionHeaderHeight = 30;
    
    return @"Months";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSString *namesOfMonths = [[self.sortedDays objectAtIndex:indexPath.row]nameOfMonth];
    
    cell.textLabel.text = namesOfMonths;
    
    int numOfInterviews = 0;
    
    for (int j = 0; j < [[sortedDays objectAtIndex:indexPath.row] weeks].count; j++)
        numOfInterviews += [[[[sortedDays objectAtIndex:indexPath.row] weeks] objectAtIndex:j] interviews].count;
    
    cell.detailTextLabel.text = [NSString stringWithFormat: @" %d interviews", numOfInterviews];
    
    return cell;
}

@end
