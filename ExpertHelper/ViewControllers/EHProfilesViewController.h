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

@end

@interface EHProfilesViewController : UIViewController
{
    BOOL isPopup;
    BOOL newCell;
    NSInteger RowAtIndexPathOfSkills;
    NSInteger lostData;
}

@property (nonatomic, copy) NSString *skillusLevel;
@property (nonatomic, strong) id <EHProfilesViewControllerDelegate> delegate;

@end
