//
//  EHExternalInterviewToDBSaver.m
//  ExpertHelper
//
//  Created by Katolyk S. on 12/11/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHExternalInterviewToDBSaver.h"

@implementation EHExternalInterviewToDBSaver



- (id)initWithDataToSave:(NSArray *)dataToSave andInterview:(InterviewAppointment *)interview
{
    self = [super init];
    if(self)
    {
        _dataToSave = dataToSave;
        _interview = interview;
        _externalInterview = interview.idExternal;
    }
    return self;
}

@end
