//
//  EHSkillsProfilesParser.m
//  ExpertHelper
//
//  Created by Katolyk S. on 12/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHSkillsProfilesParser.h"

@implementation EHGroups
-(id)init
{
    self = [super init];
    if (self)
    {
        _skills = [NSArray array];
    }
    return self;
}

- (void)dealloc {
    self.skills = nil;
    self.nameOfSections = nil;
}

@end

@implementation EHSkill
-(id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void)setEstimate:(NSString *)estimate
{
    _estimate = estimate;
}

- (void)dealloc {
    self.estimate = nil;
    self.nameOfSkill = nil;
    self.comment = nil;
}

@end

@implementation EHGenInfo
-(id)init
{
    self = [super init];
    if (self)
    {
        _records = [NSArray array];
    }
    return self;
}

- (void)dealloc {
    self.expertName = nil;
    self.dateOfInterview = nil;
    self.competenceGroup = nil;
    self.typeOfProject = nil;
    self.techEnglish = nil;
    self.recommendations = nil;
    self.skillsSummary = nil;
    self.potentialCandidate = nil;
    self.potentialCandidate = nil;
    self.levelEstimate = nil;
    self.records = nil;
}

@end


@implementation EHSkillsProfilesParser

@end
