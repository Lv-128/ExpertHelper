//
//  EHSkillLevelCommentPopup.m
//  ExpertHelper
//
//  Created by Katolyk S. on 11/17/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHSkillLevelCommentPopup.h"

@implementation EHSkillLevelCommentPopup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)onHide:(UIButton *)sender {
    [_delegate skillLevelCommentPopup:self didSelectLevel:EHSkillLevelCommentNone];
}

- (IBAction)goToComment:(UIButton *)sender {
    [_delegate skillLevelCommentPopupDidSelectComment:self];
}
@end
