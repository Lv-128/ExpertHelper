//
//  EHMainEventsTableViewController.m
//  ExpertHelper
//
//  Created by alena on 11/14/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHCalendarEventsParser.h"
#import "EHMainEventsTableViewController.h"

@interface EHMainEventsTableViewController ()<UITableViewDataSource, UITabBarDelegate>

@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;





@property (nonatomic , strong) EHCalendarEventsParser * calEventParser;




@end

@implementation EHMainEventsTableViewController
@synthesize sections;
@synthesize sortedDays;
@synthesize sectionDateFormatter;
@synthesize cellDateFormatter;

enum {  All = 0, ITA = 1, External = 2, None = 3};





#pragma mark - View lifecycle



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.sortedDays = [self.sections allKeys];
    
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
    NSString *reuseIdentifier = @"EventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    NSString *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    EKEvent *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    cell.textLabel.text = event.title;
    cell.backgroundColor = [UIColor colorWithRed:0.62 green:0.77 blue:0.91 alpha:1.0];
      cell.detailTextLabel.text = [self.cellDateFormatter stringFromDate:event.startDate];
    return cell;
}


@end