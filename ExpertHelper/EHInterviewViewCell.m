//
//  EHInterviewViewCell.m
//  ExpertHelper
//
//  Created by Katolyk S. on 12/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHInterviewViewCell.h"

@implementation EHInterviewViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [_skypeButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [_mailButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [_startButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}

@end
