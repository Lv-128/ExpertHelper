//
//  EHCalendarEventsParser.h
//  AppointmentList
//
//  Created by alena on 11/1/14.
//  Copyright (c) 2014 Ole Begemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EHCalendarEventsParser : NSObject

@property (strong , nonatomic) NSArray *namesMonth;

@property (nonatomic, strong) EKEventStore *eventStore;// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) NSArray *defaultCalendars;// Default calendar associated with the above event store

@property (nonatomic, strong) NSArray *eventsList;// Array of all events happening within the next 24 hours


-(NSArray * )fetchEvents;

-(void)checkEventStoreAccessForCalendar;

-(NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
-(NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate;

@end
