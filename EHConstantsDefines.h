//
//  EHConstantsDefines.h
//  ExpertHelper
//
//  Created by alena on 12/3/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//
#import "InterviewAppointment.h"
#import "ExternalInterview.h"
#import "ITAInterview.h"
#import "Skills.h"
#import "SkillsLevels.h"
#import "Recruiter.h"
#import "Candidate.h"
#import "Group.h"
#import "GeneralInfo.h"
#import "VoiceRecorders.h"
#import "Reachability.h"
#import "EHCheckNetworkConnection.h"
#import "AudioRecord.h"
#import "QuickComment.h"

#import "EHExternalViewController.h"
#import <MessageUI/MessageUI.h>
#import "EHRecruitersViewController.h"



#import "EHEventsGetInfoParser.h"
#import "EHInterviewViewCell.h"
#import "EHFacebookPopoverViewController.h"
#import "EHRecruiterViewController.h"
#import "EHListOfInterviewsViewController.h"

#import "EHRecruiterViewController.h"
#import "EHITAViewController.h"
#import "EHListOfInterviewsViewController.h"
#import "EHCalendarEventsParser.h"
#import "EHEventsGetInfoParser.h"

id interviewFromEventsParser;

#ifndef ExpertHelper_EHConstantsDefines_h
#define ExpertHelper_EHConstantsDefines_h
#define  MONTHS [NSMutableArray arrayWithObjects:@"January",@"February", @"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil]
#define  INTERVIEWTYPE [NSArray arrayWithObjects:@"None", @"IT Academy",@"Internal",@"External", nil]
#define  ESTIMATES [NSMutableArray arrayWithObjects:@"None", @"Low", @"Middle", @"Strong", nil]
#endif





