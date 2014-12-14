//
//  EHSkillLevelCommentPopup.h
//  ExpertHelper
//
//  Created by Katolyk S. on 11/17/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHSkillLevelCommentPopup;

typedef enum : NSUInteger {
    EHSkillLevelCommentNone,
    EHSkillLevelCommentBeginner,
    EHSkillLevelCommentMiddle,
    EHSkillLevelCommentStrong
} EHSkillLevelComment;

@protocol EHSkillLevelCommentPopupDelegate <NSObject>

- (void)skillLevelCommentPopup:(EHSkillLevelCommentPopup *)popup didSelectLevel:(EHSkillLevelComment)level;
- (void)skillLevelCommentPopupDidSelectComment:(EHSkillLevelCommentPopup *)popup;

@end

@interface EHSkillLevelCommentPopup : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)goToComment:(UIButton *)sender;
@property (nonatomic, weak) id<EHSkillLevelCommentPopupDelegate> delegate;

@end
