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

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate;
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
 
    // Initialize the event store
	self.eventStore = [[EKEventStore alloc] init];
    // Initialize the events list
	self.eventsList = [[NSMutableArray alloc] initWithCapacity:0];
    
    
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
    // Check whether we are authorized to access Calendar
    [_calEventParser checkEventStoreAccessForCalendar];
    
    // Fetch all events happening in the next 24 hours and put them into eventsList
    self.eventsList = _calEventParser.eventsList;
    self.sections = _calEventParser.sections;
    
    self.sortedDays = _calEventParser.sortedDays;
    // Update the UI with the above events
    [self.tableView reloadData];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"GoToInterviewForm"])
    {
        EHInterviewFromViewController * interviewForm = [segue destinationViewController];
        NSIndexPath * myIndexPath = [self.tableView indexPathForSelectedRow];
        
        
        
        int row = [myIndexPath row];
        
        NSString *dateRepresentingThisDay = [self.sortedDays objectAtIndex:myIndexPath.section];
        NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        EKEvent *event = [eventsOnThisDay objectAtIndex:row];
        
        interviewForm.date = [self.cellDateFormatter stringFromDate:event.startDate];
        
    }
    
}

#pragma mark - UITableViewDataSource methods

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    return dateRepresentingThisDay;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    EKEvent *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:event.startDate
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSLog(@"%@",dateString);
    
       cell.textLabel.text = event.title;
//    cell.textLabel.numberOfLines = 2;
 //   cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    
    cell.detailTextLabel.text = [self.cellDateFormatter stringFromDate:event.startDate];
    
    return cell;
}






@end
