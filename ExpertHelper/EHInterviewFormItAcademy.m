//
//  EHInterviewFormItAcademy.m
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 11/20/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

/*

#import "EHInterviewFormItAcademy.h"
@implementation EHInterviewFormItAcademy

-(id) initWithInterview: (EHInterview*) interview
TypeOfInterview: (NSString *)interviewType
ScoresArray: (NSMutableArray *) arrayOfScores
CandidateAchivement: (NSMutableArray *) arrayOfPass

{
    self= [super init];
    {
        _interview = interview;
        _interviewType = interviewType;
        _interviewFormId = [self GenerateInterviewFormId];
        _arrayOfScores = arrayOfScores;
        _arrayOfPass = arrayOfPass;
    }

    return self;
}

-(id) init
{
    self= [super init];
    return self;
}

- (void)dealloc {
   _interviewType = nil;
   _interview = nil;
   _interviewFormId = nil;
   _arrayOfScores = nil;
    _arrayOfPass = nil;
}


-(NSInteger *) GenerateInterviewFormId {
    NSString *s = [_interview nameOfCandidate];
    s = [s stringByAppendingString:[_interview lastNameOfCandidate]];
    return (NSInteger *)[s hash];
}

@end


*/