//
//  EHSkillsProfilesParser.h
//  ExpertHelper
//
//  Created by Katolyk S. on 12/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHAppDelegate.h"

@interface EHGroups : NSObject

@property (nonatomic, strong) NSString *nameOfSections;
@property (nonatomic, copy) NSArray *skills;

@end


@interface EHSkill : NSObject

@property (nonatomic, copy) NSString *nameOfSkill;
@property (nonatomic, copy) NSString *estimate;
@property (nonatomic, copy) NSString *comment;

@end


@interface EHGenInfo : NSObject

@property (nonatomic, strong) NSString *expertName;
@property (nonatomic, strong) NSString *dateOfInterview;
@property (nonatomic, strong) NSString *competenceGroup;
@property (nonatomic, strong) NSString *typeOfProject;
@property (nonatomic, strong) NSString *skillsSummary;
@property (nonatomic, strong) NSString *techEnglish;
@property (nonatomic, strong) NSString *recommendations;
@property (nonatomic, strong) NSString *potentialCandidate;
@property (nonatomic, strong) NSString *levelEstimate;
@property (nonatomic, strong) NSString *hire;
@property (nonatomic, strong) NSArray *records;

@end


@interface EHSkillsProfilesParser : NSObject

@property (nonatomic, copy) NSArray *groups;
@property (nonatomic, copy) EHGenInfo *genInfo;
@property (nonatomic, strong) NSArray  *dataToSave;

@property (nonatomic, strong) InterviewAppointment *interview;
@property (nonatomic, strong) ExternalInterview *externalInterview;

- (id)initWithDataGroups:(NSArray *)groups andInterview:(InterviewAppointment *)interview andGenInfo:(EHGenInfo *)genInfo;

@end
