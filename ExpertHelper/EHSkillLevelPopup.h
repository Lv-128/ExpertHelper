//
//  EHSkillLevelPopup.h
//  ExpertHelper
//
//  Created by Andrii Mamchur on 11/5/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHSkillLevelPopup;

@protocol EHSkillLevelPopupDelegate <NSObject>

- (void)skillLevelPopupDelegate:(EHSkillLevelPopup *)popup didSelectLevel:(BOOL)goToComments;

@end

@interface EHSkillLevelPopup : UIView
@property BOOL goToComments;

- (IBAction)goToComment:(UIButton *)sender;
@property (nonatomic, weak) id<EHSkillLevelPopupDelegate> delegate;

@end
