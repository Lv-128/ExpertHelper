//
//  TableViewController2.m
//  firstCalendarFrom
//
//  Created by alena on 10/28/14.
//  Copyright (c) 2014 alenka. All rights reserved.
//

#import "EHCalendarFormViewController.h"
#import "EHInterviewFromViewController.h"

@interface EHCalendarFormViewController () <UITableViewDataSource, UITabBarDelegate>
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate;
@end

@implementation EHCalendarFormViewController

@synthesize sections;
@synthesize sortedDays;


enum {  All = 0, ITA = 1, External = 2, None = 3};

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

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

//- (void)setupWithTitle:(NSString *)title detailText:(NSString *)detailText level:(NSInteger)level additionButtonHidden:(BOOL)additionButtonHidden
//{
//    self.customTitleLabel.text = title;
//    self.detailedLabel.text = detailText;
//    self.additionButtonHidden = additionButtonHidden;
//    
//    if (level == 0) {
//        self.detailTextLabel.textColor = [UIColor blackColor];
//    }
//    
//    if (level == 0) {
//        self.backgroundColor = UIColorFromRGB(0xF7F7F7);
//    } else if (level == 1) {
//        self.backgroundColor = UIColorFromRGB(0xD1EEFC);
//    } else if (level >= 2) {
//        self.backgroundColor = UIColorFromRGB(0xE0F8D8);
//    }
//    
//    CGFloat left = 11 + 20 * level;
//    
//    CGRect titleFrame = self.customTitleLabel.frame;
//    titleFrame.origin.x = left;
//    self.customTitleLabel.frame = titleFrame;
//    
//    CGRect detailsFrame = self.detailedLabel.frame;
//    detailsFrame.origin.x = left;
//    self.detailedLabel.frame = detailsFrame;
//}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    whichTypeOfInterviewIsChosen = All;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.sections = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[@"Monday,1", @"Tuesday,1"], @"September", @[@"Wednesday,14", @"Friday,28"], @"October", nil];
    
    
    
    
    
    
    
    // Create a sorted list of days
    NSArray *unsortedDays = [self.sections allKeys];
    self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
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
        NSString *event = [eventsOnThisDay objectAtIndex:row];
        
        interviewForm.date = event; //event;
        
    }
    
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
    NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    NSString *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    NSString *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    cell.textLabel.text = event;
    cell.backgroundColor = [UIColor colorWithRed:0.62 green:0.77 blue:0.91 alpha:1.0];
    //cell.detailTextLabel.text = @">";
    
    return cell;
}

@end
