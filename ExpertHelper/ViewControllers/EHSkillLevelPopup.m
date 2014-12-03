//
//  EHSkillLevelPopup.m
//  ExpertHelper
//
//  Created by Andrii Mamchur on 11/5/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//


#import "EHSkillLevelPopup.h"

@implementation EHSkillLevelPopup

- (IBAction)onHide:(UIButton *)sender {
    _skillLevel = sender.titleLabel.text;
    [_delegate skillLevelPopup:self didSelectLevel:EHSkillLevelNone];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 6;
    self.layer.shadowOpacity = 0.8;
    self.alpha = 0;
}

@end