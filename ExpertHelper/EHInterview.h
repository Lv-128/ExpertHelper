//
//  EHInterview.h
//  ExpertHelper
//
//  Created by alena on 11/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EHCalendarParseResult : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

-(id)initWithName:firstName andLastName:lastName;
@end

@interface EHCalendarParseOptions : NSObject

@property (nonatomic, assign) BOOL firstNameFirst;

@end



@interface EHEventsGetInfoParser : NSObject

@property (strong , nonatomic) NSArray *namesMonth;
@property (nonatomic, strong) EHCalendarParseOptions * parseOptions;
@property (nonatomic, copy) NSDictionary * interviews;
@property (nonatomic, copy) NSArray * events;

-(bool)canDefineTypeAsITA:(NSString *)string;
-(EHCalendarParseResult *)getNameOfCandidateFromTitle:(NSString*)string;
-(id)initWithObjection:(EHCalendarParseOptions *)options;
- (EHCalendarParseResult *)getNameOfRecruiter:(NSString*)string;

-(NSArray *) parseAllEventsToInterviews;
-(NSArray *)sortAllInterviewsToDictionary;
@end



@interface EHInterview : NSObject

@property (strong, nonatomic) NSString * nameOfCandidate;
@property (strong, nonatomic) NSString * lastNameOfCandidate;
@property (strong, nonatomic) NSString * nameOfRecruiter;
@property (strong, nonatomic) NSString * lastNameOfRecruiter;
@property (strong, nonatomic) NSDate * dateOfInterview;
@property (strong, nonatomic) NSString * locationOfInterview;
@property (nonatomic, strong) NSString * typeOfInterview;



@end
