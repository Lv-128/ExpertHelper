//
//  EHRoundedTextView.m
//  ExpertHelper
//
//  Created by nvlizlo on 10.12.14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHRoundedTextView.h"

@implementation EHRoundedTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 7;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
