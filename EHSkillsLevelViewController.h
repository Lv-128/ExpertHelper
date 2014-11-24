//
//  EHSkillsLevelViewController.h
//  ExpertHelper
//
//  Created by Katolyk S. on 11/21/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHSkillsLevelViewController;


@protocol EHSkillsLevelDelegate <NSObject>

- (void)skillsLevelDelegate:(EHSkillsLevelViewController *)popover returnSkillsArray:(NSArray *)skillArray;

@end


@interface EHSkillsLevelViewController : UITableViewController

@property (nonatomic, copy) NSArray *skillArray;
@property (nonatomic, copy) NSArray *selectedSkillArray;
@property (nonatomic, weak) id<EHSkillsLevelDelegate> delegate;

@end
