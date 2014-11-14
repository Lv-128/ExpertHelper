//
//  EHSkillLevelPopup.h
//  ExpertHelper
//
//  Created by Andrii Mamchur on 11/5/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHSkillLevelPopup;

typedef enum : NSUInteger {
    EHSkillLevelNone,
    EHSkillLevelBeginner,
    EHSkillLevelMiddle,
    EHSkillLevelStrong
} EHSkillLevel;

@protocol EHSkillLevelPopupDelegate <NSObject>

- (void)skillLevelPopup:(EHSkillLevelPopup *)popup didSelectLevel:(EHSkillLevel)level;
- (void)skillLevelPopupDidSelectComment:(EHSkillLevelPopup *)popup;

@end

@interface EHSkillLevelPopup : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)goToComment:(UIButton *)sender;
@property (nonatomic, weak) id<EHSkillLevelPopupDelegate> delegate;

@end
