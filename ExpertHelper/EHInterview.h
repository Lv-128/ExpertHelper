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

@property (strong, nonatomic) NSString * nameOfCandidate;
@property (strong, nonatomic) NSString * lastNameOfCandidate;
@property (strong, nonatomic) NSDate * dateOfInterview;
@property (strong, nonatomic) NSString * locationOfInterview;
@property (nonatomic) NSInteger id_Interview;
@property (nonatomic, strong) NSString * typeOfInterview;
@property (nonatomic, strong) EKEvent *  curEvent;
@property (nonatomic, strong) NSString * eventTitle;

-(void)getNameOfCandidateFromEventTitle:(NSString * )title;


@end
