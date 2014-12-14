//
//  EHInterview.h
//  ExpertHelper
//
//  Created by alena on 11/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EHInterview : NSObject


@property (copy, nonatomic) NSArray *nameAndLastNameOfCandidates;
@property (copy, nonatomic) NSString *nameOfRecruiter;
@property (copy, nonatomic) NSString *lastNameOfRecruiter;
@property (strong, nonatomic) NSDate *dateOfInterview;
@property (copy, nonatomic) NSString *locationOfInterview;
@property (nonatomic, copy) NSString *typeOfInterview;
@property (nonatomic,copy) NSURL *url;


@end
