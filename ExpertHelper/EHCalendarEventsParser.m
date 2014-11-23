
//  EHCalendarEventsParser.m
//  AppointmentList
//
//  Created by alena on 11/1/14.
//  Copyright (c) 2014 Ole Begemann. All rights reserved.
//

#import "EHCalendarEventsParser.h"

@implementation EHCalendarEventsParser

-(id)init
{
    self = [super init];
    if (self)
    {
        self.eventStore = [[EKEventStore alloc] init];
        self.eventsList = [[NSArray alloc] init];
        
        _namesMonth = [NSArray arrayWithObjects:@"January",@"February", @"March",@"April",@"May",@"June",@"July",@"August",
                       @"September",@"October",@"November",@"December", nil];
    }
    return self;
}

#pragma mark -
#pragma mark Access Calendar

// Check the authorization status of our application for Calendar
-(void)checkEventStoreAccessForCalendar
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (status)
    {
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized: [self accessGrantedForCalendar];
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
            break;
            // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}


// Prompt the user for access to their Calendar
-(void)requestCalendarAccess
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             EHCalendarEventsParser * __weak weakSelf = self;
             // Let's ensure that our code will be executed from the main queue
             dispatch_async(dispatch_get_main_queue(), ^{
                 // The user has granted access to their Calendar; let's populate our UI with all events occuring in the next 24 hours.
                 [weakSelf accessGrantedForCalendar];
             });
         }
     }];
}


// when  granted permission to Calendar  INITIALIZATION OF EVENTS
-(void)accessGrantedForCalendar
{
    self.defaultCalendar = self.eventStore.defaultCalendarForNewEvents;
    //self.defaultCalendar = [self.eventStore calendarWithIdentifier:@"expert.helper.tester@gmail.com"];
    
    NSArray * temp = [self fetchEvents];
    self.eventsList = temp;
}

- (NSArray *)fetchEvents
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60 ;  //  one day interval  = 86400 seconds
    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSinceNow: -secondsPerDay * 365]; // 10 days ago
    NSDate *endDate = [self dateByAddingYears: 3 toDate: startDate];
	// We will only search the default calendar for our events
	NSArray *calendarArray = [NSArray arrayWithObject: self.defaultCalendar];
    
    // Create the predicate
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate: startDate
                                                                      endDate: endDate
                                                                    calendars: calendarArray];
	// Fetch all events that match the predicate
	NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate: predicate]];
    

    NSMutableArray *titles = [[NSMutableArray alloc ] init];
    for (EKEvent *event in events)
    {
        [titles  addObject:event.title];
    }
    
    NSMutableArray *allEvents = [[NSMutableArray alloc]initWithCapacity: 0];
    for (EKEvent *event in events) //
    {
        NSString *upperCaseEventTitle = [event.title uppercaseString];
        if ([upperCaseEventTitle rangeOfString:@"INTERVIEW"].location != NSNotFound)
        {
            [allEvents addObject:event];
        }
    }
    return allEvents;
}


#pragma mark - Date Calculations

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour: 0];
    [dateComps setMinute: 0];
    [dateComps setSecond: 0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate
{
    // Use the user's current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:numberOfYears];
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options: 0];
    return newDate;
}


@end