//
//  EHCalendarEventsParser.h
//  AppointmentList
//
//  Created by alena on 11/1/14.
//  Copyright (c) 2014 Ole Begemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EHCalendarParseResult : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

@end

@interface EHCalendarParseOptions : NSObject

@property (nonatomic, assign) BOOL firstNameFirst;

@end

@interface EHCalendarEventsParser : NSObject

@property (strong , nonatomic) NSArray *namesMonth;

@property (strong, nonatomic) NSMutableDictionary *sections;
@property (copy, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;

@property (nonatomic, strong) EKEventStore *eventStore;// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) EKCalendar *defaultCalendar;// Default calendar associated with the above event store


@property (nonatomic, strong) NSMutableArray *eventsList;// Array of all events happening within the next 24 hours

@property (nonatomic, strong) EHCalendarParseOptions * parseOptions;

- (id)initWithObjection:(EHCalendarParseOptions *)options;

- (EHCalendarParseResult *)parseEventSubject:(NSString *)subject;

- (NSMutableArray *)fetchEvents;

-(void)checkEventStoreAccessForCalendar;

- (EHCalendarParseResult *)getNameOfCandidateFromTitle:(NSString*)string;

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate;

@end
