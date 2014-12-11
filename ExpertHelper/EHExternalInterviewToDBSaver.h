//
//  EHExternalInterviewToDBSaver.h
//  ExpertHelper
//
//  Created by Katolyk S. on 12/11/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHAppDelegate.h"

@interface EHExternalInterviewToDBSaver : NSObject

@property (nonatomic, strong) NSArray  *dataToSave;
@property (nonatomic, strong) InterviewAppointment *interview;
@property (nonatomic, strong) ExternalInterview *externalInterview;

- (id)initWithDataToSave:(NSArray *)dataToSave andInterview:(InterviewAppointment *)interview;

@end
