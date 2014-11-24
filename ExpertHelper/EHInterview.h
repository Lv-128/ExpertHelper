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


@property (strong, nonatomic) NSArray * nameAndLastNameOfCandidates;
@property (strong, nonatomic) NSString * nameOfRecruiter;
@property (strong, nonatomic) NSString * lastNameOfRecruiter;
@property (strong, nonatomic) NSDate * dateOfInterview;
@property (strong, nonatomic) NSString * locationOfInterview;
@property (nonatomic, strong) NSString * typeOfInterview;


@end
