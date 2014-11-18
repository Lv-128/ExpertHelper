
//  EHCalendarEventsParser.m
//  AppointmentList
//
//  Created by alena on 11/1/14.
//  Copyright (c) 2014 Ole Begemann. All rights reserved.
//

#import "EHCalendarEventsParser.h"

@implementation EHCalendarParseResult

- (void)dealloc {
    self.firstName = nil;
    self.lastName = nil;
}

- (id)initWithName:(NSString *)name andLastName:(NSString *)lastName
{
    self = [super init];
    if (self)
    {
        self.firstName = name;
        self.lastName = lastName;
    }
    return self;
}
@end

@implementation EHCalendarParseOptions

-(id) initWithOption:(bool) option
{
    self = [super init];
    self.firstNameFirst = option;
    
    return self;
}

@end

@implementation EHCalendarEventsParser

@synthesize sections;
@synthesize sortedDays;


-(bool)canDefineTypeAsITA:(NSString *)string
{
    bool isIta = NO;
    NSError *error = NULL;
    NSString *pattern = @"\\b[ita|it academy|itacademy\\b";
    
    // NSString *string = @"ITA Interview With Alena Pyanyh ita on friday Ita ITA";
    NSRange range = NSMakeRange(0, string.length);
    
    
    NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:regexOptions error:&error];
    NSArray *matches = [regex matchesInString:string options:(NSMatchingOptions)regexOptions range:range];
    if ([matches count] > 0)
    {
        isIta = YES;
    }
    
    return isIta;
    
}
- (EHCalendarParseResult *)getNameOfCandidateFromTitle:(NSString*)string
{
    NSError *error = NULL;
    NSMutableArray * results = [[NSMutableArray alloc ]initWithCapacity:0];
 
     NSString * pat3 = @"\\s*[w|W]ith(?![Candidate|candidates|Candidates|ITA|ita|ITA|candidate])\\s*([A-Z][a-z'-]*)(\\s*[A-Z]*[a-z']*)\\s([A-Z][a-z'-]*)(\\s*[A-Z]*[a-z']*)*\\s*";
  //  NSString * pat2 = @"\\s*[w|W]ith(?![Candidate|candidates|Candidates|ITA|ita|ITA|candidate])\\s*([A-Z][a-z'-]*)(\\s*[A-Z][a-z])*([\\s\\\'-][A-Z][a-z\'-]*)*";
   //NSString *string = @"Technical interview with Kirichok Stanislav";
    NSRange range = NSMakeRange(0, string.length);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pat3 options:0 error:&error];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportCompletion range:range];
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = match.range;
        matchRange.location+=6;
        matchRange.length-=6;
    
       NSLog(@"%@",[string substringWithRange:matchRange]);
        
        [results addObject:[string substringWithRange:matchRange]];
    }
  
    EHCalendarParseResult * parseResult = [[EHCalendarParseResult alloc]init];;
    if (results.count ==1)
    {
        NSArray* parseWithSpaces = [results[0] componentsSeparatedByString: @" "];
       if (_parseOptions.firstNameFirst ==YES)
       {
        NSString * firstName = parseWithSpaces[0];
        NSString * lastName = parseWithSpaces[1];
        parseResult = [[EHCalendarParseResult alloc] initWithName:firstName andLastName:lastName];
       }
       else{
           NSString * firstName = parseWithSpaces[1];
           NSString * lastName = parseWithSpaces[0];
           parseResult = [[EHCalendarParseResult alloc] initWithName:firstName andLastName:lastName];
       }
    }
    return parseResult;
}

- (id)initWithObjection:(EHCalendarParseOptions *)options {
    
    self = [super init];
    if (self)
    {
        self.parseOptions = options;
    }
    
    return self;
}

-(id)init
{
    self=[super init];
    if (self)
    {
        self.eventStore = [[EKEventStore alloc] init];
        self.eventsList = [[NSMutableArray alloc] initWithCapacity:0];
        self.sortedDays = [[NSArray alloc]init];
        _namesMonth = [NSArray arrayWithObjects:@"January",@"February", @"March",@"April",@"May",@"June",@"July",@"August",
                       @"September",@"October",@"November",@"December", nil];
        [self getNameOfCandidateFromTitle:@"Technical interview with Kirichok Stanislav"];
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
    self.eventsList = [self fetchEvents];
 }
- (NSArray *)fetchEvents
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60 ;  //  one day interval  = 86400 seconds
    NSDate * startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay*365]; // 10 days ago
    NSDate *endDate = [self dateByAddingYears:3 toDate:startDate];
	// We will only search the default calendar for our events
	NSArray *calendarArray = [NSArray arrayWithObject:self.defaultCalendar];
    
    // Create the predicate
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                      endDate:endDate
                                                                    calendars:calendarArray];
	
	// Fetch all events that match the predicate
	NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    
    self.sections = [NSMutableDictionary dictionary];
    NSMutableArray * titles = [[NSMutableArray alloc ] init];
    for (EKEvent *event in events)
    {
        [titles  addObject:event.title];
    }
  
    NSMutableDictionary * eventsOfWeekInMonth = [[NSMutableDictionary alloc]init];
    for (EKEvent *event in events) //
    {
        NSString * upperCaseEventTitle = [event.title uppercaseString];
        if ([upperCaseEventTitle rangeOfString:@"INTERVIEW" ].location   !=  NSNotFound )
        {
            NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:event.startDate];
            
            unsigned int  compon = NSYearCalendarUnit| NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekOfMonthCalendarUnit;
            
            NSInteger weekday = [[[NSCalendar currentCalendar] components: compon fromDate:dateRepresentingThisDay] weekOfMonth];
            
            NSInteger monthday = [[[NSCalendar currentCalendar] components: compon fromDate:dateRepresentingThisDay] month];
            NSInteger yearday  =[[[NSCalendar currentCalendar] components: compon fromDate:dateRepresentingThisDay] year];
            
            NSString * key = [self.namesMonth objectAtIndex:monthday-1];
            NSString * keyForDictionary = [self.namesMonth objectAtIndex:monthday-1];
            keyForDictionary = [keyForDictionary stringByAppendingString:[NSString stringWithFormat: @"%d",yearday]];
            
            key=[key stringByAppendingString:[NSString stringWithFormat:@", week : %d", weekday]];
          
             NSMutableDictionary* tempWeek = [eventsOfWeekInMonth objectForKey:keyForDictionary];
       
            
           if ( tempWeek ==nil)
           {
               tempWeek = [NSMutableDictionary dictionary];
               [eventsOfWeekInMonth setObject:tempWeek forKey:keyForDictionary];
           }
           
            // If we don't yet have an array to hold the events for this day, create one
            NSMutableArray *eventsOnThisDay = [tempWeek objectForKey:key];
            if (eventsOnThisDay == nil) {
                eventsOnThisDay = [NSMutableArray array];
                
                // Use the reduced date as dictionary key to later retrieve the event list this day
                
        
               
                [tempWeek setObject:eventsOnThisDay forKey:key];
               
            }
            
            // Add the event to the list for this day
            [eventsOnThisDay addObject:event];
        }
    }
    
    self.sections = eventsOfWeekInMonth;
        NSArray *unsortedDays = [self.sections allKeys];// Create a sorted list of days
        self.sortedDays = unsortedDays;//[unsortedDays sortedArrayUsingSelector:@selector(compare:)];
    
	return self.sortedDays;
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
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
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
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    return newDate;
}

- (EHCalendarParseResult *)parseEventSubject:(NSString *)subject {
    EHCalendarParseResult *result = [[EHCalendarParseResult alloc] init];
    
    return result;
}


@end