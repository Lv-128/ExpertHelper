//
//  EHEventsGetInfoParser.m
//  ExpertHelper
//
//  Created by alena on 11/19/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHEventsGetInfoParser.h"


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
-(id)init
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

-(id) initWithOption:(bool) option
{
    self = [super init];
    {
        self.firstNameFirst= option;
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




@implementation EHEventsGetInfoParser


-(id)init{
    self = [super init];
    if (self)
    {
        self.calEventParser = [[EHCalendarEventsParser alloc] init];
        _namesMonth = [NSArray arrayWithObjects:@"January",@"February", @"March",@"April",@"May",@"June",@"July",@"August",
                       @"September",@"October",@"November",@"December", nil];
        _events = [NSArray array];
        [_calEventParser checkEventStoreAccessForCalendar];  // Check whether we are authorized to access Calendar
        if(_calEventParser.eventsList.count>0)
        {
            _events = _calEventParser.eventsList;
        }
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
        if (isIta)
            interview.typeOfInterview = @"ITA";
        else
            interview.typeOfInterview = @"None";
        
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
    NSMutableArray * allMonthes = [[NSMutableArray alloc] initWithCapacity:0];
    
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
        
        EHMonth * curMonth;
 
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF.nameOfMonth LIKE[cd] %@", keyForDictionary];
        NSArray *filtered1 = [allMonthes filteredArrayUsingPredicate:predicate1];
        if (filtered1.count == 0)
        {
            curMonth = [[EHMonth alloc]init];
            curMonth.nameOfMonth = keyForDictionary;
            curMonth.dateStartOfMonth = interview.dateOfInterview;
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
            
            /*int index = [allMonthes indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){ if(predicate1) {
                
                    *stop = YES;
                    return YES;
                }
                return NO;
           
            }];*/
            curMonth = [allMonthes objectAtIndex:index];
            
      }

        
        
        key=[key stringByAppendingString:[NSString stringWithFormat:@", week : %d - %d ", starOfWeek, endOfWeek]];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.nameOfWeek LIKE[cd] %@", key];
        NSArray *filtered = [curMonth.weeks filteredArrayUsingPredicate:predicate];
        EHWeek * curWeek ;
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
            
           /* int index = [curMonth.weeks indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){ if(predicate) {
                                                                                                                        *stop = YES;
                                                                                                                        return YES;
               }
                                                                                                                        return NO;
                                                                                                                                }];
            */
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


