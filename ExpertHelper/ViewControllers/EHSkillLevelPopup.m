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

@synthesize goToComments;


- (IBAction)onHide:(id)sender {
    
    [_delegate skillLevelPopup:self didSelectLevel:EHSkillLevelNone];
    //UINib *nib = [UINib nibWithNibName:@"EHSkillLevelPopup" bundle:nil];
    //UIView *popup = [[nib instantiateWithOwner:self options:nil] lastObject];
    
    [UIView animateWithDuration:0.85 animations:^{
        //popup.transform = CGAffineTransformMakeScale(0, 0);
        //popup.alpha = 0.0;
        
        CGRect f = self.frame;
        //CGPoint xmin = CGPointMake(CGRectGetMinX(f), CGRectGetMinY(f));
        //CGPoint xmax = CGPointMake(CGRectGetMaxX(f), CGRectGetMaxY(f));
        f.origin.y += f.size.height;
        //f.origin.x += f.size.width;
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

- (IBAction)goToComment:(UIButton *)sender {
    [_delegate skillLevelPopupDidSelectComment:self];
    goToComments = YES;
}
@end
