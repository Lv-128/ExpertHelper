//
//  EHInterviewForm.h
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 11/20/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHInterview.h"

@protocol EHInterviewForm <NSObject>
@required

@property (nonatomic, copy) NSString* interviewType;
@property (nonatomic, strong) EHInterview* interview;
@property (nonatomic) NSInteger * interviewFormId;

-(NSInteger *) GenerateInterviewFormId;

@end
