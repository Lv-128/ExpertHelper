//
//  EHEventsGetInfoParser.m
//  ExpertHelper
//
//  Created by alena on 11/19/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//
#import "EHEventsGetInfoParser.h"
#import "EHConstantsDefines.h"
#import "EHAppDelegate.h"

@implementation EHMonth
-(id)init
{
    self = [super init];
    if (self)
    {
        _weeks = [NSArray array];
    }
    return self;
}

- (void)dealloc {
    self.weeks = nil;
    self.nameOfMonth = nil;
    self.dateStartOfMonth = nil;
}

@end

@implementation EHWeek
- (id)init
{
    self = [super init];
    if (self)
    {
        _interviews = [NSArray array];
    }
    return self;
}

- (void)dealloc {
    self.interviews = nil;
    self.nameOfWeek = nil;
}

@end

@implementation EHCalendarParseOptions

- (id)initWithOptionFirstNameFirst:(BOOL)firstNameFirst
                andTheOneCandidate:(BOOL)theOneCandidate
                          andIsIta:(BOOL)isIta
                     andIsExternal:(BOOL)isExternal
{
    self = [super init];
    {
        self.firstNameFirst= firstNameFirst;
        self.isOneCandidate = theOneCandidate;
        self.isExternal = isExternal;
        self.isIta = isIta;
    }
    return self;
}

@end

@implementation EHCalendarParseResult

- (void)dealloc {
    self.firstName = nil;
    self.lastName = nil;
    self.emailAddress = nil;
}

- (id)initWithName:firstName andLastName:lastName
{
    self  = [super init];
    if (self)
    {
        _firstName = firstName;
        _lastName = lastName;
    }
    return self;
}

@end


@implementation EHEventsGetInfoParser

-(id)init
{
    self = [super init];
    if (self)
    {
        self.calEventParser = [[EHCalendarEventsParser alloc] init];
        EHAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _managedObjectContext = [appDelegate managedObjectContext];
        _events = [NSArray array];
    }
    return  self;
}


#pragma mark Define Type of interview
- (void)canDefineTypeAsITA:(NSString *)string
{
    self.parseOptions.isIta = NO;
    NSError *error = NULL;
    NSString *pattern = @"ita|it academy|itacademy";
    
    NSRange range = NSMakeRange(0, string.length);
    
    
    NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:regexOptions
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:string options:(NSMatchingOptions)regexOptions range:range];
    if ([matches count] > 0)
    {
        self.parseOptions.isIta = YES;
    }
}

- (void)canDefineTypeAsExternal:(NSString *)string
{
    
    NSError *error = NULL;
    NSString *pattern = @"technical";
    
    NSRange range = NSMakeRange(0, string.length);
    
    
    NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:regexOptions
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:string options:(NSMatchingOptions)regexOptions range:range];
    if (([matches count] > 0)||(self.parseOptions.isOneCandidate))
    {
        self.parseOptions.isExternal = YES;
        self.parseOptions.isIta = NO;
    }
}

- (NSNumber *)canDefineTypeOfEvent:(EKEvent *)event
{
    [self canDefineAmountCandidates:event.title];
    [self canDefineTypeAsITA:event.title];
    [self canDefineTypeAsExternal:event.title];
    NSInteger type;
    if (self.parseOptions.isIta)
        type = 1;
    else if (self.parseOptions.isExternal)
        type = 3;
    else
        type = 0;
    
    return [NSNumber numberWithInt:type];
}

- (void)canDefineAmountCandidates:(NSString *)string
{
    _parseOptions.isOneCandidate = YES;
    NSError *error = NULL;
    NSString *pattern = @"candidates";
    
    NSRange range = NSMakeRange(0, string.length);
    
    
    NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:regexOptions
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:string options:(NSMatchingOptions)regexOptions range:range];
    if ([matches count] > 0)
    {
        _parseOptions.isOneCandidate = NO;
        _parseOptions.isExternal = YES;
    }
}

#pragma mark Get people from event
- (Recruiter *)getRecruiterFromEvent:(EKEvent *)event andAddToDB:(NSManagedObjectContext *)context
{
    ///////////////////////////recruiter///////////////////
    EKParticipant *oranizer = event.organizer;
    NSString * name = oranizer.name;
    NSString * email = @"unknown@unknown.com";
    if ([oranizer respondsToSelector:@selector(emailAddress)]) {
        email = [oranizer performSelector:@selector(emailAddress)];
    }
    
    EHCalendarParseResult * parseNameAndLastnameOfRecruiter = [self getNameOfRecruiter:name
                                                                       andEmailAddress:email];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[Recruiter entityName]
                                              inManagedObjectContext:context];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"email == %@",email];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    
    if(fetchedObjects.count>0)// we don't need this actually
    {
        for (Recruiter *info in fetchedObjects)
        {
            return info;
        }
    }
    else
    {
        Recruiter *recruiter = [NSEntityDescription
                                insertNewObjectForEntityForName:[Recruiter entityName]
                                inManagedObjectContext:context];
        recruiter.firstName = parseNameAndLastnameOfRecruiter.firstName;
        recruiter.lastName = parseNameAndLastnameOfRecruiter.lastName;
        recruiter.email = email;
        recruiter.skypeAccount = @"echo";
        NSString * urlString = [self callToWebAndGetPictureOfRecruiterWithName:recruiter.firstName andLastName:recruiter.lastName];
        if (urlString != nil)
        {
            recruiter.photoUrl = urlString;
        }
        NSString *skype = [self callToWebAndGetSkypeOfRecruiterfromName:(NSString *)recruiter.firstName
                                                               lastname:(NSString*)recruiter.lastName];
        if (skype != nil)
        {
            recruiter.skypeAccount = skype;
        }
        
        
        
        return recruiter;
    }
    return nil;
}

- (NSString *)callToWebAndGetPictureOfRecruiterWithName: (NSString *)firstName andLastName:(NSString *)lastName
{
    NSError *error;
    
    
    NSString *patternLastnameFirst = [NSString stringWithFormat:@"(<img src(.)*softserve(.)*/%@-%@(.)*png.>)|",lastName,firstName];
    NSString *patternFirstnameFirst =[NSString stringWithFormat:@"(<img src(.)*softserve.ua(.)*/%@-%@(.)*png.>)",firstName,lastName];
    NSString *pattern = [patternLastnameFirst stringByAppendingString:patternFirstnameFirst];
    
    
    NSString *getWebInfo = @"https://softserve.ua/ru/vacancies/recruiters/?tax-directions=0&tax-country=117"; /// softserve.ua all recruiters from ukraine
    NSString *getWebInfo2 = @"https://softserve.ua/ru/vacancies/recruiters/page/2/?tax-directions=0&tax-country=117";
    
    NSURL *webUnFormatted = [NSURL URLWithString:getWebInfo];
    NSURL *webUnFormatted2 = [NSURL URLWithString:getWebInfo2];
    // //  NSString *pattern = "<img src="https://softserve.ua/wp-content/uploads/2014/01/Tetyana-Klyuk11-150x150.png">" /// example of content with image link
    NSString * webFormatted;
    NSString * webFormatted2;
    
    @try
    {
        webFormatted = [NSString stringWithContentsOfURL:webUnFormatted encoding:NSASCIIStringEncoding error:&error];
        webFormatted2 = [NSString stringWithContentsOfURL:webUnFormatted2 encoding:NSASCIIStringEncoding error:&error];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception);
    }
    
    
    if (webFormatted !=nil && webFormatted != nil)
    {
        NSString *webContent = [NSString stringWithFormat:@"%@",webFormatted]; // web page content
        webContent = [webContent stringByAppendingString:[NSString stringWithFormat:@" %@",webFormatted2]]; // web page content
        NSRange range = NSMakeRange(0, webContent.length);
        
        NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:regexOptions error:&error];
        NSArray *matches = [regex matchesInString:webContent options:(NSMatchingOptions)regexOptions range:range];
        
        NSString * neededString;
        NSMutableArray *results = [[NSMutableArray alloc]init];
        if ([matches count] > 0)
        {
            for (NSTextCheckingResult *match in matches)
            {
                NSRange matchRange = match.range;
                matchRange.length -= 1;
                [results addObject:[webContent substringWithRange:matchRange]];
            }
            
            NSArray* parseWithSpaces = [results[0] componentsSeparatedByString: @"\""]; // separation  with  "
            neededString = parseWithSpaces[0];
            for (int i = 0; i < parseWithSpaces.count;i++)
            {
                if (neededString.length < [parseWithSpaces[i] length])
                {
                    neededString = parseWithSpaces[i]; // the url of picture
                }
            }
            
            return neededString;
        }
        else
        {
            return  nil;
        }
    }
    else
    {
        return  nil;
    }
}




- (NSString *) callToWebAndGetSkypeOfRecruiterfromName:(NSString *)name
                                              lastname:(NSString*)lastname
{
    NSError *error;
    
    
    NSString *getWebInfo = @"https://softserve.ua/ru/vacancies/recruiters/?tax-directions=0&tax-country=117"; /// softserve.ua all recruiters from ukraine
    NSString *getWebInfo2 = @"https://softserve.ua/ru/vacancies/recruiters/page/2/?tax-directions=0&tax-country=117";
    
    NSURL *webUnFormatted = [NSURL URLWithString:getWebInfo];
    NSURL *webUnFormatted2 = [NSURL URLWithString:getWebInfo2];
    // //  NSString *pattern = "<img src="https://softserve.ua/wp-content/uploads/2014/01/Tetyana-Klyuk11-150x150.png">" /// example of content with image link
    NSString * webFormatted;
    NSString * webFormatted2;
    @try
    {
        webFormatted = [NSString stringWithContentsOfURL:webUnFormatted encoding:NSASCIIStringEncoding error:&error];
        webFormatted2 = [NSString stringWithContentsOfURL:webUnFormatted2 encoding:NSASCIIStringEncoding error:&error];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception);
    }
    
    
    if (webFormatted !=nil && webFormatted != nil)
    {
        NSString *webContent = [NSString stringWithFormat:@"%@",webFormatted]; // web page content
        webContent = [webContent stringByAppendingString:[NSString stringWithFormat:@" %@",webFormatted2]]; // web page content
        
        NSString *pattern = [NSString stringWithFormat:@"(a href=(.)*%@.)|(a href=(.)*%@.)",name,lastname];
        NSRange range = NSMakeRange(0, webContent.length);
        
        NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:regexOptions error:&error];
        NSArray *matches = [regex matchesInString:webContent options:(NSMatchingOptions)regexOptions range:range];
        
        NSString * neededString;
        NSMutableArray *results = [[NSMutableArray alloc]init];
        if ([matches count] > 0)
        {
            for (NSTextCheckingResult *match in matches)
            {
                NSRange matchRange = match.range;
                matchRange.length -= 1;
                [results addObject:[webContent substringWithRange:matchRange]];
            }
            
            NSArray* parseWithSpaces = [results[0] componentsSeparatedByString: @"\""]; // separation  with  "
            neededString = parseWithSpaces[0];
            for (int i = 0; i < parseWithSpaces.count;i++)
            {
                if (neededString.length < [parseWithSpaces[i] length])
                {
                    neededString = parseWithSpaces[i]; // the url
                }
            }
            
            return   [self getSkypeFromUrl:neededString];
            
        }
    }
    return nil;
}





-(NSString *)getSkypeFromUrl:(NSString *) skypeUrl
{
    
    
    NSURL *webUnFormatted = [NSURL URLWithString:skypeUrl];
    
    NSString * webFormatted;
    
    NSError *error;
    @try
    {
        webFormatted = [NSString stringWithContentsOfURL:webUnFormatted encoding:NSASCIIStringEncoding error:&error];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception);
    }
    
    
    if (webFormatted !=nil && webFormatted != nil)
    {
        NSString *webContent = [NSString stringWithFormat:@"%@",webFormatted]; // web page content
        
        NSString * pat = @"<((.)*)skype((.)*)[^>]*((.)*)((.)*)>";//(.)*^((.))*<[^>]*((.)*)>";
        
        NSRange range = NSMakeRange(0, webContent.length);
        
        NSRegularExpressionOptions regexOptions2 = NSRegularExpressionCaseInsensitive;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pat
                                                                               options:regexOptions2
                                                                                 error:&error];
        NSArray *matches2 = [regex matchesInString:webContent
                                           options:(NSMatchingOptions)regexOptions2
                                             range:range];
        
        NSString * neededString;
        NSMutableArray *results = [[NSMutableArray alloc]init];
        if ([matches2 count] > 0)
        {
            for (NSTextCheckingResult *match in matches2)
            {
                NSRange matchRange = match.range;
                
                NSRange r = NSMakeRange(matchRange.length + matchRange.location,70  );
                [results addObject:[webContent substringWithRange:r]];
            }
            
            
            
            
            NSArray* words = [results[0] componentsSeparatedByCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString* nospacestring = [words componentsJoinedByString:@""];
            [nospacestring stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray* parseWithSpaces = [nospacestring componentsSeparatedByCharactersInSet:
                                        [NSCharacterSet characterSetWithCharactersInString:@"<>"]]; // separation  with  "
            neededString = parseWithSpaces[0];
            for (int i = 0; i < parseWithSpaces.count;i++)
            {
                if (neededString.length < [parseWithSpaces[i] length])
                {
                    neededString = parseWithSpaces[i]; // the url
                }
            }
            return neededString;
            
        }
    }
    
    
    
}


-(Candidate *)getCandidateFromEvent:(EKEvent *)event andAddToDB:(NSManagedObjectContext *)context
{
    Candidate *candidateResult;
    EHCalendarParseResult *result = [self getNameOfCandidateFromTitle:event.title];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[Candidate entityName]
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName == %@ AND lastName == %@ ",result.firstName,result.lastName];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    if (fetchedObjects.count > 0)// we don't need this actually
    {
        for (Candidate *candidate in fetchedObjects)
        {
            candidateResult = candidate;
            NSLog(@"found %lu candidates with name %@ and last name %@", (unsigned long)fetchedObjects.count,result.firstName,result.lastName);
        }
    }
    else
    {
        candidateResult = [NSEntityDescription insertNewObjectForEntityForName:[Candidate entityName]
                                                        inManagedObjectContext:context];
        candidateResult.firstName = result.firstName;
        candidateResult.lastName = result.lastName;
    }
    return candidateResult;
}

- (NSArray *)getNamesOfCandidatesFromNote:(NSString *)string
{
    NSError *error = NULL;
    NSMutableArray *results = [[NSMutableArray alloc ]initWithCapacity:0];
    NSMutableArray *stringResults = [[NSMutableArray alloc] init];
    
    if (string != nil)
    {
        
        NSString *pat4 = @"([A-Z]([a-z'-]*))([-']*[A-Z]*[a-z']*)*\\s([A-Z]([a-z'-]*))([-']*[A-Z]*[a-z']*)*\\s*"; // pattern of search
        
        NSRange range = NSMakeRange(0, string.length);
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pat4 options:0 error:&error];
        NSArray *matches = [regex matchesInString:string options:NSMatchingReportCompletion range:range];
        
        for (NSTextCheckingResult *match in matches)
        {
            NSRange matchRange = match.range;
            matchRange.length -= 1;
            [results addObject:[string substringWithRange:matchRange]];
        }
        
        EHCalendarParseResult *parseResult ;
        
        for (NSString *str in results)
        {
            NSArray *parseWithSpaces = [str componentsSeparatedByString:@" "];
            if (_parseOptions.firstNameFirst == YES)
            {
                NSString *firstName = parseWithSpaces[0];
                NSString *lastName = parseWithSpaces[1];
                parseResult = [[EHCalendarParseResult alloc] initWithName:firstName andLastName:lastName];
            }
            else
            {
                NSString *firstName = parseWithSpaces[1];
                NSString *lastName = parseWithSpaces[0];
                parseResult = [[EHCalendarParseResult alloc] initWithName:firstName andLastName:lastName];
            }
            [stringResults addObject:parseResult];
        }
    }
    return stringResults;
}

-(InterviewAppointment *)addEventToDB:(EKEvent *)event
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    InterviewAppointment *interview = [NSEntityDescription
                                       insertNewObjectForEntityForName:[InterviewAppointment entityName]
                                       inManagedObjectContext:context];
    
    interview.startDate = event.startDate;
    interview.location = event.location;
    interview.type = [self canDefineTypeOfEvent:event];
    interview.eventId = event.eventIdentifier;
    
    
    interview.url = [NSString stringWithContentsOfURL:event.URL encoding:NSASCIIStringEncoding error:nil];
    
    
    /// add recruiter
    Recruiter *recruiter = [self getRecruiterFromEvent:event andAddToDB:context];
    [recruiter.interviewsSet addObject:interview];
    interview.idRecruiter = recruiter;
    
    // add candidate
    Candidate *candidate = [self getCandidateFromEvent:event andAddToDB:context];
    ExternalInterview *externalInterview = [NSEntityDescription
                                            insertNewObjectForEntityForName:[ExternalInterview entityName]
                                            inManagedObjectContext:context];
    externalInterview.idCandidate = candidate;
    
    [candidate.idExternalInterviewSet addObject:externalInterview];
    interview.idExternal = externalInterview;
    
    externalInterview.idInterview = interview;
    
    NSString *eventID = event.eventIdentifier;
    NSString *eventURL = [@"myApp/" stringByAppendingString:eventID];
    
    EKEvent *eventChange = [_calEventParser.eventStore eventWithIdentifier:eventID];
    if (eventChange)
    {
        eventChange.URL = [NSURL URLWithString: eventURL];
        [_calEventParser.eventStore saveEvent:eventChange span:EKSpanThisEvent commit:YES error:nil];
    }
    interview.url = eventURL;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        
    }
    return interview;
}


- (NSArray *)parseAllEventsToInterviews
{
   [_calEventParser checkEventStoreAccessForCalendar];  // Check whether we are authorized to access Calendar
    
    
    if(_calEventParser.eventsList.count > 0)
    {
        _events = _calEventParser.eventsList;
    }
    
    EHCalendarParseOptions *options = [[EHCalendarParseOptions alloc] init];
    options.firstNameFirst = NO;
    _parseOptions = options;
    
    NSMutableArray *allInterviews = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (EKEvent *event in _events)
    {
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[InterviewAppointment entityName]
                                                  inManagedObjectContext:context];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventId == %@", event.eventIdentifier];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setEntity:entity];
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
        
        if(fetchedObjects.count > 0)// we don't need this actually
        {
            for (InterviewAppointment *interview in fetchedObjects)
            {
                [allInterviews addObject:interview];
            }
        }
        else // there is no interview? let's add it
        {
            InterviewAppointment *interview =  [self addEventToDB:event];
            [allInterviews addObject:interview];
        }
    }
    return allInterviews;
}



- (NSArray *)sortAllInterviewsToDictionary
{
    NSArray *allInterviews = [self parseAllEventsToInterviews];
    NSMutableArray *allMonthes = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (InterviewAppointment *interview in allInterviews)
    {
        unsigned int compon = NSYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekdayCalendarUnit;
        
        /// find num of week in month
        NSDateComponents *components = [[NSCalendar currentCalendar] components:compon fromDate:interview.startDate];
        NSInteger day = [components day];
        
        NSInteger dayofweek =[[[NSCalendar currentCalendar] components: compon fromDate:interview.startDate] weekday] - 1;
        if(dayofweek == 0) dayofweek = 7;
        NSInteger starOfWeek = day - dayofweek + 1;
        NSInteger endOfWeek = day + (5 - dayofweek);
        if (starOfWeek <= 0) starOfWeek = 1;
        NSRange days = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                                          inUnit:NSMonthCalendarUnit
                                                         forDate:interview.startDate];
        if (endOfWeek >= days.length) endOfWeek = days.length;
        
        
        NSInteger monthday = [[[NSCalendar currentCalendar] components: compon fromDate:interview.startDate] month];
        NSInteger yearday =[[[NSCalendar currentCalendar] components: compon fromDate:interview.startDate] year];
        
        NSString *key = [MONTHS objectAtIndex:monthday - 1];
        
        NSString *keyForDictionary = [MONTHS objectAtIndex:monthday - 1];
        keyForDictionary = [keyForDictionary stringByAppendingString:[NSString stringWithFormat: @", %d", yearday]];
        
        EHMonth *curMonth;
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF.nameOfMonth LIKE[cd] %@", keyForDictionary];
        NSArray *filtered1 = [allMonthes filteredArrayUsingPredicate:predicate1];
        if (filtered1.count == 0)
        {
            curMonth = [[EHMonth alloc]init];
            curMonth.nameOfMonth = keyForDictionary;
            curMonth.dateStartOfMonth = interview.startDate;
            [allMonthes addObject: curMonth];
        }
        else
        {
            NSUInteger index = [allMonthes indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                if ([[(EHMonth *)obj nameOfMonth] isEqualToString:keyForDictionary]) {
                    *stop = YES;
                    return YES;
                }
                return NO;
            }];
            
            curMonth = [allMonthes objectAtIndex:index];
        }
        
        key = [key stringByAppendingString:[NSString stringWithFormat:@", %d - %d ", starOfWeek, endOfWeek]];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.nameOfWeek LIKE[cd] %@", key];
        NSArray *filtered = [curMonth.weeks filteredArrayUsingPredicate:predicate];
        EHWeek *curWeek ;
        if (filtered.count == 0)
        {
            curWeek = [[EHWeek alloc]init];
            curWeek.nameOfWeek = key;
            NSMutableArray * arrInterviws = [curWeek.interviews mutableCopy];
            [arrInterviws addObject: interview];
            curWeek.interviews = arrInterviws;
            
            NSMutableArray * arr = [curMonth.weeks mutableCopy];
            [arr addObject: curWeek];
            curMonth.weeks = arr;
        }
        else
        {
            NSUInteger index = [curMonth.weeks  indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                if ([[(EHWeek *)obj nameOfWeek] isEqualToString:key]) {
                    *stop = YES;
                    return YES;
                }
                return NO;
            }];
            
            curWeek = [curMonth.weeks objectAtIndex:index];
            
            NSMutableArray * arr = [curWeek.interviews mutableCopy];
            [arr addObject: interview];
            curWeek.interviews = arr;
        }
    }
    
    
    
    NSArray *unsortedDays = allMonthes;
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateStartOfMonth"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedDays;
    sortedDays = [unsortedDays sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedDays;
}

- (EHCalendarParseResult *)getNameOfRecruiter:(NSString *)string andEmailAddress:(NSString *) email
{
    EHCalendarParseResult *parseResult = [[EHCalendarParseResult alloc]init];;
    NSArray *parseWithSpaces = [string componentsSeparatedByString:@" "];
    if (parseWithSpaces.count == 0) parseResult = [[EHCalendarParseResult alloc] initWithName:@"1" andLastName:@"1"];
    if (parseWithSpaces.count == 1) parseResult = [[EHCalendarParseResult alloc] initWithName:parseWithSpaces[0] andLastName:@"1"];
    if (parseWithSpaces.count > 1)
    {
        if (_parseOptions.firstNameFirst == YES)
        {
            NSString *firstName = parseWithSpaces[0];
            NSString *lastName = parseWithSpaces[1];
            parseResult = [[EHCalendarParseResult alloc] initWithName:firstName andLastName:lastName];
        }
        else if (_parseOptions.firstNameFirst == NO)
        {
            NSString *firstName = parseWithSpaces[1];
            NSString *lastName = parseWithSpaces[0];
            parseResult = [[EHCalendarParseResult alloc] initWithName:firstName andLastName:lastName];
        }
    }
    return parseResult;
}

- (EHCalendarParseResult *)getNameOfCandidateFromTitle:(NSString *)string
{
    NSError *error = NULL;
    NSMutableArray *results = [[NSMutableArray alloc ]initWithCapacity:0];
    
    NSString *pat3 = @"\\s*[w|W]ith(?![Candidate|candidates|Candidates|ITA|ita|ITA|candidate])\\s*([A-Z][a-z'-]*)(\\s*[A-Z]*[a-z']*)\\s([A-Z][a-z'-]*)(\\s*[A-Z]*[a-z']*)*\\s*";
    NSRange range = NSMakeRange(0, string.length);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pat3 options:0 error:&error];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportCompletion range:range];
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = match.range;
        matchRange.location += 6; // 6 = length of "with "
        matchRange.length -= 6;
        [results addObject:[string substringWithRange:matchRange]];
    }
    
    EHCalendarParseResult *parseResult ;
    if (results.count == 1)
    {
        NSArray *parseWithSpaces = [results[0] componentsSeparatedByString:@" "];
        if (_parseOptions.firstNameFirst == YES)
        {
            NSString *firstName = parseWithSpaces[0];
            NSString *lastName = parseWithSpaces[1];
            parseResult = [[EHCalendarParseResult alloc] initWithName:firstName andLastName:lastName];
        }
        else{
            NSString *firstName = parseWithSpaces[1];
            NSString *lastName = parseWithSpaces[0];
            parseResult = [[EHCalendarParseResult alloc] initWithName:firstName andLastName:lastName];
        }
    }
    else {
        parseResult = [[EHCalendarParseResult alloc] initWithName:@"Unknown" andLastName:@"Unknown"];
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

@end

