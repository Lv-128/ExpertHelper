//
//  ExpertHelperTests.m
//  ExpertHelperTests
//
//  Created by Katolyk S. on 10/31/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EHCalendarEventsParser.h"
#import "EHEventsGetInfoParser.h"
@interface ExpertHelperTests : XCTestCase

@end

@implementation ExpertHelperTests

- (void)testExample1 {
    EHCalendarParseOptions *options = [[EHCalendarParseOptions alloc] init];
    options.firstNameFirst = NO;
    EHEventsGetInfoParser *parser = [[EHEventsGetInfoParser alloc] initWithObjection:options];
    EHCalendarParseResult *result = [parser getNameOfCandidateFromTitle:@"Technical interview with Kirichok Stanislav"];
    XCTAssertEqualObjects(result.firstName, @"Stanislav");
    XCTAssertEqualObjects(result.lastName, @"Kirichok");
}

- (void)testExample2 {
    EHCalendarParseOptions *options = [[EHCalendarParseOptions alloc] init];
    options.firstNameFirst = YES;
    EHEventsGetInfoParser *parser = [[EHEventsGetInfoParser alloc] initWithObjection:options];
    EHCalendarParseResult *result = [parser getNameOfCandidateFromTitle:@"Interview with Stepan Bura"];
    XCTAssertEqualObjects(result.firstName, @"Stepan");
    XCTAssertEqualObjects(result.lastName, @"Bura");
}


@end
