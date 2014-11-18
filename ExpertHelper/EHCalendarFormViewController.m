//
//  TableViewController2.m
//  firstCalendarFrom
//
//  Created by alena on 10/28/14.
//  Copyright (c) 2014 alenka. All rights reserved.
//

#import "EHCalendarFormViewController.h"
#import "EHInterviewFromViewController.h"
#import "EHCalendarEventsParser.h"

#import "EHMainEventsTableViewController.h"
@interface EHCalendarFormViewController () <UITableViewDataSource, UITabBarDelegate>
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;


// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@property (nonatomic, strong) NSMutableArray *eventsList;

@property (nonatomic , strong) EHCalendarEventsParser * calEventParser;


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



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    whichTypeOfInterviewIsChosen = All;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
 
    
	self.eventStore = [[EKEventStore alloc] init];// Initialize the event store
   
	self.eventsList = [[NSMutableArray alloc] initWithCapacity:0]; // Initialize the events list
    
    
    self.calEventParser = [[EHCalendarEventsParser alloc] init];
    [_calEventParser checkEventStoreAccessForCalendar];
    
    self.sectionDateFormatter = [[NSDateFormatter alloc] init];
    [self.sectionDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterFullStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
    [_calEventParser checkEventStoreAccessForCalendar];  // Check whether we are authorized to access Calendar
    
    // Fetch all events happening in the next 24 hours and put them into eventsList
    self.eventsList = _calEventParser.eventsList;
    self.sections = _calEventParser.sections;
    
    self.sortedDays = _calEventParser.sortedDays;
   
    [self.tableView reloadData]; // Update the UI with the  events
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
        EHMainEventsTableViewController * eventsMainForm = [segue destinationViewController];
        NSIndexPath * myIndexPath = [self.tableView indexPathForSelectedRow];
        NSString *selectedMonth = [self.sortedDays objectAtIndex:myIndexPath.row];
        NSDictionary *weeksOnThisMonth = [self.sections objectForKey:selectedMonth];
        
        eventsMainForm.sections = weeksOnThisMonth;
        
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
    
    NSString * namesOfMonths = [self.sortedDays objectAtIndex:indexPath.row];
    
    cell.textLabel.text = namesOfMonths;
    
    
    //cell.detailTextLabel.text = [self.cellDateFormatter stringFromDate:event.startDate];
    
    return cell;
}






@end
