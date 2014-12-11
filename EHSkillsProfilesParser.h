//
//  EHSkillsProfilesParser.h
//  ExpertHelper
//
//  Created by Katolyk S. on 12/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHAppDelegate.h"
#import "EHAppDelegate.h"

@interface EHGroups : NSObject

@property (nonatomic, copy) NSString *nameOfSections;
@property (nonatomic, copy) NSArray *skills;

@end


@interface EHSkill : NSObject

@property (nonatomic, copy) NSString *nameOfSkill;
@property (nonatomic, copy) NSString *estimate;
@property (nonatomic, copy) NSString *comment;

@end


@interface EHGenInfo : NSObject

@property (nonatomic, copy) NSString *expertName;
@property (nonatomic, strong) NSDate *dateOfInterview;
@property (nonatomic, copy) NSString *competenceGroup;
@property (nonatomic, copy) NSString *typeOfProject;
@property (nonatomic, copy) NSString *skillsSummary;
@property (nonatomic, copy) NSString *techEnglish;
@property (nonatomic, copy) NSString *recommendations;
@property (nonatomic, copy) NSString *potentialCandidate;
@property (nonatomic, copy) NSString *levelEstimate;
@property (nonatomic) BOOL hire;
@property (nonatomic, copy) NSArray *records;

@end


@interface EHSkillsProfilesParser : NSObject

@property (nonatomic, copy) NSArray *groups;
@property (nonatomic, copy) NSArray *dataToSave;

@property (nonatomic, strong) EHGenInfo *genInfo;
@property (nonatomic, strong) InterviewAppointment *interview;
@property (nonatomic, strong) ExternalInterview *externalInterview;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (id)initWithDataGroups:(NSArray *)groups andInterview:(InterviewAppointment *)interview andGenInfo:(EHGenInfo *)genInfo;
- (void)saveInfoToDB;

@end
