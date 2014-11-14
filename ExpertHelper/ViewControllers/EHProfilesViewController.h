//
//  EHProfilesViewController.h
//  ExpertHelper
//
//  Created by Taras Koval on 11/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHProfilesViewController;


@protocol EHProfilesViewControllerDelegate <NSObject>

//- (void)skillLevelPopupDelegate:(EHSkillLevelPopup *)popup didSelectLevel:(NSInteger)level;
//-(void)tableViews:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath ;
- (void)EHProfilesViewControllerDelegate:(EHProfilesViewController *)popup returnMessage:(NSString *)message2;

@end


@interface EHProfilesViewController : UIViewController
@property (nonatomic, strong) NSString *message2;
@property (nonatomic, strong) id<EHProfilesViewControllerDelegate> delegate;

@end
