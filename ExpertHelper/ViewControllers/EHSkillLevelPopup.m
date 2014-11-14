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
    [_delegate skillLevelPopup:self didSelectLevel:EHSkillLevelNone];
}


- (IBAction)goToComment:(UIButton *)sender {
    [_delegate skillLevelPopupDidSelectComment:self];
}
@end