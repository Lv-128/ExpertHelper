//
//  EHSkillLevelPopup.m
//  ExpertHelper
//
//  Created by Andrii Mamchur on 11/5/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHSkillLevelPopup.h"

@implementation EHSkillLevelPopup

- (IBAction)onButtonTap:(id)sender {
}

- (IBAction)onHide:(id)sender {
    [_delegate skillLevelPopupDelegate:self didSelectLevel:0];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect f = self.frame;
        f.origin.y += f.size.height;
        self.frame = f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
