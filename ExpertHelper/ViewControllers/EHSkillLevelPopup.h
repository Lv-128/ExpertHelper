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

@end

@interface EHSkillLevelPopup : UIView

@property (nonatomic, copy) NSString *skillLevel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) id<EHSkillLevelPopupDelegate> delegate;

@end
