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
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSMutableArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;

@property (strong , nonatomic) NSArray *namesMonth;

// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@property (nonatomic, strong) NSMutableArray *eventsList;

- (NSMutableArray *)fetchEvents;
-(void)checkEventStoreAccessForCalendar;
@end
