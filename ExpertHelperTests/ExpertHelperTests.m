//
//  ExpertHelperTests.m
//  ExpertHelperTests
//
//  Created by Katolyk S. on 10/31/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EHCalendarEventsParser.h"

@interface ExpertHelperTests : XCTestCase

@end

@implementation ExpertHelperTests

- (void)testExample1 {
    EHCalendarParseOptions *options = [[EHCalendarParseOptions alloc] init];
    options.firstNameFirst = NO;
    EHCalendarEventsParser *parser = [[EHCalendarEventsParser alloc] initWithObjection:options];
    EHCalendarParseResult *result = [parser getNameOfCandidateFromTitle:@"Technical interview with Kirichok Stanislav"];
    XCTAssertEqual(result.firstName, @"Stanislav");
    XCTAssertEqual(result.lastName, @"Kirichok");
}

- (void)testExample2 {
    EHCalendarParseOptions *options = [[EHCalendarParseOptions alloc] init];
    options.firstNameFirst = YES;
    EHCalendarEventsParser *parser = [[EHCalendarEventsParser alloc] initWithObjection:options];
    EHCalendarParseResult *result = [parser getNameOfCandidateFromTitle:@"Interview with Stepan Bura"];
    XCTAssertEqual(result.firstName, @"Stepan");
    XCTAssertEqual(result.lastName, @"Bura");
}


@end
