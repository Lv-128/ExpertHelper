//
//  EHInterview.m
//  ExpertHelper
//
//  Created by alena on 11/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHInterview.h"



@implementation EHEventsGetInfoParser
//
//-(void) parseAllEventsToInterviews
//{
//    NSArray * allMonthes = [NSArray arrayWithObjects:[_interviews allKeys],nil];
//    for (int i=0; i< allMonthes.count; i++)
//    {
//        NSArray * allWeeksOfMonth = [NSArray arrayWithObjects:[[_interviews objectForKey:allMonthes[i]] allKeys]];
//        for (int j=0; j<allWeeksOfMonth.count;j++)
//        {
//            for (EKEvent event in  _interviews objectForKey:<#(id)#>)
//            NSArray * allEvents = [NSArray arrayWithObjects:[ allWeeksOfMonth[j]al] count:<#(NSUInteger)#>]
//        }
//    }
//}
//



-(id)init{
    self = [super init];
    if (self)
    {
        
        _namesMonth = [NSArray arrayWithObjects:@"January",@"February", @"March",@"April",@"May",@"June",@"July",@"August",
                   @"September",@"October",@"November",@"December", nil];
        _events = [NSArray array];
    }
    return  self;
}

-(NSArray *) parseAllEventsToInterviews
{
    EHCalendarParseOptions *options = [[EHCalendarParseOptions alloc] init];
    options.firstNameFirst = NO;
    _parseOptions = options;
    NSMutableArray * allInterviews = [[NSMutableArray alloc]initWithCapacity:0];
    for (EKEvent * event in _events)
    {
        EHInterview * interview = [[EHInterview alloc]init];
        BOOL isIta = [self canDefineTypeAsITA:event.title];
        if (isIta) interview.typeOfInterview = @"ITA";
        else interview.typeOfInterview = @"None";
        
        EHCalendarParseResult * parseNameAndLastnameOfCandidate = [[EHCalendarParseResult alloc]init];
        parseNameAndLastnameOfCandidate = [self getNameOfCandidateFromTitle:event.title];
        interview.nameOfCandidate = parseNameAndLastnameOfCandidate.firstName;
        interview.lastNameOfCandidate = parseNameAndLastnameOfCandidate.lastName;
        
        EHCalendarParseResult * parseNameAndLastnameOfRecruiter = [[EHCalendarParseResult alloc]init];
        parseNameAndLastnameOfRecruiter = [self getNameOfRecruiter:event.organizer.name];
        interview.nameOfRecruiter = parseNameAndLastnameOfRecruiter.firstName;
        interview.lastNameOfRecruiter = parseNameAndLastnameOfRecruiter.lastName;
        
        interview.dateOfInterview = event.startDate;
        
        interview.locationOfInterview = event.location;
        
        [allInterviews addObject:interview];
    }
    return allInterviews;
}



-(NSArray *)sortAllInterviewsToDictionary
{
    NSArray * allInterviews = [self parseAllEventsToInterviews];
    NSMutableDictionary * eventsOfWeekInMonth = [[NSMutableDictionary alloc]init];
    for (EHInterview * interview in allInterviews)
    {
        unsigned int  compon = NSYearCalendarUnit| NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekdayCalendarUnit;
        
        /// find num of week in month
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:interview.dateOfInterview];
        
        NSInteger day = [components day];
        

        
        NSInteger dayofweek =[[[NSCalendar currentCalendar] components: compon fromDate:interview.dateOfInterview] weekday] - 1;
        if(dayofweek == 0) dayofweek =7;
        NSInteger starOfWeek =  day - dayofweek + 1;
        NSInteger endOfWeek = day + (5-dayofweek);
        if (starOfWeek <= 0) starOfWeek = 1;
        NSRange days = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                               inUnit:NSMonthCalendarUnit
                              forDate:interview.dateOfInterview];
        if (endOfWeek>=days.length) endOfWeek = days.length;
     
        
        //NSInteger weekday = [[[NSCalendar currentCalendar] components: compon fromDate:interview.dateOfInterview] weekOfMonth];
        NSInteger monthday = [[[NSCalendar currentCalendar] components: compon fromDate:interview.dateOfInterview] month];
        NSInteger yearday  =[[[NSCalendar currentCalendar] components: compon fromDate:interview.dateOfInterview] year];
        
        NSString * key = [self.namesMonth objectAtIndex:monthday-1];
        
        NSString * keyForDictionary = [self.namesMonth objectAtIndex:monthday-1];
        keyForDictionary = [keyForDictionary stringByAppendingString:[NSString stringWithFormat: @", %d",yearday]];
        
        
        
        key=[key stringByAppendingString:[NSString stringWithFormat:@", week : %d - %d ", starOfWeek, endOfWeek]];
        
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
        [eventsOnThisDay addObject:interview];
    }

    _interviews = eventsOfWeekInMonth;
    NSArray *unsortedDays = [_interviews allKeys];// Create a sorted list of days
    return unsortedDays;

    
}
-(bool)canDefineTypeAsITA:(NSString *)string
{
    bool isIta = NO;
    NSError *error = NULL;
    NSString *pattern = @"ita|it academy|itacademy";
    
    // NSString *string = @"ITA Interview With Alena Pyanyh ita on friday Ita ITA";
    NSRange range = NSMakeRange(0, string.length);
    
    
    NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:regexOptions error:&error];
    NSArray *matches = [regex matchesInString:string options:(NSMatchingOptions)regexOptions range:range];
    if ([matches count]>0)
    {
        isIta = YES;
    }
    
    return isIta;
    
}

- (EHCalendarParseResult *)getNameOfRecruiter:(NSString*)string
{
      EHCalendarParseResult * parseResult = [[EHCalendarParseResult alloc]init];;
      NSArray* parseWithSpaces = [string componentsSeparatedByString: @" "];
   /* if (parseWithSpaces.count > 0)
    {
        if (_parseOptions.firstNameFirst == YES)
        {
            NSString * firstName = parseWithSpaces[0];
            NSString * lastName = parseWithSpaces[1];
            parseResult = [[EHCalendarParseResult alloc] initWithName:firstName andLastName:lastName];
        }
        else if (_parseOptions.firstNameFirst == NO)
        {
            NSString * firstName = parseWithSpaces[1];
            NSString * lastName = parseWithSpaces[0];
            parseResult = [[EHCalendarParseResult alloc] initWithName:firstName andLastName:lastName];
        }
    }
        else {
            parseResult = [[EHCalendarParseResult alloc] initWithName:@"Unknown" andLastName:@"Unknown"];
        }*/
    if (parseWithSpaces.count == 0) parseResult = [[EHCalendarParseResult alloc] initWithName:@"Unknown" andLastName:@"Unknown"];
    if (parseWithSpaces.count == 1) parseResult = [[EHCalendarParseResult alloc] initWithName:parseWithSpaces[0] andLastName:@"Unknown"];
     if (parseWithSpaces.count > 1)
     {
     if (_parseOptions.firstNameFirst == YES)
     {
     NSString * firstName = parseWithSpaces[0];
     NSString * lastName = parseWithSpaces[1];
     parseResult = [[EHCalendarParseResult alloc] initWithName:firstName andLastName:lastName];
     }
     else if (_parseOptions.firstNameFirst == NO)
     {
     NSString * firstName = parseWithSpaces[1];
     NSString * lastName = parseWithSpaces[0];
     parseResult = [[EHCalendarParseResult alloc] initWithName:firstName andLastName:lastName];
     }
     }
 
    
    return parseResult;
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

@implementation EHCalendarParseResult

- (void)dealloc {
    self.firstName = nil;
    self.lastName = nil;
}


-(id)initWithName:firstName andLastName:lastName
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


@implementation EHInterview

-(id) initWithFirstName : (NSString *)firstName
                lastName: (NSString *)lastName
         nameOfRecruiter: (NSString *)nameOfRecruiter
     lastnameOfRecruiter: (NSString *)lastnameOfRecruiter
         dateOfInterview: (NSDate *) dateOfInterview
     locationOfInterview: (NSString *)locationOfInterview
         typeOfInterview:(NSString *)typeOfInterview
{
    self= [super init];
    if (self)
    {
        _nameOfCandidate = firstName;
        _lastNameOfCandidate = lastName;
        _dateOfInterview = dateOfInterview;
        _locationOfInterview  = locationOfInterview;
        _typeOfInterview = typeOfInterview;
        _nameOfRecruiter = nameOfRecruiter;
        _lastNameOfRecruiter = lastnameOfRecruiter;
    }
    return self;
}
- (void)dealloc {
    _nameOfCandidate = nil;
    _lastNameOfCandidate = nil;
    _dateOfInterview=nil;
    _locationOfInterview = nil;
    _typeOfInterview=nil;

    
}

@end



@implementation EHCalendarParseOptions

-(id) initWithOption:(bool) option
{
    self = [super init];
    {
        self.firstNameFirst= option;
    }
    return self;
}

@end
