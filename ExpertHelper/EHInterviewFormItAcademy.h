//
//  EHInterviewFormItAcademy.h
//  ExpertHelper
//
//  Created by Oleksandr Shymanskyi on 11/20/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHInterviewForm.h"
#import "EHInterview.h"

@interface EHInterviewFormItAcademy : NSObject<EHInterviewForm>

@property (nonatomic, copy) NSString* interviewType;
@property (nonatomic, strong) EHInterview* interview;
@property (nonatomic) NSInteger * interviewFormId;
@property (nonatomic, copy) NSMutableArray * arrayOfScores;
@property (nonatomic, copy) NSMutableArray * arrayOfPass;


-(NSInteger *) GenerateInterviewFormId;

@end
