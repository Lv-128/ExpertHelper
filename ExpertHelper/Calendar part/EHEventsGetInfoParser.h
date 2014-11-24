//
//  EHEventsGetInfoParser.h
//  ExpertHelper
//
//  Created by alena on 11/19/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHCalendarEventsParser.h"
#import "EHInterview.h"

@interface EHMonth : NSObject

@property (nonatomic, strong) NSDate *dateStartOfMonth;
@property (nonatomic, copy) NSArray *weeks;
@property (nonatomic, strong) NSString *nameOfMonth;

@end





@interface EHWeek : NSObject

@property (nonatomic, copy) NSArray *interviews;
@property (nonatomic, strong) NSString *nameOfWeek;

@end





@interface EHCalendarParseResult : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString * emailAddress;

-(id)initWithName:firstName andLastName:lastName;

@end






@interface EHCalendarParseOptions : NSObject

@property (nonatomic, assign) BOOL firstNameFirst;
@property (nonatomic, assign) bool isOneCandidate;
@property (nonatomic, assign) bool isIta;


@end

@interface EHEventsGetInfoParser : NSObject

@property (strong , nonatomic) NSArray *namesMonth;
@property (nonatomic, strong) EHCalendarParseOptions *parseOptions;
@property (nonatomic, copy) NSArray *interviews;
@property (nonatomic, copy) NSArray *events;

- (void)canDefineTypeAsITA:(NSString *)string;
- (EHCalendarParseResult *)getNameOfCandidateFromTitle:(NSString *)string;
- (EHCalendarParseResult *)getNameOfRecruiter:(NSString*)string andEmailAddress :(NSString *) email;
- (id)initWithObjection:(EHCalendarParseOptions *)options;
- (NSArray *) parseAllEventsToInterviews;
- (NSArray *)sortAllInterviewsToDictionary;

@property (nonatomic , strong) EHCalendarEventsParser *calEventParser;
@end

