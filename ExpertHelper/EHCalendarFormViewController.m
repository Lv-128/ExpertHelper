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
#import "EHInterview.h"
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

@property (nonatomic,strong) EHEventsGetInfoParser * interviewFromEventsParser;
@property (strong , nonatomic) UIRefreshControl * refreshControl;

@end

@implementation EHCalendarFormViewController

@synthesize sections;
@synthesize sortedDays;
@synthesize sectionDateFormatter;
@synthesize cellDateFormatter;

enum {  All = 0, ITA = 1, External = 2, None = 3};



-(IBAction)segmentButton:(id)sender
{
    if (segment.selectedSegmentIndex == All)
        whichTypeOfInterviewIsChosen = All;
    
    if (segment.selectedSegmentIndex == ITA)
        whichTypeOfInterviewIsChosen = ITA;
    
    if (segment.selectedSegmentIndex == External)
        whichTypeOfInterviewIsChosen = External;
    
    if (segment.selectedSegmentIndex == None)
        whichTypeOfInterviewIsChosen = None;
}


#pragma mark - View lifecycle

-(void) dealloc
{
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    whichTypeOfInterviewIsChosen = All;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    
	self.eventStore = [[EKEventStore alloc] init];// Initialize the event store
    
	self.eventsList = [NSArray array] ; // Initialize the events list
    
    _interviewFromEventsParser = [[EHEventsGetInfoParser alloc]init];
    
    
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




-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateEvents];
    
    [self.tableView reloadData]; // Update the UI with the  events
}

-(void)updateEvents
{
   
    
    // End the refreshing
    if (self.refreshControl) {
        
        
        [_interviewFromEventsParser.calEventParser checkEventStoreAccessForCalendar];  // Check whether we are authorized to access Calendar
        
        // Fetch all events happening in the next 24 hours and put them into eventsList
        if (_interviewFromEventsParser.calEventParser.eventsList.count == 0)
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                              message:@"You have no interview - events in your calendar"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        else{
            
            //interviewsParser.events = _interviewFromEventsParser.calEventParser.eventsList;
            
            self.eventsList = [_interviewFromEventsParser sortAllInterviewsToDictionary];
            self.sections = _interviewFromEventsParser.interviews;
            
            self.sortedDays = _eventsList;
        }
          [self.refreshControl endRefreshing];
    }
    // Reload table data
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"GoToMainEventsForm"])
    {
        EHListOfInterviewsViewController * eventsMainForm = [segue destinationViewController];
        NSIndexPath * myIndexPath = [self.tableView indexPathForSelectedRow];
        //  NSString *selectedMonth = [self.sortedDays objectAtIndex:myIndexPath.row];
        NSArray *weeksOnThisMonth = [[self.sortedDays objectAtIndex:myIndexPath.row] weeks];
        
        eventsMainForm.sortedWeeks = weeksOnThisMonth;
        
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
    
    return @"MONTHs";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    //    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    //    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    //    EKEvent *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    NSString * namesOfMonths = [[self.sortedDays objectAtIndex:indexPath.row]nameOfMonth];
    
    cell.textLabel.text = namesOfMonths;
    
    
    //cell.detailTextLabel.text = [self.cellDateFormatter stringFromDate:event.startDate];
    
    return cell;
}






@end
