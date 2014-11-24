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
}
@property (nonatomic, strong) id<EHProfilesViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *skillLevel;
@property (nonatomic, copy) NSIndexPath *skill;
@end